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

import com.fundoware.engine.crypto.FunCryptoUtils;
import com.fundoware.engine.crypto.hash.FunIHash;
import com.fundoware.engine.crypto.hash.FunRIPEMD160;
import com.fundoware.engine.crypto.hash.FunSHA2_256;
import com.fundoware.engine.exception.FunExceptions;
import haxe.io.Bytes;

class FunBitcoinHash160 implements FunIHash
{
	public function new(sha256 : FunSHA2_256, ripemd160 : FunRIPEMD160)
	{
		if ((sha256 == null) || (ripemd160 == null))
		{
			throw FunExceptions.FUN_NULL_ARGUMENT;
		}
		m_sha256 = sha256;
		m_ripemd160 = ripemd160;
	}

	public function reset() : Void
	{
		m_sha256.reset();
	}

	public function addByte(byte : Int) : Void
	{
		m_sha256.addByte(byte);
	}

	public function addBytes(bytes : Bytes, offset : Int, length : Int) : Void
	{
		m_sha256.addBytes(bytes, offset, length);
	}

	public function finish(digest : Bytes, offset : Int) : Void
	{
		if (m_digest == null)
		{
			m_digest = Bytes.alloc(FunSHA2_256.kDigestSize);
		}
		m_sha256.finish(m_digest, 0);
		m_ripemd160.reset();
		m_ripemd160.addBytes(m_digest, 0, FunSHA2_256.kDigestSize);
		m_ripemd160.finish(digest, offset);
	}

	public function getDigestSize() : Int
	{
		return FunRIPEMD160.kDigestSize;
	}

	public function clear() : Void
	{
		m_sha256.clear();
		m_ripemd160.clear();
		FunCryptoUtils.clearBytes(m_digest);
	}

	private var m_sha256 : FunSHA2_256;
	private var m_ripemd160 : FunRIPEMD160;
	private var m_digest : Bytes;
}
