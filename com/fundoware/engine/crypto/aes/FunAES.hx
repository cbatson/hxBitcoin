/*===========================================================================

hxBitcoin - pure HaXe cryptocurrency & cryptography library
http://hxbitcoin.com

Copyright (c) 2014 Charles H. Batson III

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

===========================================================================*/

package com.fundoware.engine.crypto.aes;

import com.fundoware.engine.core.FunUtils;
import com.fundoware.engine.crypto.FunCryptoUtils;
import com.fundoware.engine.crypto.FunIBlockCipher;
import com.fundoware.engine.crypto.util.CBC;
import com.fundoware.engine.exception.FunExceptions;
import haxe.ds.Vector;
import haxe.io.Bytes;
import haxe.io.BytesData;

// http://csrc.nist.gov/publications/fips/fips197/fips-197.pdf

class FunAES implements FunIBlockCipher
{
	//-----------------------------------------------------------------------
	// Public interface
	//-----------------------------------------------------------------------

	public static inline var kBlockSize : Int = 16;

	/**
		`ciphertextOut` may point to `plaintextIn`.
	**/
	public function encryptCBC(plaintextIn : Bytes, initialVectorIn : Bytes, ciphertextOut : Bytes) : Void
	{
		CBC.encrypt(ciphertextOut, plaintextIn, kBlockSize, encrypt, initialVectorIn);
	}

	/**
		`plaintextOut` may point to `ciphertextIn`.
	**/
	public function decryptCBC(ciphertextIn : Bytes, initialVectorIn : Bytes, plaintextOut : Bytes) : Void
	{
		CBC.decrypt(plaintextOut, ciphertextIn, kBlockSize, decrypt, initialVectorIn);
	}

	public function getBlockSize() : Int
	{
		return kBlockSize;
	}

	public function setKey(key : Bytes) : Void
	{
		var keyLength = key.length;
		if ((keyLength != 16) && (keyLength != 24) && (keyLength != 32))
		{
			throw FunExceptions.FUN_INVALID_ARGUMENT;
		}
		m_Nk = keyLength >> 2;
		m_Nr = m_Nk + 6;
		KeyExpansion(key.getData());
	}

	public function encrypt(src : Bytes, srcOffset : Int, dst : Bytes, dstOffset : Int) : Void
	{
		if (srcOffset + kBlockSize > src.length)
		{
			throw FunExceptions.FUN_BUFFER_TOO_SMALL;
		}
		if (dstOffset + kBlockSize > dst.length)
		{
			throw FunExceptions.FUN_BUFFER_TOO_SMALL;
		}

		var srcData = src.getData();
		m_c0 = wordBytes(srcData, srcOffset     );
		m_c1 = wordBytes(srcData, srcOffset +  4);
		m_c2 = wordBytes(srcData, srcOffset +  8);
		m_c3 = wordBytes(srcData, srcOffset + 12);

		AddRoundKey(0);
		for (round in 1 ... m_Nr)
		{
			SubBytes();
			ShiftRows();
			MixColumns();
			AddRoundKey(round);
		}
		SubBytes();
		ShiftRows();
		AddRoundKey(m_Nr);

		putWord(dst, dstOffset     , m_c0);
		putWord(dst, dstOffset +  4, m_c1);
		putWord(dst, dstOffset +  8, m_c2);
		putWord(dst, dstOffset + 12, m_c3);
	}

	public function decrypt(src : Bytes, srcOffset : Int, dst : Bytes, dstOffset : Int) : Void
	{
		if (srcOffset + kBlockSize > src.length)
		{
			throw FunExceptions.FUN_BUFFER_TOO_SMALL;
		}
		if (dstOffset + kBlockSize > dst.length)
		{
			throw FunExceptions.FUN_BUFFER_TOO_SMALL;
		}

		var srcData = src.getData();
		m_c0 = wordBytes(srcData, srcOffset     );
		m_c1 = wordBytes(srcData, srcOffset +  4);
		m_c2 = wordBytes(srcData, srcOffset +  8);
		m_c3 = wordBytes(srcData, srcOffset + 12);

		AddRoundKey(m_Nr);
		var round = m_Nr;
		while (--round > 0)
		{
			InvShiftRows();
			InvSubBytes();
			AddRoundKey(round);
			InvMixColumns();
		}
		InvShiftRows();
		InvSubBytes();
		AddRoundKey(0);

		putWord(dst, dstOffset     , m_c0);
		putWord(dst, dstOffset +  4, m_c1);
		putWord(dst, dstOffset +  8, m_c2);
		putWord(dst, dstOffset + 12, m_c3);
 	}

	public function clear() : Void
	{
		FunCryptoUtils.clearVectorInt(m_w);
		m_c0 = 0;
		m_c1 = 0;
		m_c2 = 0;
		m_c3 = 0;
	}

	public function new(key : Bytes = null) : Void
	{
		var s = FunUtils.hexToBytes("637c777bf26b6fc53001672bfed7ab76ca82c97dfa5947f0add4a2af9ca472c0b7fd9326363ff7cc34a5e5f171d8311504c723c31896059a071280e2eb27b27509832c1a1b6e5aa0523bd6b329e32f8453d100ed20fcb15b6acbbe394a4c58cfd0efaafb434d338545f9027f503c9fa851a3408f929d38f5bcb6da2110fff3d2cd0c13ec5f974417c4a77e3d645d197360814fdc222a908846eeb814de5e0bdbe0323a0a4906245cc2d3ac629195e479e7c8376d8dd54ea96c56f4ea657aae08ba78252e1ca6b4c6e8dd741f4bbd8b8a703eb5664803f60e613557b986c11d9ee1f8981169d98e949b1e87e9ce5528df8ca1890dbfe6426841992d0fb054bb16");
		m_S = s.getData();

		s = Bytes.alloc(256);
		for (i in 0 ... 256)
		{
			s.set(Bytes.fastGet(m_S, i), i);
		}
		m_iS = s.getData();

		s = Bytes.alloc(256);
		for (i in 0 ... 128)
		{
			s.set(i, i << 1);
			s.set(i + 128, (i << 1) ^ 0x1b);
		}
		m_xtime = s.getData();

		m_w = new Vector<Int>(64);

		if (key != null)
		{
			setKey(key);
		}
	}

	//-----------------------------------------------------------------------
	// Private implementation
	//-----------------------------------------------------------------------

	private inline function MixColumns() : Void
	{
		m_c0 = MixColumn(m_c0);
		m_c1 = MixColumn(m_c1);
		m_c2 = MixColumn(m_c2);
		m_c3 = MixColumn(m_c3);
	}

	private inline function InvMixColumns() : Void
	{
		m_c0 = InvMixColumn(m_c0);
		m_c1 = InvMixColumn(m_c1);
		m_c2 = InvMixColumn(m_c2);
		m_c3 = InvMixColumn(m_c3);
	}

	private inline function MixColumn(c : Int) : Int
	{
		// See M. Kim, J. Kim, and Y. Choi, "Low Power Circuit Architecture of AES Crypto Module for Wireless Sensor Network"
		// http://citeseerx.ist.psu.edu/viewdoc/download;jsessionid=0A86070A8DD1BC6917640F496158ABDF?doi=10.1.1.193.1411&rep=rep1&type=pdf
		var a0 : Int = (c >> 24) & 0xff;
		var a1 : Int = (c >> 16) & 0xff;
		var a2 : Int = (c >>  8) & 0xff;
		var a3 : Int = (c      ) & 0xff;
		var t : Int = a0 ^ a1 ^ a2 ^ a3;
		return word(
			Bytes.fastGet(m_xtime, a0 ^ a1) ^ t ^ a0,
			Bytes.fastGet(m_xtime, a1 ^ a2) ^ t ^ a1,
			Bytes.fastGet(m_xtime, a2 ^ a3) ^ t ^ a2,
			Bytes.fastGet(m_xtime, a3 ^ a0) ^ t ^ a3
		);
	}

	private inline function InvMixColumn(c : Int) : Int
	{
		/*
			s0' = 14s0 + 11s1 + 13s2 +  9s3
			s1' =  9s0 + 14s1 + 11s2 + 13s3
			s2' = 13s0 +  9s1 + 14s2 + 11s3
			s3' = 11s3 + 13s1 +  9s2 + 14s3

			a = s0 + s1 + s2 + s3
			b = 2a
			c0 = 4(b + s0 + s2)
			c1 = 4(b + s1 + s3)

			s0' = c0 + a + 2(s0 + s1) + s0
			s1' = c1 + a + 2(s1 + s2) + s1
			s2' = c0 + a + 2(s2 + s3) + s2
			s3' = c1 + a + 2(s3 + s0) + s3
		*/
		var s0 : Int = (c >> 24) & 0xff;
		var s1 : Int = (c >> 16) & 0xff;
		var s2 : Int = (c >>  8) & 0xff;
		var s3 : Int = (c      ) & 0xff;
		var a : Int = s0 ^ s1 ^ s2 ^ s3;
		var b : Int = Bytes.fastGet(m_xtime, a);
		var c0a : Int = Bytes.fastGet(m_xtime, Bytes.fastGet(m_xtime, b ^ s0 ^ s2)) ^ a;
		var c1a : Int = Bytes.fastGet(m_xtime, Bytes.fastGet(m_xtime, b ^ s1 ^ s3)) ^ a;
		return word(
			c0a ^ s0 ^ Bytes.fastGet(m_xtime, s0 ^ s1),
			c1a ^ s1 ^ Bytes.fastGet(m_xtime, s1 ^ s2),
			c0a ^ s2 ^ Bytes.fastGet(m_xtime, s2 ^ s3),
			c1a ^ s3 ^ Bytes.fastGet(m_xtime, s3 ^ s0)
		);
	}

	private inline function ShiftRows() : Void
	{
		var t0 = m_c0;
		var t1 = m_c1;
		var t2 = m_c2;
		var t3 = m_c3;
		m_c0 = (t0 & 0xff000000) | (t1 & 0x00ff0000) | (t2 & 0x0000ff00) | (t3 & 0x000000ff);
		m_c1 = (t1 & 0xff000000) | (t2 & 0x00ff0000) | (t3 & 0x0000ff00) | (t0 & 0x000000ff);
		m_c2 = (t2 & 0xff000000) | (t3 & 0x00ff0000) | (t0 & 0x0000ff00) | (t1 & 0x000000ff);
		m_c3 = (t3 & 0xff000000) | (t0 & 0x00ff0000) | (t1 & 0x0000ff00) | (t2 & 0x000000ff);
	}

	private inline function InvShiftRows() : Void
	{
		var t0 = m_c0;
		var t1 = m_c1;
		var t2 = m_c2;
		var t3 = m_c3;
		m_c0 = (t0 & 0xff000000) | (t3 & 0x00ff0000) | (t2 & 0x0000ff00) | (t1 & 0x000000ff);
		m_c1 = (t1 & 0xff000000) | (t0 & 0x00ff0000) | (t3 & 0x0000ff00) | (t2 & 0x000000ff);
		m_c2 = (t2 & 0xff000000) | (t1 & 0x00ff0000) | (t0 & 0x0000ff00) | (t3 & 0x000000ff);
		m_c3 = (t3 & 0xff000000) | (t2 & 0x00ff0000) | (t1 & 0x0000ff00) | (t0 & 0x000000ff);
	}

	private inline function SubBytes() : Void
	{
		m_c0 = SubWord(m_c0);
		m_c1 = SubWord(m_c1);
		m_c2 = SubWord(m_c2);
		m_c3 = SubWord(m_c3);
	}

	private inline function InvSubBytes() : Void
	{
		m_c0 = InvSubWord(m_c0);
		m_c1 = InvSubWord(m_c1);
		m_c2 = InvSubWord(m_c2);
		m_c3 = InvSubWord(m_c3);
	}

	private inline function AddRoundKey(round : Int) : Void
	{
		round <<= 2;
		m_c0 ^= m_w.get(round    );
		m_c1 ^= m_w.get(round + 1);
		m_c2 ^= m_w.get(round + 2);
		m_c3 ^= m_w.get(round + 3);
	}

	private function KeyExpansion(key : BytesData) : Void
	{
		for (i in 0 ... m_Nk)
		{
			m_w.set(i, wordBytes(key, i << 2));
		}
		var i = m_Nk;
		var j = 0;
		var end = (m_Nr + 1) << 2;
		var Rcon = 1;
		var temp = m_w.get(m_Nk - 1);
		while (i < end)
		{
			temp = SubWord(RotWord(temp)) ^ (Rcon << 24);
			Rcon = Bytes.fastGet(m_xtime, Rcon);
			m_w.set(i    , temp ^= m_w.get(j    ));
			m_w.set(i + 1, temp ^= m_w.get(j + 1));
			m_w.set(i + 2, temp ^= m_w.get(j + 2));
			m_w.set(i + 3, temp ^= m_w.get(j + 3));
			if (m_Nk == 6)
			{
				m_w.set(i + 4, temp ^= m_w.get(j + 4));
				m_w.set(i + 5, temp ^= m_w.get(j + 5));
			}
			else if (m_Nk == 8)
			{
				temp = SubWord(temp);
				m_w.set(i + 4, temp ^= m_w.get(j + 4));
				m_w.set(i + 5, temp ^= m_w.get(j + 5));
				m_w.set(i + 6, temp ^= m_w.get(j + 6));
				m_w.set(i + 7, temp ^= m_w.get(j + 7));
			}
			i += m_Nk;
			j += m_Nk;
		}
	}

	private inline function SubWord(input : Int) : Int
	{
		return word(
			Bytes.fastGet(m_S, (input >> 24) & 0xff),
			Bytes.fastGet(m_S, (input >> 16) & 0xff),
			Bytes.fastGet(m_S, (input >>  8) & 0xff),
			Bytes.fastGet(m_S, (input      ) & 0xff));
	}

	private inline function InvSubWord(input : Int) : Int
	{
		return word(
			Bytes.fastGet(m_iS, (input >> 24) & 0xff),
			Bytes.fastGet(m_iS, (input >> 16) & 0xff),
			Bytes.fastGet(m_iS, (input >>  8) & 0xff),
			Bytes.fastGet(m_iS, (input      ) & 0xff));
	}

	private static inline function RotWord(input : Int) : Int
	{
		return (input << 8) | (input >>> 24);
	}

	private static inline function wordBytes(data : BytesData, offset : Int) : Int
	{
		return word(Bytes.fastGet(data, offset), Bytes.fastGet(data, offset + 1), Bytes.fastGet(data, offset + 2), Bytes.fastGet(data, offset + 3));
	}

	private static inline function word(a : Int, b : Int, c : Int, d : Int) : Int
	{
		return (a << 24) | (b << 16) | (c << 8) | d;
	}

	private static inline function putWord(data : Bytes, offset : Int, value : Int) : Void
	{
		data.set(offset    , (value >> 24) & 0xff);
		data.set(offset + 1, (value >> 16) & 0xff);
		data.set(offset + 2, (value >>  8) & 0xff);
		data.set(offset + 3, (value      ) & 0xff);
	}

	private var m_S : BytesData;
	private var m_iS : BytesData;
	private var m_xtime : BytesData;
	private var m_Nk : Int;
	private var m_Nr : Int;
	private var m_c0 : Int;
	private var m_c1 : Int;
	private var m_c2 : Int;
	private var m_c3 : Int;
	private var m_w : Vector<Int>;
}
