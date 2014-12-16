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

import com.fundoware.engine.crypto.hash.FunIHash;
import com.fundoware.engine.crypto.hash.FunSHA2_256;
import com.fundoware.engine.exception.FunExceptions;
import haxe.io.Bytes;

class FunBitcoinHash256 implements FunIHash
{
	public function new(sha256 : FunSHA2_256)
	{
		if (sha256 == null)
		{
			throw FunExceptions.FUN_NULL_ARGUMENT;
		}
		m_sha256 = sha256;
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
		m_sha256.finish(digest, offset);
		m_sha256.reset();
		m_sha256.addBytes(digest, offset, FunSHA2_256.kDigestSize);
		m_sha256.finish(digest, offset);
	}

	public function getDigestSize() : Int
	{
		return FunSHA2_256.kDigestSize;
	}

	public function clear() : Void
	{
		m_sha256.clear();
	}

	private var m_sha256 : FunSHA2_256;
}
