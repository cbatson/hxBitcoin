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

import com.fundoware.engine.exception.FunExceptions;
import com.fundoware.engine.test.FunTestCase;
import com.fundoware.engine.test.FunTestUtils;
import haxe.io.Bytes;

class FunPBKDFTestCase extends FunTestCase
{
	public function testTwoInARow() : Void
	{
		var kdf = newKDF();
		var P = Bytes.ofString("password");
		var S = Bytes.ofString("salt");
		var dkLen = 64;
		var result1 = kdf.run(P, S, 1, dkLen);
		var result2 = kdf.run(P, S, 1, dkLen);
		assertEquals(result1.toHex(), result2.toHex());
	}

	public function testTwoInARowSameBuffer() : Void
	{
		doTestTwoInARowSameBuffer(64);
		doTestTwoInARowSameBuffer(128);
	}

	public function testLongShortLongKeys() : Void
	{
		var kdf = newKDF();
		var P = Bytes.ofString("password");
		var S = Bytes.ofString("salt");
		var buf = Bytes.alloc(128);
		kdf.run(P, S, 1, 128, buf);
		var result1 = buf.toHex();
		kdf.run(P, S, 1, 64, buf);
		kdf.run(P, S, 1, 128, buf);
		var result2 = buf.toHex();
		assertEquals(result1, result2);
	}

	public function testShortLongShortSalt() : Void
	{
		var kdf = newKDF();
		var P = Bytes.ofString("password");
		var S = Bytes.ofString("salt");
		var dkLen = 128;
		var buf = Bytes.alloc(dkLen);
		kdf.run(P, S, 1, dkLen, buf);
		var result1 = buf.toHex();
		kdf.run(P, FunTestUtils.MakeBytes(0xcb, 128), 1, dkLen, buf);
		kdf.run(P, S, 1, dkLen, buf);
		var result2 = buf.toHex();
		assertEquals(result1, result2);
	}

	private function doTestTwoInARowSameBuffer(dkLen : Int) : Void
	{
		var kdf = newKDF();
		var P = Bytes.ofString("password");
		var S = Bytes.ofString("salt");
		var buf = Bytes.alloc(dkLen);
		kdf.run(P, S, 1, dkLen, buf);
		var result1 = buf.toHex();
		kdf.run(P, S, 1, dkLen, buf);
		var result2 = buf.toHex();
		assertEquals(result1, result2);
	}

	public function newKDF() : FunIPBKDF
	{
		throw FunExceptions.FUN_ABSTRACT_METHOD;
	}

	public function new()
	{
		super();
	}
}
