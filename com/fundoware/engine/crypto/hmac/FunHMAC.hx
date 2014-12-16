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

package com.fundoware.engine.crypto.hmac;

import com.fundoware.engine.crypto.FunCryptoUtils;
import com.fundoware.engine.exception.FunExceptions;
import com.fundoware.engine.crypto.hash.FunIHash;
import com.fundoware.engine.crypto.hash.FunSHA1;
import haxe.io.Bytes;

// Hash-based message authentication code
class FunHMAC
{
	// http://www.ietf.org/rfc/rfc2104.txt
	public function HMAC(key : Bytes, message : Bytes, messageLength : Int, blockSize : Int, out : Bytes = null) : Bytes
	{
		var digestSize : Int = m_hash.getDigestSize();
		if (out == null)
		{
			out = Bytes.alloc(digestSize);
		}
		else if (out.length < digestSize)
		{
			throw FunExceptions.FUN_BUFFER_TOO_SMALL;
		}

		if (key.length > blockSize)
		{
			// large key, hash it
			m_hash.reset();
			m_hash.addBytes(key, 0, key.length);
			m_keyTmp = FunCryptoUtils.safeAlloc(m_keyTmp, digestSize);
			m_hash.finish(m_keyTmp, 0);
			key = m_keyTmp;
		}
		m_keyWork = FunCryptoUtils.safeAlloc(m_keyWork, blockSize);
		m_keyWork.blit(0, key, 0, key.length);
		m_keyWork.fill(key.length, blockSize - key.length, 0);

		m_hash.reset();
		for (i in 0 ... blockSize)
		{
			m_hash.addByte(m_keyWork.get(i) ^ 0x36);
		}
		m_hash.addBytes(message, 0, messageLength);
		m_hash.finish(out, 0);

		m_hash.reset();
		for (i in 0 ... blockSize)
		{
			m_hash.addByte(m_keyWork.get(i) ^ 0x5c);
		}
		m_hash.addBytes(out, 0, digestSize);
		m_hash.finish(out, 0);

		return out;
	}

	public function new(hash : FunIHash) : Void
	{
		if (hash == null)
		{
			throw FunExceptions.FUN_NULL_ARGUMENT;
		}
		m_hash = hash;
	}

	public function clear() : Void
	{
		FunCryptoUtils.clearBytes(m_keyWork);
		FunCryptoUtils.clearBytes(m_keyTmp);
		m_hash.clear();
	}

	private var m_hash : FunIHash;
	private var m_keyWork : Bytes;
	private var m_keyTmp : Bytes;
}
