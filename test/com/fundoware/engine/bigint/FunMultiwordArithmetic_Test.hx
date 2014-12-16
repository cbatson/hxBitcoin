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

import com.fundoware.engine.exception.FunExceptions;
import com.fundoware.engine.math.FunInteger;
import haxe.ds.Vector;

class FunMultiwordArithmetic_Test extends FunBigIntTestCase
{
	public function testCompare() : Void
	{
		checkCompare( 0, fromInt( 0), fromInt(0));
		checkCompare(-1, fromInt( 0), fromInt(1));
		checkCompare(-1, fromInt( 1), fromInt(2));
		checkCompare(-1, fromInt(-1), fromInt(0));
		checkCompare(-1, fromInt(-2), fromInt(-1));
		checkCompare(-1, fromInt(2147483646), fromInt(2147483647));
		checkCompare(-1, fromInt(-2147483648), fromInt(2147483647));
		checkCompare(-1, fromInt(-2147483648), fromInt(-2147483647));
		checkCompare(-1, fromInt(-2147483648), fromInt(-1));

		checkCompare( 1, fromHex("00000001 80000000", 2), fromHex("00000001 7fffffff", 2));
		checkCompare( 1, fromHex("00000001 ffffffff", 2), fromHex("00000001 00000000", 2));
	}
	private function checkCompare(expected : Int, a : Vector<Int>, b : Vector<Int>) : Void
	{
		assertEquals( expected, FunMultiwordArithmetic.compareSigned(a, b, a.length));
		assertEquals(-expected, FunMultiwordArithmetic.compareSigned(b, a, a.length));
		var as : Int = (a[a.length - 1]) < 0 ? -1 : 1;
		var bs : Int = (b[b.length - 1]) < 0 ? -1 : 1;
		var s : Int = as * bs;
		assertEquals( expected * s, FunMultiwordArithmetic.compareUnsigned(a, b, a.length));
		assertEquals(-expected * s, FunMultiwordArithmetic.compareUnsigned(b, a, a.length));
	}

	public function testArithmeticShiftRight() : Void
	{
		FunMultiwordArithmetic.arithmeticShiftRight(fromInt(0, 2), fromInt(1, 2), 2, 1);
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.arithmeticShiftRight(fromInt(0, 2), fromInt(1, 2), 2, -1);	// shift negative
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.arithmeticShiftRight(fromInt(0, 2), fromInt(1, 2), 2, 32);	// shift 32
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.arithmeticShiftRight(fromInt(0, 1), fromInt(1, 2), 2, 1);	// result too short
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.arithmeticShiftRight(fromInt(0, 2), fromInt(1, 1), 2, 1);	// input too short
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.arithmeticShiftRight(fromInt(0, 2), fromInt(1, 2), 0, 1);	// length too short
		});

		// result and input overlap
		var result = fromHex("12345678 9abcdef0");
		FunMultiwordArithmetic.arithmeticShiftRight(result, result, 2, 4);
		assertEqualsBI(fromHex("01234567 89abcdef"), result);

		// result and input overlap and shift is 0
		var result = fromHex("12345678 9abcdef0");
		FunMultiwordArithmetic.arithmeticShiftRight(result, result, 2, 0);
		assertEqualsBI(fromHex("12345678 9abcdef0"), result);

		checkASR(fromHex("00000000 00000000", 2), fromHex("00000000 00000000", 2), 1);
		checkASR(fromHex("00000000 00000000", 2), fromHex("00000000 00000001", 2), 1);
		checkASR(fromHex("00000000 00000001", 2), fromHex("00000000 00000002", 2), 1);
		checkASR(fromHex("00000000 80000000", 2), fromHex("00000001 00000001", 2), 1);
		checkASR(fromHex("ffffffff ffffffff", 2), fromHex("ffffffff ffffffff", 2), 1);
		checkASR(fromHex("ffffffff ffffffff", 2), fromHex("ffffffff ffffffff", 2), 31);
		checkASR(fromHex("12345678 9abcdef0", 2), fromHex("12345678 9abcdef0", 2), 0);
		checkASR(fromHex("01234567 89abcdef", 2), fromHex("12345678 9abcdef0", 2), 4);
		checkASR(fromHex("00000001 23456789", 2), fromHex("12345678 9abcdef0", 2), 28);
		checkASR(fromHex("00000000 40000000", 2), fromHex("00000000 80000000", 2), 1);
		checkASR(fromHex("c0000000 00000000", 2), fromHex("80000000 00000000", 2), 1);
	}
	public function checkASR(expected : Vector<Int>, input : Vector<Int>, shift : Int) : Void
	{
		var result = new Vector<Int>(input.length);
		FunMultiwordArithmetic.arithmeticShiftRight(result, input, input.length, shift);
		assertEqualsBI(expected, result);
	}

	public function testLogicalShiftRight() : Void
	{
		FunMultiwordArithmetic.logicalShiftRight(fromInt(0, 2), fromInt(1, 2), 2, 1);
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.logicalShiftRight(fromInt(0, 2), fromInt(1, 2), 2, -1);	// shift negative
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.logicalShiftRight(fromInt(0, 2), fromInt(1, 2), 2, 32);	// shift 32
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.logicalShiftRight(fromInt(0, 1), fromInt(1, 2), 2, 1);	// result too short
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.logicalShiftRight(fromInt(0, 2), fromInt(1, 1), 2, 1);	// input too short
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.logicalShiftRight(fromInt(0, 2), fromInt(1, 2), 0, 1);	// length too short
		});

		// result and input overlap
		var result = fromHex("12345678 9abcdef0");
		FunMultiwordArithmetic.logicalShiftRight(result, result, 2, 4);
		assertEqualsBI(fromHex("01234567 89abcdef"), result);

		// result and input overlap and shift is 0
		var result = fromHex("12345678 9abcdef0");
		FunMultiwordArithmetic.logicalShiftRight(result, result, 2, 0);
		assertEqualsBI(fromHex("12345678 9abcdef0"), result);

		checkShiftRight(fromHex("00000000 00000000", 2), fromHex("00000000 00000000", 2), 1);
		checkShiftRight(fromHex("00000000 00000000", 2), fromHex("00000000 00000001", 2), 1);
		checkShiftRight(fromHex("00000000 00000001", 2), fromHex("00000000 00000002", 2), 1);
		checkShiftRight(fromHex("00000000 80000000", 2), fromHex("00000001 00000001", 2), 1);
		checkShiftRight(fromHex("7fffffff ffffffff", 2), fromHex("ffffffff ffffffff", 2), 1);
		checkShiftRight(fromHex("00000001 ffffffff", 2), fromHex("ffffffff ffffffff", 2), 31);
		checkShiftRight(fromHex("12345678 9abcdef0", 2), fromHex("12345678 9abcdef0", 2), 0);
		checkShiftRight(fromHex("01234567 89abcdef", 2), fromHex("12345678 9abcdef0", 2), 4);
		checkShiftRight(fromHex("00000001 23456789", 2), fromHex("12345678 9abcdef0", 2), 28);
	}
	public function checkShiftRight(expected : Vector<Int>, input : Vector<Int>, shift : Int) : Void
	{
		var result = new Vector<Int>(input.length);
		FunMultiwordArithmetic.logicalShiftRight(result, input, input.length, shift);
		assertEqualsBI(expected, result);
	}

	public function testExtendUnsigned() : Void
	{
		var result = new Vector<Int>(4);

		fill(result);
		FunMultiwordArithmetic.extendUnsigned(result, 2, fromInt(0), 1);
		assertEqualsBI(0, result, 2);
		assertEquals(0xdeadbeef, result[2]);

		fill(result);
		FunMultiwordArithmetic.extendUnsigned(result, 2, fromInt(-2147483648), 1);
		assertEqualsBI(-2147483648, result, 2);
		assertEquals(0xdeadbeef, result[2]);

		fill(result);
		FunMultiwordArithmetic.extendUnsigned(result, 2, fromInt(-1), 1);
		assertEqualsBI(-1, result, 2);
		assertEquals(0xdeadbeef, result[2]);

		fill(result);
		FunMultiwordArithmetic.extendUnsigned(result, 4, fromHex("1 00000000"), 2);
		assertEqualsBI(fromHex("1 00000000", 4), result, 4);

		fill(result);
		FunMultiwordArithmetic.setFromIntUnsigned(result, 1, 123);
		FunMultiwordArithmetic.extendUnsigned(result, 4, result, 1);
		assertEqualsBI(123, result, 4);
	}

	public function testSubtractSemantics() : Void
	{
		// All inputs can be the same
		var result = fromInt(11);
		FunMultiwordArithmetic.subtract(result, result, result, 1);
		assertEqualsBI(0, result);

		// Bounds
		FunMultiwordArithmetic.subtract(fromInt(0, 2), fromInt(0, 2), fromInt(0, 2), 2);
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.subtract(fromInt(0, 1), fromInt(0, 2), fromInt(0, 2), 2);
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.subtract(fromInt(0, 2), fromInt(0, 1), fromInt(0, 2), 2);
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.subtract(fromInt(0, 2), fromInt(0, 2), fromInt(0, 1), 2);
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.subtract(fromInt(0, 2), fromInt(0, 2), fromInt(0, 2), 0);
		});
	}

	public function testSubtractCarry() : Void
	{
		var result = new Vector<Int>(2);
		var c : Int;

		assertEquals(0, FunMultiwordArithmetic.subtract(result, fromInt(0), fromInt(0), 1));
		assertEquals(1, FunMultiwordArithmetic.subtract(result, fromInt(0), fromInt(1), 1));
		assertEquals(0, FunMultiwordArithmetic.subtract(result, fromInt(-1), fromInt(-1), 1));
		assertEquals(1, FunMultiwordArithmetic.subtract(result, fromInt(-2), fromInt(-1), 1));
		assertEquals(0, FunMultiwordArithmetic.subtract(result, fromInt(-2147483648), fromInt(-2147483648), 1));
		assertEquals(1, FunMultiwordArithmetic.subtract(result, fromInt(2147483647), fromInt(-2147483648), 1));

		assertEquals(0, FunMultiwordArithmetic.subtract(result, fromHex("00000000 00000001", 2), fromInt(1, 2), 2));
		assertEquals(0, FunMultiwordArithmetic.subtract(result, fromHex("00000001 00000000", 2), fromInt(1, 2), 2));
		assertEquals(1, FunMultiwordArithmetic.subtract(result, fromHex("00000000 00000000", 2), fromInt(1, 2), 2));
	}

	public function testAddSemantics() : Void
	{
		// All inputs can be the same
		var result = fromInt(11);
		FunMultiwordArithmetic.add(result, result, result, 1);
		assertEqualsBI(22, result);

		// Bounds
		FunMultiwordArithmetic.add(fromInt(0, 2), fromInt(0, 2), fromInt(0, 2), 2);
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.add(fromInt(0, 1), fromInt(0, 2), fromInt(0, 2), 2);
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.add(fromInt(0, 2), fromInt(0, 1), fromInt(0, 2), 2);
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.add(fromInt(0, 2), fromInt(0, 2), fromInt(0, 1), 2);
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.add(fromInt(0, 2), fromInt(0, 2), fromInt(0, 2), 0);
		});
	}

	public function testAddCarry() : Void
	{
		var result = new Vector<Int>(2);
		var c : Int;

		assertEquals(0, FunMultiwordArithmetic.add(result, fromInt(0), fromInt(0), 1));
		assertEquals(0, FunMultiwordArithmetic.add(result, fromInt(0), fromInt(1), 1));
		assertEquals(0, FunMultiwordArithmetic.add(result, fromInt(1), fromInt(2147483647), 1));
		assertEquals(0, FunMultiwordArithmetic.add(result, fromInt(1), fromInt(-2), 1));
		assertEquals(1, FunMultiwordArithmetic.add(result, fromInt(1), fromInt(-1), 1));
		assertEquals(1, FunMultiwordArithmetic.add(result, fromInt(-2147483648), fromInt(-2147483648), 1));

		assertEquals(0, FunMultiwordArithmetic.add(result, fromHex("ffffffff fffffffe"), fromInt(1, 2), 2));
		assertEquals(0, FunMultiwordArithmetic.add(result, fromHex("fffffffe ffffffff"), fromInt(1, 2), 2));
		assertEquals(1, FunMultiwordArithmetic.add(result, fromHex("ffffffff ffffffff"), fromInt(1, 2), 2));
	}

	public function testAddAndSubtract() : Void
	{
		checkAdd(fromInt(0), fromInt(0), fromInt(0));
		checkAdd(fromInt(1), fromInt(0), fromInt(1));
		checkAdd(fromInt(2), fromInt(1), fromInt(1));
		checkAdd(fromInt(-1), fromInt(-1), fromInt(0));
		checkAdd(fromInt(0), fromInt(-1), fromInt(1));
		checkAdd(fromInt(1), fromInt(-1), fromInt(2));
		checkAdd(fromInt(-2), fromInt(-1), fromInt(-1));

		checkAdd(fromHex("00000000 00000000 80000000", 3), fromHex("00000000 00000000 7fffffff", 3), fromInt(1, 3));
		checkAdd(fromHex("00000000 80000000 00000000", 3), fromHex("00000000 7fffffff ffffffff", 3), fromInt(1, 3));
		checkAdd(fromHex("80000000 00000000 00000000", 3), fromHex("7fffffff ffffffff ffffffff", 3), fromInt(1, 3));
		checkAdd(fromHex("ffffffff ffffffff 00000000", 3), fromHex("ffffffff fffffffe ffffffff", 3), fromInt(1, 3));
		checkAdd(fromHex("00000001 00000000 00000000 00000000", 4), fromHex("00000000 ffffffff ffffffff ffffffff", 4), fromHex("00000000 00000000 00000001", 4));
		checkAdd(fromHex("00000001 00000000 00000000 00000000", 4), fromHex("00000000 ffffffff ffffffff 00000000", 4), fromHex("00000000 00000001 00000000", 4));
		checkAdd(fromHex("00000001 00000000 00000000 00000000", 4), fromHex("00000000 ffffffff 00000000 00000000", 4), fromHex("00000001 00000000 00000000", 4));

		checkAdd(fromHex("23456789"), fromHex("12345678"), fromHex("11111111"));
		checkAdd(fromHex("2345678923456789"), fromHex("1234567812345678"), fromHex("1111111111111111"));
		checkAdd(fromHex("234567892345678923456789"), fromHex("123456781234567812345678"), fromHex("111111111111111111111111"));

		checkAdd(fromHex("1234567823456789"), fromHex("1234567812345678"), fromHex("11111111", 2));
		checkAdd(fromHex("123456781234567823456789"), fromHex("123456781234567812345678"), fromHex("11111111", 3));
		checkAdd(fromHex("2345678912345678"), fromHex("1234567812345678"), fromHex("1111111100000000"));
		checkAdd(fromHex("234567891234567812345678"), fromHex("123456781234567812345678"), fromHex("111111110000000000000000"));
		checkAdd(fromHex("234567891234567823456789"), fromHex("123456781234567812345678"), fromHex("111111110000000011111111"));
	}
	private function checkAdd(expected : Vector<Int>, a : Vector<Int>, b : Vector<Int>) : Void
	{
		var negExpected = new Vector<Int>(expected.length);
		var negA = new Vector<Int>(a.length);
		var negB = new Vector<Int>(b.length);

		FunMultiwordArithmetic.negate(negExpected, expected, expected.length);
		FunMultiwordArithmetic.negate(negA, a, a.length);
		FunMultiwordArithmetic.negate(negB, b, b.length);

		checkAddCommute(expected, a, b);
		checkAddCommute(negExpected, negA, negB);
		checkAddCommute(b, expected, negA);
		checkAddCommute(a, expected, negB);
	}
	private function checkAddCommute(expected : Vector<Int>, a : Vector<Int>, b : Vector<Int>) : Void
	{
		checkAddSingle(expected, a, b);
		checkAddSingle(expected, b, a);
	}
	private function checkAddSingle(expected : Vector<Int>, a : Vector<Int>, b : Vector<Int>) : Void
	{
		var result = new Vector<Int>(expected.length);
		var c = FunMultiwordArithmetic.add(result, a, b, expected.length);
		assertEqualsBI(expected, result);
		c = FunMultiwordArithmetic.subtract(result, expected, b, expected.length);
		assertEqualsBI(a, result);
	}

	public function testNegate() : Void
	{
		checkNegate(fromInt(0), fromInt(0));
		checkNegate(fromInt(1), fromInt(-1));
		checkNegate(fromInt(100), fromInt(-100));
		checkNegate(fromHex("80000000"), fromInt(-2147483648));
		checkNegate(fromHex("8000000000000000"), fromHex("8000000000000000"));
		checkNegate(fromHex("edcba98800000000"), fromHex("1234567800000000"));
	}
	private function checkNegate(expected : Vector<Int>, value : Vector<Int>) : Void
	{
		var temp = new Vector<Int>(value.length);
		FunMultiwordArithmetic.negate(temp, value, value.length);
		assertEqualsBI(expected, temp);
		FunMultiwordArithmetic.negate(temp, temp, temp.length);
		assertEqualsBI(value, temp);
	}

	public function testToDecimal() : Void
	{
		var value = new Vector<Int>(1);
		value[0] = 0;
		assertEquals("0", FunMultiwordArithmetic.toDecimalUnsigned(value, value.length));
		assertEquals("0", FunMultiwordArithmetic.toDecimalSigned(value, value.length));

		checkDecString("1");
		checkDecString("99");
		checkDecString("2147483647");
		checkDecString("2147483648");
		checkDecString("2147483649");
		checkDecString("4294967295");
		checkDecString("4294967296");
		checkDecString("4294967297");
		// TODO
		/*for (i in 0 ... s_powersOfTwo.length)
		{
			var s = s_powersOfTwo[i];
			checkDecString(s);
			checkDecString("9" + s);
			checkDecString(s + "9");
			checkDecString("9" + s + "9");
		}*/
		var s = "1";
		for (i in 0 ... 100)
		{
			s = s + "0";
			checkDecString(s);
		}
		assertEquals("1512366075204170929049582354406559215", FunMultiwordArithmetic.toDecimalUnsigned(fromHex("01234567 89abcdef 01234567 89abcdef"), 4));
	}
	private function checkDecString(value : String) : Void
	{
		// TODO
		/*var biPos = fromString(value);
		assertEquals(value, biPos.toString());
		value = "-" + value;
		var biNeg = fromString(value);
		assertEquals(value, biNeg.toString());*/
	}

	public function testIsZero() : Void
	{
		assertEquals(true, FunMultiwordArithmetic.isZero(fromInt(0), 1));
		assertEquals(false, FunMultiwordArithmetic.isZero(fromInt(1), 1));
		assertEquals(false, FunMultiwordArithmetic.isZero(fromInt(-1), 1));
	}

	public function testSetFromHexUnsignedInitializesWordsWithoutHexDigits() : Void
	{
		var result = new Vector<Int>(4);
		FunMultiwordArithmetic.setFromHexUnsigned(result, 4, "abc");
		assertEquals(2748, result[0]);
		assertEquals(0, result[1]);
		assertEquals(0, result[2]);
		assertEquals(0, result[3]);
	}

	public function testSetFromHexUnsigned() : Void
	{
		var value = fromInt(0);

		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.setFromHexUnsigned(value, 1, null);
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.setFromHexUnsigned(value, 1, "");
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.setFromHexUnsigned(null, 1, "0");
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.setFromHexUnsigned(value, 2, "0");	// buffer too small
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.setFromHexUnsigned(value, 1, "0g0");	// invalid char
		});

		value = new Vector<Int>(3);
		assertFalse(FunMultiwordArithmetic.setFromHexUnsigned(value, 0, "0"));
		assertFalse(FunMultiwordArithmetic.setFromHexUnsigned(value, 1, "1 00000000"));
		assertFalse(FunMultiwordArithmetic.setFromHexUnsigned(value, 2, "1 00000000 00000000"));
		assertTrue(FunMultiwordArithmetic.setFromHexUnsigned(value, 1, "00000000 00000000 000000cb"));
		assertEquals(203, value[0]);

		checkSetFromHexUnsigned("00000000", "0");
		checkSetFromHexUnsigned("0000000000000000", "0");
		checkSetFromHexUnsigned("000000000000000000000000", "0");

		checkSetFromHexUnsigned("00000001", "1");
		checkSetFromHexUnsigned("0000000100000000", "1 00000000");
		checkSetFromHexUnsigned("000000000000000100000000", "1 00000000");

		checkSetFromHexUnsigned("7fffffff", "7fffffff");
		checkSetFromHexUnsigned("7fffffffffffffff", "7fffffff ffffffff");
		checkSetFromHexUnsigned("7fffffffffffffffffffffff", "7fffffff ffffffff ffffffff");

		checkSetFromHexUnsigned("80000000", "80000000");
		checkSetFromHexUnsigned("8000000000000000", "80000000 00000000");
		checkSetFromHexUnsigned("800000000000000000000000", "80000000 00000000 00000000");

		checkSetFromHexUnsigned("ffffffff", "ffffffff");
		checkSetFromHexUnsigned("ffffffffffffffff", "ffffffff ffffffff");
		checkSetFromHexUnsigned("ffffffffffffffffffffffff", "ffffffff ffffffff ffffffff");
		checkSetFromHexUnsigned("0000000000000000ffffffff", "ffffffff");

		checkSetFromHexUnsigned("00abcdef", "ABCDEF");
		checkSetFromHexUnsigned("00abcdef", "abcdef");
	}
	private function checkSetFromHexUnsigned(expected : String, input : String) : Void
	{
		var len : Int = (expected.length + 7) >> 3;
		var result = new Vector<Int>(len);
		assertTrue(FunMultiwordArithmetic.setFromHexUnsigned(result, len, input));
		var hex = FunMultiwordArithmetic.toHex(result, len);
		assertEquals(expected, hex);
	}

	public function testMultiplySemantics() : Void
	{
		var result : Vector<Int>;

		// if result of multiplication is an input, should throw an exception
		result = fromInt(2, 4);
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.multiplyUnsigned(result, result, 1, fromInt(2), 1);
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.multiplyUnsigned(result, fromInt(2), 1, result, 1);
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.multiplyIntUnsigned(result, result, 1, 2);
		});

		// Multiplication of same inputs is ok
		var a = fromInt(2);
		result = fromInt(0, 2);
		FunMultiwordArithmetic.multiplyUnsigned(result, a, 1, a, 1);
		assertEqualsBI(4, result);

		// check for result length too short
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.multiplyUnsigned(fromInt(0), fromInt(2), 1, fromInt(2), 1);
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.multiplyIntUnsigned(fromInt(0), fromInt(2), 1, 2);
		});

		// check input lengths
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.multiplyUnsigned(fromInt(0, 2), fromInt(2), 0, fromInt(2), 1);
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.multiplyUnsigned(fromInt(0, 2), fromInt(2), 1, fromInt(2), 0);
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.multiplyIntUnsigned(fromInt(0, 2), fromInt(2), 0, 2);
		});

		// check input bounds
		FunMultiwordArithmetic.multiplyUnsigned(fromInt(0, 4), fromInt(2, 2), 2, fromInt(2, 2), 2);
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.multiplyUnsigned(fromInt(0, 4), fromInt(2, 1), 2, fromInt(2, 2), 2);
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.multiplyUnsigned(fromInt(0, 4), fromInt(2, 2), 2, fromInt(2, 1), 2);
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.multiplyIntUnsigned(fromInt(0, 4), fromInt(2, 1), 2, 2);
		});
	}

	public function testDivideSemantics() : Void
	{
		var dividend = fromInt(0);
		var divisor : Vector<Int>;
		var quotient : Vector<Int>;
		var remainder = fromInt(0);
		var remainderInt : Int;
		var work = new Vector<Int>(10);

		// check quotient overlaps with dividend, divisor < 65536 case
		quotient = fromInt(12345);
		remainderInt = FunMultiwordArithmetic.divideIntUnsigned(quotient, quotient.length, 11, quotient, work);
		assertEqualsBI(1122, quotient);
		assertEquals(3, remainderInt);
		quotient = fromInt(12345);
		FunMultiwordArithmetic.divideUnsigned(quotient, quotient.length, fromInt(11), 1, quotient, remainder, work);
		assertEqualsBI(1122, quotient);
		assertEqualsBI(3, remainder);

		// check quotient overlaps with dividend, divisor >= 65536 case
		quotient = fromInt(721018);
		divisor = fromInt(65537);
		FunMultiwordArithmetic.divideUnsigned(quotient, quotient.length, divisor, divisor.length, quotient, remainder, work);
		assertEqualsBI(11, quotient);
		assertEqualsBI(111, remainder);

		// check quotient overlaps with dividend, special case 1
		quotient = fromInt(0);
		divisor = fromInt(11);
		FunMultiwordArithmetic.divideUnsigned(quotient, quotient.length, divisor, divisor.length, quotient, remainder, work);
		assertEqualsBI(0, quotient);
		assertEqualsBI(0, remainder);

		// check quotient overlaps with dividend, special case 2
		quotient = fromInt(7);
		FunMultiwordArithmetic.divideUnsigned(quotient, quotient.length, fromInt(1), 1, quotient, remainder, work);
		assertEqualsBI(7, quotient);
		assertEqualsBI(0, remainder);

		// check quotient overlaps with dividend, special case 3
		quotient = fromInt(11);
		remainder = fromInt(0, 2);
		FunMultiwordArithmetic.divideUnsigned(quotient, quotient.length, fromHex("1 00000000"), 2, quotient, remainder, work);
		assertEqualsBI(0, quotient);
		assertEqualsBI(11, remainder);

		// check quotient overlaps with divisor, divisor < 65536 case
		quotient = fromInt(11);
		FunMultiwordArithmetic.divideUnsigned(fromInt(12345), 1, quotient, quotient.length, quotient, remainder, work);
		assertEqualsBI(1122, quotient);
		assertEqualsBI(3, remainder);

		// check quotient overlaps with divisor, divisor >= 65536 case
		quotient = fromInt(65537);
		FunMultiwordArithmetic.divideUnsigned(fromInt(721018), 1, quotient, quotient.length, quotient, remainder, work);
		assertEqualsBI(11, quotient);
		assertEqualsBI(111, remainder);

		// check quotient overlaps with divisor, special case 1
		quotient = fromInt(10);
		FunMultiwordArithmetic.divideUnsigned(fromInt(0), 1, quotient, quotient.length, quotient, remainder, work);
		assertEqualsBI(0, quotient);
		assertEqualsBI(0, remainder);

		// check quotient overlaps with divisor, special case 2
		quotient = fromInt(1);
		FunMultiwordArithmetic.divideUnsigned(fromInt(7), 1, quotient, quotient.length, quotient, remainder, work);
		assertEqualsBI(7, quotient);
		assertEqualsBI(0, remainder);

		// check quotient overlaps with divisor, special case 3
		quotient = fromHex("1 00000000");
		FunMultiwordArithmetic.divideUnsigned(fromInt(11), 1, quotient, quotient.length, quotient, remainder, work);
		assertEqualsBI(0, quotient, 1);
		assertEqualsBI(11, remainder);

		// check remainder overlaps with dividend, divisor < 65536 case
		quotient = fromInt(0);
		remainder = fromInt(12345);
		FunMultiwordArithmetic.divideUnsigned(remainder, remainder.length, fromInt(11), 1, quotient, remainder, work);
		assertEqualsBI(1122, quotient);
		assertEqualsBI(3, remainder);

		// check remainder overlaps with dividend, divisor >= 65536 case
		remainder = fromInt(721018);
		FunMultiwordArithmetic.divideUnsigned(remainder, remainder.length, fromInt(65537), 1, quotient, remainder, work);
		assertEqualsBI(11, quotient);
		assertEqualsBI(111, remainder);

		// check remainder overlaps with dividend, special case 1
		remainder = fromInt(0);
		FunMultiwordArithmetic.divideUnsigned(remainder, remainder.length, fromInt(10), 1, quotient, remainder, work);
		assertEqualsBI(0, quotient);
		assertEqualsBI(0, remainder);

		// check remainder overlaps with dividend, special case 2
		remainder = fromInt(7);
		FunMultiwordArithmetic.divideUnsigned(remainder, remainder.length, fromInt(1), 1, quotient, remainder, work);
		assertEqualsBI(7, quotient);
		assertEqualsBI(0, remainder);

		// check remainder overlaps with dividend, special case 3
		remainder = fromInt(11, 2);
		FunMultiwordArithmetic.divideUnsigned(remainder, 1, fromHex("1 00000000"), 2, quotient, remainder, work);
		assertEqualsBI(0, quotient);
		assertEqualsBI(11, remainder);

		// check remainder overlaps with divisor, divisor < 65536 case
		remainder = fromInt(11);
		FunMultiwordArithmetic.divideUnsigned(fromInt(12345), 1, remainder, remainder.length, quotient, remainder, work);
		assertEqualsBI(1122, quotient);
		assertEqualsBI(3, remainder);

		// check remainder overlaps with divisor, divisor >= 65536 case
		remainder = fromInt(65537);
		FunMultiwordArithmetic.divideUnsigned(fromInt(721018), 1, remainder, remainder.length, quotient, remainder, work);
		assertEqualsBI(11, quotient);
		assertEqualsBI(111, remainder);

		// check remainder overlaps with divisor, special case 1
		remainder = fromInt(10);
		FunMultiwordArithmetic.divideUnsigned(fromInt(0), 1, remainder, remainder.length, quotient, remainder, work);
		assertEqualsBI(0, quotient);
		assertEqualsBI(0, remainder);

		// check remainder overlaps with divisor, special case 2
		remainder = fromInt(1);
		FunMultiwordArithmetic.divideUnsigned(fromInt(7), 1, remainder, remainder.length, quotient, remainder, work);
		assertEqualsBI(7, quotient);
		assertEqualsBI(0, remainder);

		// check remainder overlaps with divisor, special case 3
		remainder = fromHex("1 00000000");
		FunMultiwordArithmetic.divideUnsigned(fromInt(11), 1, remainder, remainder.length, quotient, remainder, work);
		assertEqualsBI(0, quotient);
		assertEqualsBI(11, remainder);

		// quotient and remainder cannot be the same object
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.divideUnsigned(fromInt(1), 1, fromInt(10), 1, quotient, quotient, work);
		});

		// quotient cannot be null
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.divideIntUnsigned(fromInt(1), 1, 10, null, work);
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.divideUnsigned(fromInt(1), 1, fromInt(10), 1, null, remainder, work);
		});

		// work cannot be null
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.divideIntUnsigned(fromInt(1), 1, 10, quotient, null);
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.divideUnsigned(fromInt(1), 1, fromInt(10), 1, quotient, remainder, null);
		});

		// remainder can be null
		FunMultiwordArithmetic.divideUnsigned(fromInt(1), 1, fromInt(10), 1, quotient, null, work);
		assertEqualsBI(0, quotient);

		// dividend and divisor can be the same object
		divisor = fromInt(10);
		FunMultiwordArithmetic.divideUnsigned(divisor, divisor.length, divisor, divisor.length, quotient, remainder, work);
		assertEqualsBI(1, quotient);
		assertEqualsBI(0, remainder);

		// work may not overlap any input
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.divideUnsigned(dividend, dividend.length, divisor, divisor.length, quotient, remainder, dividend);
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.divideUnsigned(dividend, dividend.length, divisor, divisor.length, quotient, remainder, divisor);
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.divideUnsigned(dividend, dividend.length, divisor, divisor.length, quotient, remainder, quotient);
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.divideUnsigned(dividend, dividend.length, divisor, divisor.length, quotient, remainder, remainder);
		});

		// bounds
		FunMultiwordArithmetic.divideUnsigned(dividend, dividend.length, divisor, divisor.length, quotient, remainder, work);
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.divideUnsigned(dividend, 0, divisor, divisor.length, quotient, remainder, work);
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.divideUnsigned(dividend, dividend.length, divisor, 0, quotient, remainder, work);
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.divideUnsigned(dividend, dividend.length, divisor, divisor.length, new Vector<Int>(0), remainder, work);
		});

		// division by zero
		assertThrowsString(FunExceptions.FUN_DIVISION_BY_ZERO, function() : Void
		{
			FunMultiwordArithmetic.divideIntUnsigned(dividend, dividend.length, 0, quotient, work);
		});
		assertThrowsString(FunExceptions.FUN_DIVISION_BY_ZERO, function() : Void
		{
			FunMultiwordArithmetic.divideUnsigned(dividend, dividend.length, fromInt(0), 1, quotient, remainder, work);
		});

		// divisor with leading 0
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunMultiwordArithmetic.divideUnsigned(dividend, dividend.length, fromHex("1", 2), 2, quotient, remainder, work);
		});
	}

	public function testMultiplicationAndDivision() : Void
	{
		checkLinearEqInt(fromInt(0), 0, fromInt(0), 0);
		checkLinearEqInt(fromInt(0), 1, fromInt(0), 0);
		checkLinearEqInt(fromInt(0), 0, fromInt(1), 0);
		checkLinearEqInt(fromInt(0), 100, fromInt(0), 0);
		checkLinearEqInt(fromInt(1), 1, fromInt(1), 0);
		checkLinearEqInt(fromInt(1), 2, fromInt(0), 1);
		checkLinearEqInt(fromInt(2), 1, fromInt(2), 0);
		checkLinearEqInt(fromInt(2), 3, fromInt(0), 2);
		checkLinearEqInt(fromInt(3), 3, fromInt(1), 0);
		checkLinearEqInt(fromInt(4), 2, fromInt(2), 0);
		checkLinearEqInt(fromInt(4), 3, fromInt(1), 1);
		checkLinearEqInt(fromInt(5), 3, fromInt(1), 2);
		checkLinearEqInt(fromInt(6), 3, fromInt(2), 0);
		checkLinearEqInt(fromInt(6), 2, fromInt(3), 0);
		checkLinearEqInt(fromHex("12A05F2001"), 81, fromInt(987654321), 0);

		checkLinearEq(fromHex("0 fffffffe 00000001"), fromHex("0 ffffffff"), fromHex("0 ffffffff"), fromInt(0));	// exercises qhat = 65536
		checkLinearEq(fromHex("00003fff c0000000 7fff8000 00000000"), fromHex("7fff8000 00000000"), fromHex("00008000 00000001"), fromInt(0));

		checkLinearEqInt(fromInt(2147483647), 1, fromInt(2147483647), 0);
		checkLinearEqInt(fromInt(2147483647), 10, fromInt(214748364), 7);
		checkLinearEqInt(fromInt(2147483647), 100, fromInt(21474836), 47);
		checkLinearEqInt(fromInt(2147483647), 1000, fromInt(2147483), 647);
		checkLinearEqInt(fromInt(2147483647), 10000, fromInt(214748), 3647);
		checkLinearEqInt(fromInt(2147483647), 100000, fromInt(21474), 83647);	// exercises rhat >= 65536
		checkLinearEqInt(fromInt(2147483647), 1000000, fromInt(2147), 483647);
		checkLinearEqInt(fromInt(2147483647), 10000000, fromInt(214), 7483647);
		checkLinearEqInt(fromInt(2147483647), 100000000, fromInt(21), 47483647);
		checkLinearEqInt(fromInt(2147483647), 1000000000, fromInt(2), 147483647);

		checkLinearEqInt(fromInt(2147483647), 2147483647, fromInt(1), 0);		// exercises use of uninitialized quotient data

		checkLinearEqInt(fromHex("100000000"), 1, fromHex("100000000"), 0);
		checkLinearEqInt(fromHex("100000000"), 10, fromInt(429496729), 6);
		checkLinearEqInt(fromHex("100000000"), 100, fromInt(42949672), 96);
		checkLinearEqInt(fromHex("100000000"), 1000, fromInt(4294967), 296);
		checkLinearEqInt(fromHex("100000000"), 10000, fromInt(429496), 7296);
		checkLinearEqInt(fromHex("100000000"), 100000, fromInt(42949), 67296);	// exercises rhat >= 65536
		checkLinearEqInt(fromHex("100000000"), 1000000, fromInt(4294), 967296);
		checkLinearEqInt(fromHex("100000000"), 10000000, fromInt(429), 4967296);
		checkLinearEqInt(fromHex("100000000"), 100000000, fromInt(42), 94967296);
		checkLinearEqInt(fromHex("100000000"), 1000000000, fromInt(4), 294967296);
		checkLinearEq(fromHex("100000000"), fromHex("2540BE400"), fromInt(0), fromHex("100000000"));

		checkLinearEqInt(fromHex("08000"), 1, fromHex("08000"), 0);
		checkLinearEqInt(fromHex("080000000"), 1, fromHex("080000000"), 0);
		checkLinearEqInt(fromHex("0800000000000"), 1, fromHex("0800000000000"), 0);
		checkLinearEqInt(fromHex("08000000000000000"), 1, fromHex("08000000000000000"), 0);
		checkLinearEqInt(fromHex("10001"), 2, fromHex("08000"), 1);
		checkLinearEqInt(fromHex("100000001"), 2, fromHex("080000000"), 1);
		checkLinearEqInt(fromHex("1000000000001"), 2, fromHex("0800000000000"), 1);
		checkLinearEqInt(fromHex("10000000000000001"), 2, fromHex("08000000000000000"), 1);

		checkLinearEqInt(fromHex("0ffffffff"), 1, fromHex("0ffffffff"), 0);
		checkLinearEqInt(fromHex("0ffffffffffffffff"), 1, fromHex("0ffffffffffffffff"), 0);
		checkLinearEqInt(fromHex("0ffffffffffffffffffffffff"), 1, fromHex("0ffffffffffffffffffffffff"), 0);
		checkLinearEqInt(fromHex("0ffffffff"), 2, fromHex("07fffffff"), 1);
		checkLinearEqInt(fromHex("0ffffffffffffffff"), 2, fromHex("07fffffffffffffff"), 1);
		checkLinearEqInt(fromHex("0ffffffffffffffffffffffff"), 2, fromHex("07fffffffffffffffffffffff"), 1);

		// exercise quotient with high bit set when length of divisor == length of dividend and divisor >= 65536
		checkLinearEq(fromHex("4000000000000000"), fromHex("080000000"), fromHex("080000000"), fromInt(0));		// exercises uninitialized work data
		checkLinearEq(fromHex("4000000080000000"), fromHex("080000001"), fromHex("080000000"), fromInt(0));
		checkLinearEq(fromHex("4000000100000000"), fromHex("080000001"), fromHex("080000000"), fromHex("080000000"));
		checkLinearEq(fromHex("40000000ffffffff"), fromHex("080000001"), fromHex("080000000"), fromHex("7fffffff"));
		checkLinearEq(fromHex("4000000100000001"), fromHex("080000001"), fromHex("080000001"), fromInt(0));

		checkLinearEq(fromHex("08000"), fromHex("0800000001"), fromHex("0"), fromHex("08000"));
		// these exercise the qhat reduction path
		checkLinearEq(fromHex("080000000"), fromHex("080000001"), fromHex("0"), fromHex("080000000"));
		checkLinearEq(fromHex("0800080010000"), fromHex("080000001"), fromHex("10000"), fromHex("080000000"));
		checkLinearEq(fromHex("0800100010001"), fromHex("080000001"), fromHex("10001"), fromHex("080000000"));
		checkLinearEq(fromHex("08000000180000000"), fromHex("080000001"), fromHex("100000000"), fromHex("080000000"));
		checkLinearEq(fromHex("08000000200000001"), fromHex("080000001"), fromHex("100000001"), fromHex("080000000"));

		// this exercises long division with a quotient with high bit set
		checkLinearEq(fromHex("08000000180000000"), fromHex("100000000"), fromHex("080000001"), fromHex("080000000"));

		// these exercise the "add back" path
		checkLinearEq(fromHex("7fff800000000000"), fromHex("0800000000001"), fromHex("0fffe"), fromHex("7fffffff0002"));
		checkLinearEq(fromHex("7fffffff800000010000000000000000"), fromHex("0800000008000000200000005"), fromHex("0fffffffd"), fromHex("080000000800000010000000f"));

		checkLinearEq(fromInt(1), fromHex("100000000"), fromInt(0), fromInt(1));
	}
	private function checkLinearEqInt(y : Vector<Int>, a : Int, x : Vector<Int>, b : Int) : Void
	{
		// checks that y = ax + b
//assertBIEqualsBI(y, a * x + b);
		var y_b = new Vector<Int>(y.length);
		FunMultiwordArithmetic.subtract(y_b, y, fromInt(b, y.length), y.length);
		checkMultiplyInt(x, a, y_b);
		if (a != 0)
		{
			checkDivInt(y, a, x, b);
		}
		checkLinearEq(y, fromInt(a), x, fromInt(b));
	}
	private function checkLinearEq(y : Vector<Int>, a : Vector<Int>, x : Vector<Int>, b : Vector<Int>) : Void
	{
		// checks that y = ax + b
//assertBIEqualsBI(y, a * x + b);
		var bExt = new Vector<Int>(y.length);
		FunMultiwordArithmetic.extendUnsigned(bExt, y.length, b, b.length);
		var y_b = new Vector<Int>(y.length);
		FunMultiwordArithmetic.subtract(y_b, y, bExt, y.length);
		checkMultiply(a, x, y_b);
		if (!FunMultiwordArithmetic.isZero(a, a.length))
		{
			checkDiv(y, a, x, b);
		}
		// if we have n / d = q + r / d, then n / q = n * d / (n - r)
		if (!FunMultiwordArithmetic.isZero(y_b, y_b.length))
		{
			var temp = new Vector<Int>(y.length + a.length);
			FunMultiwordArithmetic.multiplyUnsigned(temp, y, y.length, a, a.length);
			var y_bLength = FunMultiwordArithmetic.getLengthUnsigned(y_b, y_b.length);
			var q2 = new Vector<Int>(FunMultiwordArithmetic.getDivisionQuotientLengthUnsigned(temp.length, y_bLength));
			var work = new Vector<Int>(temp.length + y_bLength + 1);
			FunMultiwordArithmetic.divideUnsigned(temp, temp.length, y_b, y_bLength, q2, null, work);

			var r2Length = FunInteger.max(q2.length + x.length, y.length);
			temp = new Vector<Int>(r2Length);
			FunMultiwordArithmetic.multiplyUnsigned(temp, q2, q2.length, x, x.length);
			FunMultiwordArithmetic.extendUnsigned(temp, r2Length, temp, q2.length + x.length);
			var r2 = new Vector<Int>(r2Length);
			FunMultiwordArithmetic.extendUnsigned(r2, r2Length, y, y.length);
			FunMultiwordArithmetic.subtract(r2, r2, temp, r2Length);
			checkDiv(y, x, q2, r2);
		}
	}
	private function checkMultiplyInt(a : Vector<Int>, b : Int, expected : Vector<Int>) : Void
	{
		// TODO
		checkMultiply(a, fromInt(b), expected);
	}
	private function checkMultiply(a : Vector<Int>, b : Vector<Int>, expected : Vector<Int>) : Void
	{
		checkMultiplyCommute( a,  b,  expected);
//checkMultiplyCommute(-a,  b, -expected);
//checkMultiplyCommute( a, -b, -expected);
//checkMultiplyCommute(-a, -b,  expected);
	}
	private function checkMultiplyCommute(a : Vector<Int>, b : Vector<Int>, expected : Vector<Int>) : Void
	{
		checkMultiplySingle(a, b, expected);
		checkMultiplySingle(b, a, expected);
	}
	private function checkMultiplySingle(a : Vector<Int>, b : Vector<Int>, expected : Vector<Int>) : Void
	{
		var result = new Vector<Int>(a.length + b.length);
		FunMultiwordArithmetic.multiplyUnsigned(result, a, a.length, b, b.length);
		var expectedExt = new Vector<Int>(result.length);
		FunMultiwordArithmetic.extendUnsigned(expectedExt, result.length, expected, expected.length);
		assertEqualsBI(expectedExt, result, result.length);
	}
	private function checkDivInt(dividend : Vector<Int>, divisor : Int, expectedQuotient : Vector<Int>, expectedRemainder : Int) : Void
	{
		var quotient = new Vector<Int>(FunMultiwordArithmetic.getDivisionQuotientLengthUnsigned(dividend.length, 1));
		var work = new Vector<Int>(dividend.length + 1 + 1);
		var remainder : Int = FunMultiwordArithmetic.divideIntUnsigned(dividend, dividend.length, divisor, quotient, work);
		assertEquals(expectedRemainder, remainder);
		assertEqualsBI(expectedQuotient, quotient, FunMultiwordArithmetic.getLengthUnsigned(quotient, quotient.length));

		checkDiv(dividend, fromInt(divisor), expectedQuotient, fromInt(expectedRemainder));
	}
	private function checkDiv(dividend : Vector<Int>, divisor : Vector<Int>, expectedQuotient : Vector<Int>, expectedRemainder : Vector<Int>) : Void
	{
		checkDivSingle( dividend,  divisor,  expectedQuotient,  expectedRemainder);
//checkDivSingle( dividend, -divisor, -expectedQuotient,  expectedRemainder);
//checkDivSingle(-dividend,  divisor, -expectedQuotient, -expectedRemainder);
//checkDivSingle(-dividend, -divisor,  expectedQuotient, -expectedRemainder);
	}
	private function checkDivSingle(dividend : Vector<Int>, divisor : Vector<Int>, expectedQuotient : Vector<Int>, expectedRemainder : Vector<Int>) : Void
	{
		var quotient = new Vector<Int>(FunMultiwordArithmetic.getDivisionQuotientLengthUnsigned(dividend.length, divisor.length));
		var remainder = new Vector<Int>(divisor.length);
		var work = new Vector<Int>(dividend.length + divisor.length + 1);
		FunMultiwordArithmetic.divideUnsigned(dividend, dividend.length, divisor, divisor.length, quotient, remainder, work);
		assertEqualsBI(expectedRemainder, remainder, FunMultiwordArithmetic.getLengthUnsigned(remainder, remainder.length));
		assertEqualsBI(expectedQuotient, quotient, FunMultiwordArithmetic.getLengthUnsigned(quotient, quotient.length));
	}

	private static function fromInt(value : Int, length : Int = 1) : Vector<Int>
	{
		var result = new Vector<Int>(length);
		FunMultiwordArithmetic.setFromIntUnsigned(result, length, value);
		return result;
	}
	private static function fromHex(value : String, length : Int = 1) : Vector<Int>
	{
		while (true)
		{
			var result = new Vector<Int>(length);
			if (!FunMultiwordArithmetic.setFromHexUnsigned(result, length, value))
			{
				++length;
				continue;
			}
			return result;
		}
	}

	private static function fill(value : Vector<Int>) : Void
	{
		for (i in 0 ... value.length)
		{
			value.set(i, 0xdeadbeef);
		}
	}
}
