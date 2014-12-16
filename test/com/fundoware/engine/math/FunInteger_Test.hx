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

package com.fundoware.engine.math;

import com.fundoware.engine.test.FunTestCase;

class FunInteger_Test extends FunTestCase
{
	public function testIsPowerOfTwo() : Void
	{
		assertEquals(true, FunInteger.isPowerOf2(0));
		assertEquals(true, FunInteger.isPowerOf2(1));
		assertEquals(true, FunInteger.isPowerOf2(2));
		assertEquals(false, FunInteger.isPowerOf2(3));
		assertEquals(true, FunInteger.isPowerOf2(4));
		assertEquals(false, FunInteger.isPowerOf2(5));
		assertEquals(false, FunInteger.isPowerOf2(7));
		assertEquals(true, FunInteger.isPowerOf2(8));
		assertEquals(false, FunInteger.isPowerOf2(9));
		assertEquals(false, FunInteger.isPowerOf2(15));
		assertEquals(true, FunInteger.isPowerOf2(16));
		assertEquals(false, FunInteger.isPowerOf2(17));
		assertEquals(false, FunInteger.isPowerOf2(31));
		assertEquals(true, FunInteger.isPowerOf2(32));
		assertEquals(false, FunInteger.isPowerOf2(33));
		assertEquals(false, FunInteger.isPowerOf2(63));
		assertEquals(true, FunInteger.isPowerOf2(64));
		assertEquals(false, FunInteger.isPowerOf2(65));
		assertEquals(false, FunInteger.isPowerOf2(127));
		assertEquals(true, FunInteger.isPowerOf2(128));
		assertEquals(false, FunInteger.isPowerOf2(129));
		assertEquals(false, FunInteger.isPowerOf2(255));
		assertEquals(true, FunInteger.isPowerOf2(256));
		assertEquals(false, FunInteger.isPowerOf2(257));
		assertEquals(false, FunInteger.isPowerOf2(511));
		assertEquals(true, FunInteger.isPowerOf2(512));
		assertEquals(false, FunInteger.isPowerOf2(513));
		assertEquals(false, FunInteger.isPowerOf2(1023));
		assertEquals(true, FunInteger.isPowerOf2(1024));
		assertEquals(false, FunInteger.isPowerOf2(1025));
		assertEquals(false, FunInteger.isPowerOf2(2047));
		assertEquals(true, FunInteger.isPowerOf2(2048));
		assertEquals(false, FunInteger.isPowerOf2(2049));
		assertEquals(false, FunInteger.isPowerOf2(4095));
		assertEquals(true, FunInteger.isPowerOf2(4096));
		assertEquals(false, FunInteger.isPowerOf2(4097));
		assertEquals(false, FunInteger.isPowerOf2(8191));
		assertEquals(true, FunInteger.isPowerOf2(8192));
		assertEquals(false, FunInteger.isPowerOf2(8193));
		assertEquals(false, FunInteger.isPowerOf2(16383));
		assertEquals(true, FunInteger.isPowerOf2(16384));
		assertEquals(false, FunInteger.isPowerOf2(16385));
		assertEquals(false, FunInteger.isPowerOf2(32767));
		assertEquals(true, FunInteger.isPowerOf2(32768));
		assertEquals(false, FunInteger.isPowerOf2(32769));
		assertEquals(false, FunInteger.isPowerOf2(65535));
		assertEquals(true, FunInteger.isPowerOf2(65536));
		assertEquals(false, FunInteger.isPowerOf2(65537));
		assertEquals(false, FunInteger.isPowerOf2(131071));
		assertEquals(true, FunInteger.isPowerOf2(131072));
		assertEquals(false, FunInteger.isPowerOf2(131073));
		assertEquals(false, FunInteger.isPowerOf2(262143));
		assertEquals(true, FunInteger.isPowerOf2(262144));
		assertEquals(false, FunInteger.isPowerOf2(262145));
		assertEquals(false, FunInteger.isPowerOf2(524287));
		assertEquals(true, FunInteger.isPowerOf2(524288));
		assertEquals(false, FunInteger.isPowerOf2(524289));
		assertEquals(false, FunInteger.isPowerOf2(1048575));
		assertEquals(true, FunInteger.isPowerOf2(1048576));
		assertEquals(false, FunInteger.isPowerOf2(1048577));
		assertEquals(false, FunInteger.isPowerOf2(2097151));
		assertEquals(true, FunInteger.isPowerOf2(2097152));
		assertEquals(false, FunInteger.isPowerOf2(2097153));
		assertEquals(false, FunInteger.isPowerOf2(4194303));
		assertEquals(true, FunInteger.isPowerOf2(4194304));
		assertEquals(false, FunInteger.isPowerOf2(4194305));
		assertEquals(false, FunInteger.isPowerOf2(8388607));
		assertEquals(true, FunInteger.isPowerOf2(8388608));
		assertEquals(false, FunInteger.isPowerOf2(8388609));
		assertEquals(false, FunInteger.isPowerOf2(16777215));
		assertEquals(true, FunInteger.isPowerOf2(16777216));
		assertEquals(false, FunInteger.isPowerOf2(16777217));
		assertEquals(false, FunInteger.isPowerOf2(33554431));
		assertEquals(true, FunInteger.isPowerOf2(33554432));
		assertEquals(false, FunInteger.isPowerOf2(33554433));
		assertEquals(false, FunInteger.isPowerOf2(67108863));
		assertEquals(true, FunInteger.isPowerOf2(67108864));
		assertEquals(false, FunInteger.isPowerOf2(67108865));
		assertEquals(false, FunInteger.isPowerOf2(134217727));
		assertEquals(true, FunInteger.isPowerOf2(134217728));
		assertEquals(false, FunInteger.isPowerOf2(134217729));
		assertEquals(false, FunInteger.isPowerOf2(268435455));
		assertEquals(true, FunInteger.isPowerOf2(268435456));
		assertEquals(false, FunInteger.isPowerOf2(268435457));
		assertEquals(false, FunInteger.isPowerOf2(536870911));
		assertEquals(true, FunInteger.isPowerOf2(536870912));
		assertEquals(false, FunInteger.isPowerOf2(536870913));
		assertEquals(false, FunInteger.isPowerOf2(1073741823));
		assertEquals(true, FunInteger.isPowerOf2(1073741824));
		assertEquals(false, FunInteger.isPowerOf2(1073741825));
		assertEquals(false, FunInteger.isPowerOf2(2147483647));
		assertEquals(true, FunInteger.isPowerOf2(-2147483648));
		assertEquals(false, FunInteger.isPowerOf2(-2147483647));
	}

	public function test_rotateLeft() : Void
	{
		assertEquals(0, FunInteger.rotateLeft(0, 1));
		assertEquals(2, FunInteger.rotateLeft(1, 1));
		assertEquals(1, FunInteger.rotateLeft(0x80000000, 1));
		assertEquals(0x23456781, FunInteger.rotateLeft(0x12345678, 4));
		assertEquals(0x56781234, FunInteger.rotateLeft(0x12345678, 16));
		assertEquals(0x55555555, FunInteger.rotateLeft(0xaaaaaaaa, 1));
		assertEquals(0xaaaaaaaa, FunInteger.rotateLeft(0x55555555, 1));
		assertEquals(-1, FunInteger.rotateLeft(-1, 0));
		assertEquals(-1, FunInteger.rotateLeft(-1, 1));
		assertEquals(-1, FunInteger.rotateLeft(-1, 2));
		assertEquals(-1, FunInteger.rotateLeft(-1, 3));
		assertEquals(-1, FunInteger.rotateLeft(-1, 15));
		assertEquals(-1, FunInteger.rotateLeft(-1, 31));
	}

	public function test_rotateRight() : Void
	{
		assertEquals(0, FunInteger.rotateRight(0, 1));
		assertEquals(1, FunInteger.rotateRight(2, 1));
		assertEquals(0x80000000, FunInteger.rotateRight(1, 1));
		assertEquals(0x81234567, FunInteger.rotateRight(0x12345678, 4));
		assertEquals(0x56781234, FunInteger.rotateRight(0x12345678, 16));
		assertEquals(0x55555555, FunInteger.rotateRight(0xaaaaaaaa, 1));
		assertEquals(0xaaaaaaaa, FunInteger.rotateRight(0x55555555, 1));
		assertEquals(-1, FunInteger.rotateRight(-1, 0));
		assertEquals(-1, FunInteger.rotateRight(-1, 1));
		assertEquals(-1, FunInteger.rotateRight(-1, 2));
		assertEquals(-1, FunInteger.rotateRight(-1, 3));
		assertEquals(-1, FunInteger.rotateRight(-1, 15));
		assertEquals(-1, FunInteger.rotateRight(-1, 31));
	}

	public function test_u32gtu32() : Void
	{
		checkUnsignedRelation(0, 0);
		checkUnsignedRelation(1, 0);
		checkUnsignedRelation(2147483647, 2147483647);
		checkUnsignedRelation(-2147483648, 2147483647);
		checkUnsignedRelation(-2147483648, -2147483648);
		checkUnsignedRelation(-2147483647, -2147483648);
		checkUnsignedRelation(-1,-1);
		checkUnsignedRelation(-1,-2);
	}
	private function checkUnsignedRelation(a : Int, b : Int) : Void
	{
		assertEquals(a != b, FunInteger.u32gtu32(a, b));
		assertFalse(FunInteger.u32gtu32(b, a));
		assertTrue(FunInteger.u32geu32(a, b));
		assertEquals(a == b, FunInteger.u32geu32(b, a));
	}

	public function test_nlz() : Void
	{
		assertEquals(32, FunInteger.nlz(0));
		assertEquals(31, FunInteger.nlz(1));
		assertEquals(30, FunInteger.nlz(2));
		assertEquals(30, FunInteger.nlz(3));
		assertEquals(29, FunInteger.nlz(4));
		assertEquals(29, FunInteger.nlz(5));
		assertEquals(29, FunInteger.nlz(7));
		assertEquals(28, FunInteger.nlz(8));
		assertEquals(28, FunInteger.nlz(9));
		assertEquals(28, FunInteger.nlz(15));
		assertEquals(27, FunInteger.nlz(16));
		assertEquals(27, FunInteger.nlz(17));
		assertEquals(27, FunInteger.nlz(31));
		assertEquals(26, FunInteger.nlz(32));
		assertEquals(26, FunInteger.nlz(33));
		assertEquals(26, FunInteger.nlz(63));
		assertEquals(25, FunInteger.nlz(64));
		assertEquals(25, FunInteger.nlz(65));
		assertEquals(25, FunInteger.nlz(127));
		assertEquals(24, FunInteger.nlz(128));
		assertEquals(24, FunInteger.nlz(129));
		assertEquals(24, FunInteger.nlz(255));
		assertEquals(23, FunInteger.nlz(256));
		assertEquals(23, FunInteger.nlz(257));
		assertEquals(23, FunInteger.nlz(511));
		assertEquals(22, FunInteger.nlz(512));
		assertEquals(22, FunInteger.nlz(513));
		assertEquals(22, FunInteger.nlz(1023));
		assertEquals(21, FunInteger.nlz(1024));
		assertEquals(21, FunInteger.nlz(1025));
		assertEquals(21, FunInteger.nlz(2047));
		assertEquals(20, FunInteger.nlz(2048));
		assertEquals(20, FunInteger.nlz(2049));
		assertEquals(20, FunInteger.nlz(4095));
		assertEquals(19, FunInteger.nlz(4096));
		assertEquals(19, FunInteger.nlz(4097));
		assertEquals(19, FunInteger.nlz(8191));
		assertEquals(18, FunInteger.nlz(8192));
		assertEquals(18, FunInteger.nlz(8193));
		assertEquals(18, FunInteger.nlz(16383));
		assertEquals(17, FunInteger.nlz(16384));
		assertEquals(17, FunInteger.nlz(16385));
		assertEquals(17, FunInteger.nlz(32767));
		assertEquals(16, FunInteger.nlz(32768));
		assertEquals(16, FunInteger.nlz(32769));
		assertEquals(16, FunInteger.nlz(65535));
		assertEquals(15, FunInteger.nlz(65536));
		assertEquals(15, FunInteger.nlz(65537));
		assertEquals(15, FunInteger.nlz(131071));
		assertEquals(14, FunInteger.nlz(131072));
		assertEquals(14, FunInteger.nlz(131073));
		assertEquals(14, FunInteger.nlz(262143));
		assertEquals(13, FunInteger.nlz(262144));
		assertEquals(13, FunInteger.nlz(262145));
		assertEquals(13, FunInteger.nlz(524287));
		assertEquals(12, FunInteger.nlz(524288));
		assertEquals(12, FunInteger.nlz(524289));
		assertEquals(12, FunInteger.nlz(1048575));
		assertEquals(11, FunInteger.nlz(1048576));
		assertEquals(11, FunInteger.nlz(1048577));
		assertEquals(11, FunInteger.nlz(2097151));
		assertEquals(10, FunInteger.nlz(2097152));
		assertEquals(10, FunInteger.nlz(2097153));
		assertEquals(10, FunInteger.nlz(4194303));
		assertEquals(9, FunInteger.nlz(4194304));
		assertEquals(9, FunInteger.nlz(4194305));
		assertEquals(9, FunInteger.nlz(8388607));
		assertEquals(8, FunInteger.nlz(8388608));
		assertEquals(8, FunInteger.nlz(8388609));
		assertEquals(8, FunInteger.nlz(16777215));
		assertEquals(7, FunInteger.nlz(16777216));
		assertEquals(7, FunInteger.nlz(16777217));
		assertEquals(7, FunInteger.nlz(33554431));
		assertEquals(6, FunInteger.nlz(33554432));
		assertEquals(6, FunInteger.nlz(33554433));
		assertEquals(6, FunInteger.nlz(67108863));
		assertEquals(5, FunInteger.nlz(67108864));
		assertEquals(5, FunInteger.nlz(67108865));
		assertEquals(5, FunInteger.nlz(134217727));
		assertEquals(4, FunInteger.nlz(134217728));
		assertEquals(4, FunInteger.nlz(134217729));
		assertEquals(4, FunInteger.nlz(268435455));
		assertEquals(3, FunInteger.nlz(268435456));
		assertEquals(3, FunInteger.nlz(268435457));
		assertEquals(3, FunInteger.nlz(536870911));
		assertEquals(2, FunInteger.nlz(536870912));
		assertEquals(2, FunInteger.nlz(536870913));
		assertEquals(2, FunInteger.nlz(1073741823));
		assertEquals(1, FunInteger.nlz(1073741824));
		assertEquals(1, FunInteger.nlz(1073741825));
		assertEquals(1, FunInteger.nlz(2147483647));
		assertEquals(0, FunInteger.nlz(-2147483648));
		assertEquals(0, FunInteger.nlz(-2147483647));
		assertEquals(0, FunInteger.nlz(-1));
	}

	public function testDivision() : Void
	{
		divide1(0, 1, 0, 0);
		divide1(0, 2147483647, 0, 0);
		divide1(0, -2147483648, 0, 0);
		divide1(0, -1, 0, 0);

		divide1(1, 1, 1, 0);
		divide1(1, 2, 0, 1);
		divide1(1, 2147483647, 0, 1);
		divide1(1, -2147483648, 0, 1);
		divide1(1, -1, 0, 1);

		divide1(-1, 2147483647, 2, 1);
		divide1(-2, 2147483647, 2, 0);
		divide1(-3, 2147483647, 1, 2147483646);
		divide1(-4, 2147483647, 1, 2147483645);
		divide1(-2147483648, 2147483647, 1, 1);
		divide1(2147483647, 2147483647, 1, 0);
		divide1(2147483646, 2147483647, 0, 2147483646);
		divide1(2147483645, 2147483647, 0, 2147483645);

		divide1(-1, -2147483648, 1, 2147483647);
		divide1(-2, -2147483648, 1, 2147483646);
		divide1(-3, -2147483648, 1, 2147483645);
		divide1(-2147483646, -2147483648, 1, 2);
		divide1(-2147483647, -2147483648, 1, 1);
		divide1(-2147483648, -2147483648, 1, 0);
		divide1(2147483647, -2147483648, 0, 2147483647);
		divide1(2147483646, -2147483648, 0, 2147483646);
		divide1(2147483645, -2147483648, 0, 2147483645);

		divide1(0, -2147483647, 0, 0);
		divide1(2147483647, -2147483647, 0, 2147483647);
		divide1(-2147483648, -2147483647, 0, -2147483648);
		divide1(-2147483647, -2147483647, 1, 0);
		divide1(-2147483646, -2147483647, 1, 1);
		divide1(-2147483645, -2147483647, 1, 2);

		divide1(4500, 501, 8, 492);

		divide1(-1, 1, -1, 0);
		divide1(-1, 2, 2147483647, 1);
		divide1(-1, 3, 1431655765, 0);
		divide1(-1, 4, 1073741823, 3);
		divide1(-1, 5,  858993459, 0);
		divide1(-1, 6,  715827882, 3);
		divide1(-1, 7,  613566756, 3);
		divide1(-1, 8,  536870911, 7);
		divide1(-1, 9,  477218588, 3);
		divide1(-1, 10, 429496729, 5);
		divide1(-1, 11, 390451572, 3);

		divide1(-2147483648, 1, -2147483648, 0);
		divide1(-2147483648, 2, 1073741824, 0);
		divide1(-2147483648, 3, 715827882, 2);
		divide1(-2147483648, 4, 536870912, 0);
		divide1(-2147483648, 5, 429496729, 3);
		divide1(-2147483648, 6, 357913941, 2);
		divide1(-2147483648, 7, 306783378, 2);
		divide1(-2147483648, 8, 268435456, 0);
		divide1(-2147483648, 9, 238609294, 2);
		divide1(-2147483648, 10, 214748364, 8);
		divide1(-2147483648, 11, 195225786, 2);

		divide1(0, 65535, 0, 0);
		divide1(1, 65535, 0, 1);
		divide1(65534, 65535, 0, 65534);
		divide1(65535, 65535, 1, 0);
		divide1(65536, 65535, 1, 1);
		divide1(2147483647, 65535, 32768, 32767);
		divide1(-2147483648, 65535, 32768, 32768);
		divide1(-2, 65535, 65536, 65534);
		divide1(-1, 65535, 65537, 0);
	}
	private function divide1(dividend : Int, divisor : Int, expectedQuotient : Int, expectedRemainder : Int) : Void
	{
		var r = new FunInteger.DivisionResult();
		FunInteger.u32divu32(dividend, divisor, r);
		assertEquals(expectedQuotient, r.quotient);
		assertEquals(expectedRemainder, r.remainder);
		if ((0 < divisor) && (divisor < 65536))
		{
			FunInteger.u32divu16r(dividend, divisor, r);
			assertEquals(expectedQuotient, r.quotient);
			assertEquals(expectedRemainder, r.remainder);
			assertEquals(expectedQuotient, FunInteger.u32divu16(dividend, divisor));
		}
	}

	public function test_clp2() : Void
	{
		assertEquals(0, FunInteger.clp2(0));
		assertEquals(1, FunInteger.clp2(1));
		assertEquals(2, FunInteger.clp2(2));
		assertEquals(4, FunInteger.clp2(3));
		assertEquals(4, FunInteger.clp2(4));
		assertEquals(8, FunInteger.clp2(5));
		assertEquals(8, FunInteger.clp2(7));
		assertEquals(8, FunInteger.clp2(8));
		assertEquals(16, FunInteger.clp2(9));
		assertEquals(16, FunInteger.clp2(15));
		assertEquals(16, FunInteger.clp2(16));
		assertEquals(32, FunInteger.clp2(17));
		assertEquals(32, FunInteger.clp2(31));
		assertEquals(32, FunInteger.clp2(32));
		assertEquals(64, FunInteger.clp2(33));
		assertEquals(64, FunInteger.clp2(63));
		assertEquals(64, FunInteger.clp2(64));
		assertEquals(128, FunInteger.clp2(65));
		assertEquals(128, FunInteger.clp2(127));
		assertEquals(128, FunInteger.clp2(128));
		assertEquals(256, FunInteger.clp2(129));
		assertEquals(256, FunInteger.clp2(255));
		assertEquals(256, FunInteger.clp2(256));
		assertEquals(512, FunInteger.clp2(257));
		assertEquals(512, FunInteger.clp2(511));
		assertEquals(512, FunInteger.clp2(512));
		assertEquals(1024, FunInteger.clp2(513));
		assertEquals(1024, FunInteger.clp2(1023));
		assertEquals(1024, FunInteger.clp2(1024));
		assertEquals(2048, FunInteger.clp2(1025));
		assertEquals(2048, FunInteger.clp2(2047));
		assertEquals(2048, FunInteger.clp2(2048));
		assertEquals(4096, FunInteger.clp2(2049));
		assertEquals(4096, FunInteger.clp2(4095));
		assertEquals(4096, FunInteger.clp2(4096));
		assertEquals(8192, FunInteger.clp2(4097));
		assertEquals(8192, FunInteger.clp2(8191));
		assertEquals(8192, FunInteger.clp2(8192));
		assertEquals(16384, FunInteger.clp2(8193));
		assertEquals(16384, FunInteger.clp2(16383));
		assertEquals(16384, FunInteger.clp2(16384));
		assertEquals(32768, FunInteger.clp2(16385));
		assertEquals(32768, FunInteger.clp2(32767));
		assertEquals(32768, FunInteger.clp2(32768));
		assertEquals(65536, FunInteger.clp2(32769));
		assertEquals(65536, FunInteger.clp2(65535));
		assertEquals(65536, FunInteger.clp2(65536));
		assertEquals(131072, FunInteger.clp2(65537));
		assertEquals(131072, FunInteger.clp2(131071));
		assertEquals(131072, FunInteger.clp2(131072));
		assertEquals(262144, FunInteger.clp2(131073));
		assertEquals(262144, FunInteger.clp2(262143));
		assertEquals(262144, FunInteger.clp2(262144));
		assertEquals(524288, FunInteger.clp2(262145));
		assertEquals(524288, FunInteger.clp2(524287));
		assertEquals(524288, FunInteger.clp2(524288));
		assertEquals(1048576, FunInteger.clp2(524289));
		assertEquals(1048576, FunInteger.clp2(1048575));
		assertEquals(1048576, FunInteger.clp2(1048576));
		assertEquals(2097152, FunInteger.clp2(1048577));
		assertEquals(2097152, FunInteger.clp2(2097151));
		assertEquals(2097152, FunInteger.clp2(2097152));
		assertEquals(4194304, FunInteger.clp2(2097153));
		assertEquals(4194304, FunInteger.clp2(4194303));
		assertEquals(4194304, FunInteger.clp2(4194304));
		assertEquals(8388608, FunInteger.clp2(4194305));
		assertEquals(8388608, FunInteger.clp2(8388607));
		assertEquals(8388608, FunInteger.clp2(8388608));
		assertEquals(16777216, FunInteger.clp2(8388609));
		assertEquals(16777216, FunInteger.clp2(16777215));
		assertEquals(16777216, FunInteger.clp2(16777216));
		assertEquals(33554432, FunInteger.clp2(16777217));
		assertEquals(33554432, FunInteger.clp2(33554431));
		assertEquals(33554432, FunInteger.clp2(33554432));
		assertEquals(67108864, FunInteger.clp2(33554433));
		assertEquals(67108864, FunInteger.clp2(67108863));
		assertEquals(67108864, FunInteger.clp2(67108864));
		assertEquals(134217728, FunInteger.clp2(67108865));
		assertEquals(134217728, FunInteger.clp2(134217727));
		assertEquals(134217728, FunInteger.clp2(134217728));
		assertEquals(268435456, FunInteger.clp2(134217729));
		assertEquals(268435456, FunInteger.clp2(268435455));
		assertEquals(268435456, FunInteger.clp2(268435456));
		assertEquals(536870912, FunInteger.clp2(268435457));
		assertEquals(536870912, FunInteger.clp2(536870911));
		assertEquals(536870912, FunInteger.clp2(536870912));
		assertEquals(1073741824, FunInteger.clp2(536870913));
		assertEquals(1073741824, FunInteger.clp2(1073741823));
		assertEquals(1073741824, FunInteger.clp2(1073741824));
		assertEquals(-2147483648, FunInteger.clp2(1073741825));
		assertEquals(-2147483648, FunInteger.clp2(2147483647));
		assertEquals(-2147483648, FunInteger.clp2(-2147483648));
		assertEquals(0, FunInteger.clp2(-2147483647));
		assertEquals(0, FunInteger.clp2(-1));
	}

	public function test_flp2() : Void
	{
		assertEquals(0, FunInteger.flp2(0));
		assertEquals(1, FunInteger.flp2(1));
		assertEquals(2, FunInteger.flp2(2));
		assertEquals(2, FunInteger.flp2(3));
		assertEquals(4, FunInteger.flp2(4));
		assertEquals(4, FunInteger.flp2(5));
		assertEquals(4, FunInteger.flp2(7));
		assertEquals(8, FunInteger.flp2(8));
		assertEquals(8, FunInteger.flp2(9));
		assertEquals(8, FunInteger.flp2(15));
		assertEquals(16, FunInteger.flp2(16));
		assertEquals(16, FunInteger.flp2(17));
		assertEquals(16, FunInteger.flp2(31));
		assertEquals(32, FunInteger.flp2(32));
		assertEquals(32, FunInteger.flp2(33));
		assertEquals(32, FunInteger.flp2(63));
		assertEquals(64, FunInteger.flp2(64));
		assertEquals(64, FunInteger.flp2(65));
		assertEquals(64, FunInteger.flp2(127));
		assertEquals(128, FunInteger.flp2(128));
		assertEquals(128, FunInteger.flp2(129));
		assertEquals(128, FunInteger.flp2(255));
		assertEquals(256, FunInteger.flp2(256));
		assertEquals(256, FunInteger.flp2(257));
		assertEquals(256, FunInteger.flp2(511));
		assertEquals(512, FunInteger.flp2(512));
		assertEquals(512, FunInteger.flp2(513));
		assertEquals(512, FunInteger.flp2(1023));
		assertEquals(1024, FunInteger.flp2(1024));
		assertEquals(1024, FunInteger.flp2(1025));
		assertEquals(1024, FunInteger.flp2(2047));
		assertEquals(2048, FunInteger.flp2(2048));
		assertEquals(2048, FunInteger.flp2(2049));
		assertEquals(2048, FunInteger.flp2(4095));
		assertEquals(4096, FunInteger.flp2(4096));
		assertEquals(4096, FunInteger.flp2(4097));
		assertEquals(4096, FunInteger.flp2(8191));
		assertEquals(8192, FunInteger.flp2(8192));
		assertEquals(8192, FunInteger.flp2(8193));
		assertEquals(8192, FunInteger.flp2(16383));
		assertEquals(16384, FunInteger.flp2(16384));
		assertEquals(16384, FunInteger.flp2(16385));
		assertEquals(16384, FunInteger.flp2(32767));
		assertEquals(32768, FunInteger.flp2(32768));
		assertEquals(32768, FunInteger.flp2(32769));
		assertEquals(32768, FunInteger.flp2(65535));
		assertEquals(65536, FunInteger.flp2(65536));
		assertEquals(65536, FunInteger.flp2(65537));
		assertEquals(65536, FunInteger.flp2(131071));
		assertEquals(131072, FunInteger.flp2(131072));
		assertEquals(131072, FunInteger.flp2(131073));
		assertEquals(131072, FunInteger.flp2(262143));
		assertEquals(262144, FunInteger.flp2(262144));
		assertEquals(262144, FunInteger.flp2(262145));
		assertEquals(262144, FunInteger.flp2(524287));
		assertEquals(524288, FunInteger.flp2(524288));
		assertEquals(524288, FunInteger.flp2(524289));
		assertEquals(524288, FunInteger.flp2(1048575));
		assertEquals(1048576, FunInteger.flp2(1048576));
		assertEquals(1048576, FunInteger.flp2(1048577));
		assertEquals(1048576, FunInteger.flp2(2097151));
		assertEquals(2097152, FunInteger.flp2(2097152));
		assertEquals(2097152, FunInteger.flp2(2097153));
		assertEquals(2097152, FunInteger.flp2(4194303));
		assertEquals(4194304, FunInteger.flp2(4194304));
		assertEquals(4194304, FunInteger.flp2(4194305));
		assertEquals(4194304, FunInteger.flp2(8388607));
		assertEquals(8388608, FunInteger.flp2(8388608));
		assertEquals(8388608, FunInteger.flp2(8388609));
		assertEquals(8388608, FunInteger.flp2(16777215));
		assertEquals(16777216, FunInteger.flp2(16777216));
		assertEquals(16777216, FunInteger.flp2(16777217));
		assertEquals(16777216, FunInteger.flp2(33554431));
		assertEquals(33554432, FunInteger.flp2(33554432));
		assertEquals(33554432, FunInteger.flp2(33554433));
		assertEquals(33554432, FunInteger.flp2(67108863));
		assertEquals(67108864, FunInteger.flp2(67108864));
		assertEquals(67108864, FunInteger.flp2(67108865));
		assertEquals(67108864, FunInteger.flp2(134217727));
		assertEquals(134217728, FunInteger.flp2(134217728));
		assertEquals(134217728, FunInteger.flp2(134217729));
		assertEquals(134217728, FunInteger.flp2(268435455));
		assertEquals(268435456, FunInteger.flp2(268435456));
		assertEquals(268435456, FunInteger.flp2(268435457));
		assertEquals(268435456, FunInteger.flp2(536870911));
		assertEquals(536870912, FunInteger.flp2(536870912));
		assertEquals(536870912, FunInteger.flp2(536870913));
		assertEquals(536870912, FunInteger.flp2(1073741823));
		assertEquals(1073741824, FunInteger.flp2(1073741824));
		assertEquals(1073741824, FunInteger.flp2(1073741825));
		assertEquals(1073741824, FunInteger.flp2(2147483647));
		assertEquals(-2147483648, FunInteger.flp2(-2147483648));
		assertEquals(-2147483648, FunInteger.flp2(-2147483647));
		assertEquals(-2147483648, FunInteger.flp2(-1));
	}
}
