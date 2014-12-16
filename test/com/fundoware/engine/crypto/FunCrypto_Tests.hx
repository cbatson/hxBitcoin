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

package com.fundoware.engine.crypto;

import haxe.unit.TestRunner;

class FunCrypto_Tests
{
	public static function AddTests(tr : TestRunner) : Void
	{
		tr.add(new com.fundoware.engine.crypto.FunCryptoUtils_Test());
		tr.add(new com.fundoware.engine.crypto.aes.FunAES_Test());
		com.fundoware.engine.crypto.ec.FunEC_Tests.AddTests(tr);
		com.fundoware.engine.crypto.hash.FunHash_Tests.AddTests(tr);
		tr.add(new com.fundoware.engine.crypto.hmac.FunHMAC_Test());
		com.fundoware.engine.crypto.pbe.FunPBE_Tests.AddTests(tr);
		tr.add(new com.fundoware.engine.crypto.salsa20.FunSalsa20_Test());
		tr.add(new com.fundoware.engine.crypto.scrypt.FunScrypt_Test());
	}
}
