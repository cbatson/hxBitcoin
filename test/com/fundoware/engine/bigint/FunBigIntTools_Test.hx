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

package com.fundoware.engine.bigint;

class FunBigIntTools_Test extends FunBigIntTestCase
{
	public function testParseBIMakesCopy() : Void
	{
		var a : FunMutableBigInt = FunBigInt.fromHex("123456789abcdef0");
		var b = FunBigIntTools.parseValueUnsigned(a);
		assertEqualsBI(FunBigInt.fromHex("123456789abcdef0"), b);
		a.clear();
		assertEqualsBI(FunBigInt.fromHex("123456789abcdef0"), b);
	}

	public function testIsNull() : Void
	{
		assertEquals(true, FunBigIntTools.isNull(m_a));
		var a : FunMutableBigInt;
		a = 0;
		assertEquals(false, FunBigIntTools.isNull(a));
	}

	public function testFromDynamic() : Void
	{
		assertEquals(null, FunBigIntTools.castFrom(null));
		assertEquals(null, FunBigIntTools.castFrom("whee"));
		assertEquals(null, FunBigIntTools.castFrom(5));
		var a : FunBigInt = 0;
		assertReferenceEquals(a, FunBigIntTools.castFrom(a));
		var b : FunMutableBigInt = 0;
		assertReferenceEquals(b, FunBigIntTools.castFrom(b));
		var c : FunBigInt_ = new FunBigInt_();
		assertReferenceEquals(c, FunBigIntTools.castFrom(c));
		var d : FunMutableBigInt_ = new FunMutableBigInt_();
		assertReferenceEquals(d, FunBigIntTools.castFrom(d));
	}

	public function testIsBigInt() : Void
	{
		assertFalse(FunBigIntTools.isBigInt("whee"));
		assertFalse(FunBigIntTools.isBigInt(5));
		var a : FunBigInt = 0;
		assertTrue(FunBigIntTools.isBigInt(a));
		var b : FunMutableBigInt = 0;
		assertTrue(FunBigIntTools.isBigInt(b));
		var c : FunBigInt_ = new FunBigInt_();
		assertTrue(FunBigIntTools.isBigInt(c));
		var d : FunMutableBigInt_ = new FunMutableBigInt_();
		assertTrue(FunBigIntTools.isBigInt(d));
	}

	public function testParse() : Void
	{
		assertBIEqualsBI(FunBigInt.fromHex("123456789abcdef0"), FunBigIntTools.parseValueUnsigned("0x123456789abcdef0"));
		assertBIEqualsBI(FunBigInt.fromString("12345678901234567890"), FunBigIntTools.parseValueUnsigned("12345678901234567890"));
		assertBIEqualsBI(FunBigInt.fromHex("080000000"), FunBigIntTools.parseValueUnsigned("0x80000000"));
	}

	private var m_a : FunMutableBigInt;
}
