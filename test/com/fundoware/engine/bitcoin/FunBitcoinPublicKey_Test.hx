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

import com.fundoware.engine.test.FunTestCase;

class FunBitcoinPublicKey_Test extends FunTestCase
{
	public function testCompressed() : Void
	{
		var context = new FunBitcoinContext();
		var pt = context.getCurve().newPoint("0xf028892bad7ed57d2fb57bf33081d5cfcf6f9ed3d3d7f159c2e2fff579dc341a", "0x07cf33da18bd734c600b96a72bbc4749d5141c90ec8ac328ae52ddfe2e505bdb");
		var pubKey = FunBitcoinPublicKey.fromPoint(context, pt, false);
		assertEquals("04f028892bad7ed57d2fb57bf33081d5cfcf6f9ed3d3d7f159c2e2fff579dc341a07cf33da18bd734c600b96a72bbc4749d5141c90ec8ac328ae52ddfe2e505bdb", pubKey.toBytes().toHex());
		var pubKeyComp = FunBitcoinPublicKey.fromPublicKey(pubKey, true);
		assertEquals("03f028892bad7ed57d2fb57bf33081d5cfcf6f9ed3d3d7f159c2e2fff579dc341a", pubKeyComp.toBytes().toHex());
	}

	public function testPointsWithLeadingZeros() : Void
	{
		// This test checks points the result in having leading zeros
		var context = new FunBitcoinContext();
		var pt = context.getCurve().newPoint("0x 40000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000", "0x 40000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000");
		var pubKey = FunBitcoinPublicKey.fromPoint(context, pt, false);
		assertEquals("0440000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000", pubKey.toBytes().toHex());
		pt = context.getCurve().newPoint("0x 80000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000", "0x 40000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000");
		pubKey = FunBitcoinPublicKey.fromPoint(context, pt, false);
		assertEquals("0480000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000", pubKey.toBytes().toHex());
		pt = context.getCurve().newPoint("0x 40000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000", "0x 80000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000");
		pubKey = FunBitcoinPublicKey.fromPoint(context, pt, false);
		assertEquals("0440000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000", pubKey.toBytes().toHex());
		pt = context.getCurve().newPoint("0x 80000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000", "0x 80000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000");
		pubKey = FunBitcoinPublicKey.fromPoint(context, pt, false);
		assertEquals("0480000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000", pubKey.toBytes().toHex());

		pt = context.getCurve().newPoint("0x 00000000 40000000 00000000 00000000 00000000 00000000 00000000 00000000", "0x 00000000 40000000 00000000 00000000 00000000 00000000 00000000 00000000");
		pubKey = FunBitcoinPublicKey.fromPoint(context, pt, false);
		assertEquals("0400000000400000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000", pubKey.toBytes().toHex());
		pt = context.getCurve().newPoint("0x 00000000 80000000 00000000 00000000 00000000 00000000 00000000 00000000", "0x 00000000 40000000 00000000 00000000 00000000 00000000 00000000 00000000");
		pubKey = FunBitcoinPublicKey.fromPoint(context, pt, false);
		assertEquals("0400000000800000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000", pubKey.toBytes().toHex());
		pt = context.getCurve().newPoint("0x 00000000 40000000 00000000 00000000 00000000 00000000 00000000 00000000", "0x 00000000 80000000 00000000 00000000 00000000 00000000 00000000 00000000");
		pubKey = FunBitcoinPublicKey.fromPoint(context, pt, false);
		assertEquals("0400000000400000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000", pubKey.toBytes().toHex());
		pt = context.getCurve().newPoint("0x 00000000 80000000 00000000 00000000 00000000 00000000 00000000 00000000", "0x 00000000 80000000 00000000 00000000 00000000 00000000 00000000 00000000");
		pubKey = FunBitcoinPublicKey.fromPoint(context, pt, false);
		assertEquals("0400000000800000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000", pubKey.toBytes().toHex());
	}
}
