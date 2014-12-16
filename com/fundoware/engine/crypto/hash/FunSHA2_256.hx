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

package com.fundoware.engine.crypto.hash;

import com.fundoware.engine.bigint.FunMultiwordArithmetic;
import com.fundoware.engine.crypto.FunCryptoUtils;
import com.fundoware.engine.crypto.hash.impl.FunBlockHashBase;
import com.fundoware.engine.exception.FunExceptions;
import com.fundoware.engine.math.FunInteger;
import haxe.ds.Vector;
import haxe.io.Bytes;

// See http://csrc.nist.gov/publications/fips/fips180-4/fips-180-4.pdf
class FunSHA2_256 extends FunBlockHashBase implements FunIHash
{
	//-----------------------------------------------------------------------
	// Helpers
	//-----------------------------------------------------------------------

	public static inline function HashString(s : String) : String
	{
		return FunHashTools.HashString(new FunSHA2_256(), s);
	}

	public static inline function HashBytes(data : Bytes) : String
	{
		return FunHashTools.HashBytes(new FunSHA2_256(), data);
	}

	//-----------------------------------------------------------------------
	// Public interface
	//-----------------------------------------------------------------------

	public static inline var kDigestSize : Int = 32;
	public static inline var kBlockSize : Int = 64;

	public function new()
	{
		super(kBlockSize);
		reset();
	}

	public override function reset() : Void
	{
		super.reset();
		h0 = 0x6a09e667;
		h1 = 0xbb67ae85;
		h2 = 0x3c6ef372;
		h3 = 0xa54ff53a;
		h4 = 0x510e527f;
		h5 = 0x9b05688c;
		h6 = 0x1f83d9ab;
		h7 = 0x5be0cd19;
	}

	public function addByte(byte : Int) : Void
	{
		addByteBE(byte);
	}

	public function addBytes(bytes : Bytes, offset : Int, length : Int) : Void
	{
		addBytesBE(bytes, offset, length);
	}

	public function finish(digest : Bytes, offset : Int) : Void
	{
		if ((offset + kDigestSize) > digest.length)
		{
			throw FunExceptions.FUN_BUFFER_TOO_SMALL;
		}

		var len = m_length;
		addByteBE(0x80);
		while ((m_length & 0x3f) != 56)
		{
			addByteBE(0x00);
		}
		m_block.set(14, len >>> 29);
		m_block.set(15, len << 3);
		processBlock();

		FunBlockHashBase.putBE(digest, offset +  0, h0);
		FunBlockHashBase.putBE(digest, offset +  4, h1);
		FunBlockHashBase.putBE(digest, offset +  8, h2);
		FunBlockHashBase.putBE(digest, offset + 12, h3);
		FunBlockHashBase.putBE(digest, offset + 16, h4);
		FunBlockHashBase.putBE(digest, offset + 20, h5);
		FunBlockHashBase.putBE(digest, offset + 24, h6);
		FunBlockHashBase.putBE(digest, offset + 28, h7);
	}

	public function getDigestSize() : Int
	{
		return kDigestSize;
	}

	public function clear() : Void
	{
		super.doClear();
		FunCryptoUtils.clearVectorInt(m_w);
		reset();
	}

	//-----------------------------------------------------------------------
	// Private implementation
	//-----------------------------------------------------------------------

	private override function processBlock() : Void
	{
		Vector.blit(m_block, 0, m_w, 0, 16);

		var ch : Int, maj : Int, s0 : Int, s1 : Int, temp1 : Int, temp2 : Int;

		for (i in 16 ... 64)
		{
			s0 = m_w.get(i - 15);
			s1 = m_w.get(i -  2);
			s0 = FunInteger.rotateRight(s0,  7) ^ FunInteger.rotateRight(s0, 18) ^ (s0 >>>  3);
			s1 = FunInteger.rotateRight(s1, 17) ^ FunInteger.rotateRight(s1, 19) ^ (s1 >>> 10);
			m_w.set(i, m_w.get(i - 16) + s0 + m_w.get(i - 7) + s1);
		}

		var a = h0;
		var b = h1;
		var c = h2;
		var d = h3;
		var e = h4;
		var f = h5;
		var g = h6;
		var h = h7;

		for (i in 0 ... 64)
		{
			s1 = FunInteger.rotateRight(e, 6) ^ FunInteger.rotateRight(e, 11) ^ FunInteger.rotateRight(e, 25);
			ch = (e & f) ^ (~e & g);
			temp1 = h + s1 + ch + s_k.get(i) + m_w.get(i);
			s0 = FunInteger.rotateRight(a, 2) ^ FunInteger.rotateRight(a, 13) ^ FunInteger.rotateRight(a, 22);
			maj = (a & b) ^ (a & c) ^ (b & c);
			temp2 = s0 + maj;

			h = g;
			g = f;
			f = e;
			e = d + temp1;
			d = c;
			c = b;
			b = a;
			a = temp1 + temp2;
		}

		h0 += a;
		h1 += b;
		h2 += c;
		h3 += d;
		h4 += e;
		h5 += f;
		h6 += g;
		h7 += h;
	}

	private var h0 : Int;
	private var h1 : Int;
	private var h2 : Int;
	private var h3 : Int;
	private var h4 : Int;
	private var h5 : Int;
	private var h6 : Int;
	private var h7 : Int;
	private var m_w = new Vector<Int>(64);
	private static var s_k = Vector.fromArrayCopy([
		0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
		0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
		0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
		0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
		0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
		0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
		0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
		0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
	]);
}
