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

package com.fundoware.engine.crypto.scrypt;

import com.fundoware.engine.bigint.FunMultiwordArithmetic;
import com.fundoware.engine.core.FunIClearable;
import com.fundoware.engine.crypto.FunCryptoUtils;
import com.fundoware.engine.crypto.pbe.FunIPBKDF;
import com.fundoware.engine.crypto.pbe.FunPBKDF2_HMAC_SHA256;
import com.fundoware.engine.crypto.salsa20.FunSalsa20;
import com.fundoware.engine.exception.FunExceptions;
import com.fundoware.engine.math.FunInteger;
import haxe.ds.Vector;
import haxe.io.Bytes;

// https://www.tarsnap.com/scrypt/scrypt.pdf
// http://en.wikipedia.org/wiki/Scrypt
class FunScrypt implements FunIPBKDF
{
	public function run(password : Bytes, salt : Bytes, iterationCount : Int, dkLen : Int, out : Bytes = null) : Bytes
	{
		// iteration count must be 1 for scrypt
		if (iterationCount != 1)
		{
			throw FunExceptions.FUN_INVALID_ARGUMENT;
		}

		/*
			(B[0] ... B[p−1]) <- PBKDF2_PRF(P, S, 1, p * MFLen)
			for i = 0 to p − 1 do
				B[i] <- MF(B[i], N)
			end for
			DK <- PBKDF2_PRF(P, B[0] || B[1] || ... || B[p−1], 1, dkLen)
		*/
		m_kdf.run(password, salt, 1, (m_p * m_MFLen_w) << 2, m_Bb);
		FunCryptoUtils.bytesToIntsLE(m_Bi, m_Bb, m_p * m_MFLen_w);
		for (i in 0 ... m_p)
		{
			SMix(i * m_MFLen_w);
		}
		FunCryptoUtils.intsToBytesLE(m_Bb, m_Bi, m_p * m_MFLen_w);
		return m_kdf.run(password, m_Bb, 1, dkLen, out);
	}

	/**
		This implementation requires `N` to be a power of 2.
	**/
	public function new(N : Int, r : Int, p : Int, kdf : FunPBKDF2_HMAC_SHA256) : Void
	{
		if ((N < 2) || (!FunInteger.isPowerOf2(N)))
		{
			throw FunExceptions.FUN_INVALID_ARGUMENT;
		}
		if ((r < 1) || (p < 1))
		{
			throw FunExceptions.FUN_INVALID_ARGUMENT;
		}
		if (kdf == null)
		{
			throw FunExceptions.FUN_NULL_ARGUMENT;
		}
		m_kdf = kdf;
		m_MFLen_w = (k_w * r) << 1;
		m_N = N;
		m_r = r;
		m_p = p;
		var bs : Int = m_p * m_MFLen_w;
		m_Bb = Bytes.alloc(bs << 2);
		m_Bi = new Vector<Int>(bs);
		m_X = new Vector<Int>(m_MFLen_w);
		m_Xt = new Vector<Int>(k_w);
		m_V = new Vector<Int>(m_N * m_MFLen_w);
	}

	public function clear() : Void
	{
		m_kdf.clear();
		FunCryptoUtils.clearBytes(m_Bb);
		FunCryptoUtils.clearVectorInt(m_Bi);
		FunCryptoUtils.clearVectorInt(m_V);
		FunCryptoUtils.clearVectorInt(m_X);
		FunCryptoUtils.clearVectorInt(m_Xt);
	}

	private function SMix(offset : Int) : Void
	{
		/*
			X <- B
			for i = 0 to N − 1 do
				V[i] <- X
				X <- H(X)
			end for
			for i = 0 to N − 1 do
				j <- Integerify(X) mod N
				X <- H(X ^ V[j])
			end for
			B' <- X
		*/
		var j : Int;
		Vector.blit(m_Bi, offset, m_V, 0, m_MFLen_w);
		for (i in 1 ... m_N)
		{
			BlockMix(m_V, i * m_MFLen_w, m_V, (i - 1) * m_MFLen_w);
		}
		BlockMix(m_Bi, offset, m_V, (m_N - 1) * m_MFLen_w);
		for (i in 0 ... m_N >> 1)
		{
			j = (m_Bi.get(offset + m_MFLen_w - k_w) & (m_N - 1)) * m_MFLen_w;
			xor2(m_Bi, offset, m_V, j, m_MFLen_w);
			BlockMix(m_X, 0, m_Bi, offset);
			j = (m_X.get(m_MFLen_w - k_w) & (m_N - 1)) * m_MFLen_w;
			xor2(m_X, 0, m_V, j, m_MFLen_w);
			BlockMix(m_Bi, offset, m_X, 0);
		}
	}

	// output must not overlap input
	private function BlockMix(output : Vector<Int>, outputOffset : Int, input : Vector<Int>, inputOffset : Int) : Void
	{
		/*
			X <- B[2r−1]
			for i = 0 to 2r − 1 do
				X <- H(X ^ B[i])
				Y[i] <- X
			end for
			B′ <- (Y[0], Y[2], . . . Y[2r−2], Y[1], Y[3], . . . Y[2r−1])
		*/
		var X = input;
		var Xo = inputOffset + m_MFLen_w - k_w;
		for (i in 0 ... m_r << 1)
		{
			xor3(m_Xt, 0, X, Xo, input, inputOffset + i * k_w, k_w);
			Xo = outputOffset + ((i & 1) * m_r + (i >> 1)) * k_w;
			FunSalsa20.core(output, Xo, m_Xt, 8);
			X = output;
		}
	}

	private static inline function xor2(dest : Vector<Int>, destOff : Int, src : Vector<Int>, srcOff : Int, length : Int) : Void
	{
		for (i in 0 ... length)
		{
			dest.set(destOff + i, dest.get(destOff + i) ^ src.get(srcOff + i));
		}
	}

	private static inline function xor3(dest : Vector<Int>, destOff : Int, src1 : Vector<Int>, src1Off : Int, src2 : Vector<Int>, src2Off : Int, length : Int) : Void
	{
		for (i in 0 ... length)
		{
			dest.set(destOff + i, src1.get(src1Off + i) ^ src2.get(src2Off + i));
		}
	}

	private var m_kdf : FunPBKDF2_HMAC_SHA256;
	private var m_N : Int;
	private var m_r : Int;
	private var m_p : Int;
	private var m_MFLen_w : Int;
	private var m_Bb : Bytes;
	private var m_Bi : Vector<Int>;
	private var m_V : Vector<Int>;
	private var m_X : Vector<Int>;
	private var m_Xt : Vector<Int>;
	private static inline var k_w : Int = FunSalsa20.kBlockSize >> 2;
}
