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

import com.fundoware.engine.test.FunTestCase;
import com.fundoware.engine.test.FunTestUtils;
import haxe.ds.Vector;
import haxe.io.Bytes;
import haxe.io.BytesData;

class FunCryptoUtils_Test extends FunTestCase
{
	public function testSafeAlloc() : Void
	{
		var a = FunCryptoUtils.safeAlloc(null, 10);
		a.fill(0, a.length, 0xaa);
		for (i in 0 ... 10)
		{
			assertEquals(0xaa, a.get(i));
		}
		var b = FunCryptoUtils.safeAlloc(a, 20);
		assertTrue(a != b);

		for (i in 0 ... 10)
		{
			assertEquals(0, a.get(i));
		}
	}

	public function testClearVectorInt() : Void
	{
		var a = new Vector<Int>(10);
		for (i in 0 ... a.length)
		{
			a[i] = i + 1;
		}
		for (i in 0 ... a.length)
		{
			assertEquals(i + 1, a[i]);
		}
		FunCryptoUtils.clearVectorInt(a);
		for (i in 0 ... a.length)
		{
			assertEquals(0, a[i]);
		}

		FunCryptoUtils.clearVectorInt(null);
	}

	public function testClearArrayInt() : Void
	{
		var a = new Array<Int>();
		for (i in 0 ... 10)
		{
			a.push(i + 1);
		}
		for (i in 0 ... a.length)
		{
			assertEquals(i + 1, a[i]);
		}
		FunCryptoUtils.clearArrayInt(a);
		for (i in 0 ... a.length)
		{
			assertEquals(0, a[i]);
		}

		FunCryptoUtils.clearArrayInt(null);
	}

	public function testClearBytes() : Void
	{
		var b = FunTestUtils.MakeBytes(0xaa, 20);
		FunCryptoUtils.clearBytes(b);
		for (i in 0 ... 20)
		{
			assertEquals(0, b.get(i));
		}

		FunCryptoUtils.clearBytes(null);
	}

	public function testXOR() : Void
	{
		var src1 = Bytes.alloc(16);
		//var src2 = Bytes.alloc(16);
		var dst = Bytes.alloc(16);
		for (i in 0 ... 16)
		{
			var x = (i << 4) | i;
			src1.set(i, x);
		}

		dst.set(0, 0xcb);
		dst.set(3, 0xca);
		FunCryptoUtils.XOR(dst, 1, src1, 1, src1, 2, 2);
		assertEquals(0xcb, dst.get(0));
		assertEquals(0x33, dst.get(1));
		assertEquals(0x11, dst.get(2));
		assertEquals(0xca, dst.get(3));

		dst.set(2, 0xcb);
		FunCryptoUtils.XOR(dst, 0, src1, 2, src1, 3, 2);
		assertEquals(0x11, dst.get(0));
		assertEquals(0x77, dst.get(1));
		assertEquals(0xcb, dst.get(2));
	}
}
