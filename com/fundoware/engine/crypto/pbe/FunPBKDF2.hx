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

package com.fundoware.engine.crypto.pbe;

import com.fundoware.engine.core.FunIClearable;
import com.fundoware.engine.crypto.FunCryptoUtils;
import com.fundoware.engine.exception.FunExceptions;
import haxe.io.Bytes;

// Password Based Encryption
class FunPBKDF2 implements FunIClearable
{
	// Password-based key derivation function
	// http://www.ietf.org/rfc/rfc2898.txt
	public function PBKDF2(password : Bytes, salt : Bytes, iterationCount : Int, dkLen : Int, pseudoRandomFunc : Bytes->Bytes->Int->Bytes->Void, hashLength : Int, out : Bytes = null) : Bytes
	{
		if (out == null)
		{
			out = Bytes.alloc(dkLen);
		}
		else if (out.length < dkLen)
		{
			throw FunExceptions.FUN_BUFFER_TOO_SMALL;
		}
		var outIndex : Int = 0;

		var l : Int = Std.int((dkLen + hashLength - 1) / hashLength);
		T = FunCryptoUtils.safeAlloc(T, hashLength);
		U = FunCryptoUtils.safeAlloc(U, hashLength);
		saltWork = FunCryptoUtils.safeAlloc(saltWork, salt.length + 4);
		saltWork.blit(0, salt, 0, salt.length);
		for (block in 1 ... l + 1)
		{
			saltWork.set(salt.length + 0, block >> 24);
			saltWork.set(salt.length + 1, block >> 16);
			saltWork.set(salt.length + 2, block >>  8);
			saltWork.set(salt.length + 3, block >>  0);
			pseudoRandomFunc(password, saltWork, salt.length + 4, T);
			var input = T;
			for (j in 1 ... iterationCount)
			{
				pseudoRandomFunc(password, input, hashLength, U);
				input = U;
				for (k in 0 ... hashLength)
				{
					T.set(k, T.get(k) ^ U.get(k));
				}
			}
			var len : Int = hashLength;
			if (outIndex + hashLength > dkLen)
			{
				len = dkLen - outIndex;
			}
			out.blit(outIndex, T, 0, len);
			outIndex += hashLength;
		}

		return out;
	}

	public function clear() : Void
	{
		FunCryptoUtils.clearBytes(T);
		FunCryptoUtils.clearBytes(U);
		FunCryptoUtils.clearBytes(saltWork);
	}

	public function new() : Void
	{
	}

	private var T : Bytes;
	private var U : Bytes;
	private var saltWork : Bytes;
}
