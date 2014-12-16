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

import com.fundoware.engine.crypto.hash.FunSHA1;
import com.fundoware.engine.crypto.hmac.FunHMAC_SHA1;
import com.fundoware.engine.exception.FunExceptions;
import haxe.io.Bytes;

class FunPBKDF2_HMAC_SHA1 extends FunPBKDF2 implements FunIPBKDF
{
	public function run(password : Bytes, salt : Bytes, iterationCount : Int, dkLen : Int, out : Bytes = null) : Bytes
	{
		var PRF = function(password : Bytes, message : Bytes, messageLength : Int, out : Bytes) : Void
		{
			m_hmac.run(password, message, messageLength, out);
		};
		return super.PBKDF2(password, salt, iterationCount, dkLen, PRF, FunSHA1.kDigestSize, out);
	}

	public function new(hmac : FunHMAC_SHA1) : Void
	{
		super();
		if (hmac == null)
		{
			throw FunExceptions.FUN_NULL_ARGUMENT;
		}
		m_hmac = hmac;
	}

	public override function clear() : Void
	{
		super.clear();
		m_hmac.clear();
	}

	private var m_hmac : FunHMAC_SHA1;
}
