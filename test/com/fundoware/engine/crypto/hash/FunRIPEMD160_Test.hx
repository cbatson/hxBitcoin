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

import com.fundoware.engine.test.FunTestUtils;

class FunRIPEMD160_Test extends FunHashTestCase
{
	public function testBitcoinWikiVectors() : Void
	{
		// Test vectors from https://en.bitcoin.it/wiki/Protocol_specification
		// Retrieved 2014.11.19
		checkHex("2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824", "b6a9c8c230722b7c748331a8b450f05566dc7d0f");
	}

	public function testWebsiteVectors() : Void
	{
		// Test vectors from http://homes.esat.kuleuven.be/~bosselae/ripemd160.html
		// Retrieved 2014.11.19
		checkString("", "9c1185a5c5e9fc54612808977ee8f548b2258d31");
		checkString("a", "0bdc9d2d256b3ee9daae347be6f4dc835a467ffe");
		checkString("abc", "8eb208f7e05d987a9b044a8e98c6b087f15a0bfc");
		checkString("message digest", "5d0689ef49d2fae572b881b123a85ffa21595f36");
		checkString("abcdefghijklmnopqrstuvwxyz", "f71c27109c692c1b56bbdceb5b9d2865b3708dbc");
		checkString("abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq", "12a053384a9c0c88e405a06c27dcf49ada62eb2b");
		checkString("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789", "b0e20b6e3116640286ed3a87a5713079b21f5189");
		checkString("12345678901234567890123456789012345678901234567890123456789012345678901234567890", "9b752e45573d4b39f4dbd3323cab82bf63326bfb");
		checkBinary(FunTestUtils.MakeBytes("a".code, 1000000), "52783243c1697bdbe16d37f97f68f08325dc1528");
	}

	private override function newHash() : FunIHash
	{
		return new FunRIPEMD160();
	}
}
