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

package com.fundoware.engine.bitcoin;

import com.fundoware.engine.bigint.FunBigIntArithmetic;
import com.fundoware.engine.bigint.FunMutableBigInt;
import com.fundoware.engine.core.FunIClearable;
import com.fundoware.engine.core.FunUtils;
import com.fundoware.engine.crypto.FunCryptoUtils;
import com.fundoware.engine.exception.FunExceptions;
import haxe.io.Bytes;

class FunBase58Check implements FunIClearable
{
	public function encode(payload : Bytes) : String
	{
		m_hash.reset();
		m_hash.addBytes(payload, 0, payload.length);
		m_hash.finish(m_digest, 0);
		m_work = FunCryptoUtils.safeAlloc(m_work, payload.length + 4);
		m_work.blit(0, payload, 0, payload.length);
		m_work.blit(payload.length, m_digest, 0, 4);
		return encodeNoChecksum(m_work, payload.length + 4);
	}

	public function decode(string : String) : Bytes
	{
		m_work = FunCryptoUtils.safeAlloc(m_work, string.length);	// byte length is always <= string length
		var length = decodeNoChecksum(string, m_work);
		if (length < 5)
		{
			throw FunExceptions.FUN_INVALID_ARGUMENT;
		}
		m_hash.reset();
		m_hash.addBytes(m_work, 0, length - 4);
		m_hash.finish(m_digest, 0);
		if (
			(m_work.get(length - 4) != m_digest.get(0)) ||
			(m_work.get(length - 3) != m_digest.get(1)) ||
			(m_work.get(length - 2) != m_digest.get(2)) ||
			(m_work.get(length - 1) != m_digest.get(3))
		) {
			throw FunExceptions.FUN_CHECKSUM_MISMATCH;
		}
		var result = Bytes.alloc(length - 4);
		result.blit(0, m_work, 0, length - 4);
		return result;
	}

	public function new(hash : FunBitcoinHash256) : Void
	{
		if (hash == null)
		{
			throw FunExceptions.FUN_NULL_ARGUMENT;
		}
		m_hash = hash;
		m_digest = Bytes.alloc(m_hash.getDigestSize());
		m_a = 0;
		m_b = 0;
	}

	public function clear() : Void
	{
		m_hash.clear();
		FunCryptoUtils.clearBytes(m_work);
		FunCryptoUtils.clearBytes(m_digest);
		m_a.clear();
		m_b.clear();
	}

	public function encodeNoChecksum(input : Bytes, inputLength : Int) : String
	{
		m_a.setFromBigEndianBytesUnsigned(input, 0, inputLength);
		var r : Int = 0;
		var sb = new StringBuf();	// TODO: can StringBuf be reused & cleared?
		while (!m_a.isZero())
		{
			r = FunBigIntArithmetic.divideInt(m_a, 58, m_a, m_b);
			sb.addChar(s_alpha.charCodeAt(r));
		}
		for (i in 0 ... input.length)
		{
			if (input.get(i) != 0)
			{
				break;
			}
			sb.addChar(s_alpha.charCodeAt(0));
		}
		var s = sb.toString();		// TODO: possible leak of sensitive data as this string
		sb = new StringBuf();		// TODO: can StringBuf be reused & cleared?
		var i = s.length;
		while (--i >= 0)
		{
			sb.addChar(s.charCodeAt(i));
		}
		return sb.toString();
	}

	public function decodeNoChecksum(input : String, result : Bytes) : Int
	{
		if (result == null)
		{
			throw FunExceptions.FUN_NULL_ARGUMENT;
		}
		m_a.setFromInt(0);
		m_b.setFromInt(0);
		var v : Int;
		for (i in 0 ... input.length)
		{
			v = input.charCodeAt(i);
			if ((49 <= v) && (v <= 122))
			{
				v = s_decode.get(v - 49);
				if ((v < 0) || (v > 57))
				{
					throw FunExceptions.FUN_INVALID_ARGUMENT;
				}
			}
			else
			{
				throw FunExceptions.FUN_INVALID_ARGUMENT;
			}
			FunBigIntArithmetic.multiplyInt(m_b, m_a, 58);
			FunBigIntArithmetic.addInt(m_a, m_b, v);
		}
		var bytes1 = m_a.toBytes();		// TODO: fill into buffer we control
		var leadingOnes : Int = 0;
		for (i in 0 ... input.length)
		{
			if (input.charCodeAt(i) != 49)
			{
				break;
			}
			++leadingOnes;
		}
		var skip : Int = 0;
		for (i in 0 ... bytes1.length)
		{
			if (bytes1.get(i) != 0)
			{
				break;
			}
			++skip;
		}
		var length : Int = bytes1.length + leadingOnes - skip;
		if (result.length < length)
		{
			FunCryptoUtils.clearBytes(bytes1);
			throw FunExceptions.FUN_BUFFER_TOO_SMALL;
		}
		result.fill(0, leadingOnes, 0);
		result.blit(leadingOnes, bytes1, skip, bytes1.length - skip);
		FunCryptoUtils.clearBytes(bytes1);	// TODO: can eliminate this when we fill into our own buffer
		return length;
	}

	private static var s_alpha = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";
	private static var s_decode = FunUtils.hexToBytes("000102030405060708ffffffffffffff090a0b0c0d0e0f10ff1112131415ff161718191a1b1c1d1e1f20ffffffffffff2122232425262728292a2bff2c2d2e2f30313233343536373839");

	private var m_hash : FunBitcoinHash256;
	private var m_digest : Bytes;
	private var m_work : Bytes;
	private var m_a : FunMutableBigInt;
	private var m_b : FunMutableBigInt;
}
