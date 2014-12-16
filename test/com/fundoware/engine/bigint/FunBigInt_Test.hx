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

import com.fundoware.engine.core.FunUtils;
import com.fundoware.engine.exception.FunExceptions;
import haxe.ds.Vector;
import haxe.io.Bytes;

/*
	Binary operations should have these permutations:
		* FunBigInt <op> Int -> non-mutable
		* FunBigInt <op> FunBigInt -> non-mutable
		* FunBigInt <op> FunMutableBigInt -> non-mutable
		* FunMutableBigInt <op> Int -> non-mutable
		* FunMutableBigInt <op> FunBigInt -> non-mutable
		* FunMutableBigInt <op> FunMutableBigInt -> non-mutable
		* FunMutableBigInt <op=> Int -> mutable
		* FunMutableBigInt <op=> FunBigInt ->-mutable
		* FunMutableBigInt <op=> FunMutableBigInt -> mutable

	Things to test for each operation:
		* Commutative property, if appropriate
		* Negation variations
		* Inverse operation
*/
class FunBigInt_Test extends FunBigIntTestCase
{
	public function testWorkOverlapsDividendDoesntDestroyDividend() : Void
	{
		var dividend : FunMutableBigInt = 0;
		var divisor : FunMutableBigInt = 1;
		var quotient : FunMutableBigInt = 0;
		var remainder : FunMutableBigInt = 0;
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunBigIntArithmetic.divide(dividend, divisor, quotient, remainder, dividend);
		});
		assertEquals("00000000", dividend.toHex());
	}

	public function testSetFromBigEndianBytesUnsignedWithLengthAndOffset() : Void
	{
		var t : FunMutableBigInt = 0;
		t.setFromBigEndianBytesUnsigned(FunUtils.hexToBytes("812345"), 0, 1);
		assertEqualsBI(129, t);
		t.setFromBigEndianBytesUnsigned(FunUtils.hexToBytes("812345"), 1, 1);
		assertEqualsBI(35, t);
	}

	public function testSetFromBytesUnsigned() : Void
	{
		assertEqualsBI(FunBigInt.ZERO, FunMutableBigInt.fromBigEndianBytesUnsigned(Bytes.alloc(0)));
		assertEqualsBI(FunBigInt.ZERO, FunMutableBigInt.fromLittleEndianBytesUnsigned(Bytes.alloc(0)));
		checkSetFromBytesUnsigned("81");
		checkSetFromBytesUnsigned("8123");
		checkSetFromBytesUnsigned("812345");
		checkSetFromBytesUnsigned("81234567");
		checkSetFromBytesUnsigned("8123456789");
		checkSetFromBytesUnsigned("8123456789ab");
		checkSetFromBytesUnsigned("8123456789abcd");
		checkSetFromBytesUnsigned("8123456789abcdef");
		checkSetFromBytesUnsigned("8123456789abcdef01");
		checkSetFromBytesUnsigned("8123456789abcdef0123");
		checkSetFromBytesUnsigned("8123456789abcdef012345");
		checkSetFromBytesUnsigned("8123456789abcdef01234567");

		checkSetFromBytesUnsigned("572e4794");
	}
	private function checkSetFromBytesUnsigned(hex : String) : Void
	{
		var t : FunMutableBigInt = 0;
		t.setFromBigEndianBytesUnsigned(FunUtils.hexToBytes(hex));
		assertEqualsBI(FunBigInt.fromHexUnsigned(hex), t);

		var sb = new StringBuf();
		var i = hex.length;
		while (i >= 2)
		{
			i -= 2;
			sb.addChar(hex.charCodeAt(i));
			sb.addChar(hex.charCodeAt(i + 1));
		}
		t.setFromLittleEndianBytesUnsigned(FunUtils.hexToBytes(sb.toString()));
		assertEqualsBI(FunBigInt.fromHexUnsigned(hex), t);
	}

	public function testSetFromUnsignedIntsReusing() : Void
	{
		var t : FunMutableBigInt = 0;

		var v1 = new Vector<Int>(3);
		v1[0] = 0;
		v1[1] = 1;
		v1[2] = -2147483648;
		t.setFromUnsignedInts(v1, 3);
		assertEqualsBI(FunBigInt.fromHexUnsigned("80000000 00000001 00000000"), t);
		v1[1] = -2147483648;
		t.setFromUnsignedInts(v1, 2);
		assertEqualsBI(FunBigInt.fromHexUnsigned("80000000 00000000"), t);
	}

	public function testSetFromUnsignedInts() : Void
	{
		checkSetFromUnsignedInts("00000000", [0]);
		checkSetFromUnsignedInts("7fffffff", [2147483647]);
		checkSetFromUnsignedInts("80000000", [-2147483648]);
		checkSetFromUnsignedInts("ffffffff", [ -1]);

		checkSetFromUnsignedInts("00000000 55555555", [1431655765, 0]);
		checkSetFromUnsignedInts("7fffffff 55555555", [1431655765, 2147483647]);
		checkSetFromUnsignedInts("80000000 55555555", [1431655765, -2147483648]);
		checkSetFromUnsignedInts("ffffffff 55555555", [1431655765, -1]);

		checkSetFromUnsignedInts("00000000 aaaaaaaa", [-1431655766, 0]);
		checkSetFromUnsignedInts("7fffffff aaaaaaaa", [-1431655766, 2147483647]);
		checkSetFromUnsignedInts("80000000 aaaaaaaa", [-1431655766, -2147483648]);
		checkSetFromUnsignedInts("ffffffff aaaaaaaa", [-1431655766, -1]);
	}
	private function checkSetFromUnsignedInts(hex : String, arr : Array<Int>) : Void
	{
		var v = Vector.fromArrayCopy(arr);
		var t : FunMutableBigInt = 0;
		t.setFromUnsignedInts(v, v.length);
		assertEqualsBI(FunBigInt.fromHexUnsigned(hex), t);
	}

	public function testCompare() : Void
	{
		// equality, single-word
		checkCompareInt(0, 0, 0);
		checkCompareInt(0, 1, 1);
		checkCompareInt(0, -1, -1);
		checkCompareInt(0, -2147483648, -2147483648);
		checkCompareInt(0, 2147483647, 2147483647);

		// equality, multi-word
		checkCompare(0, FunBigInt.fromHex("12345678 9abcdef0"), FunBigInt.fromHex("12345678 9abcdef0"));
		checkCompare(0, FunBigInt.fromHex("f2345678 9abcdef0"), FunBigInt.fromHex("f2345678 9abcdef0"));
		checkCompare(0, FunBigInt.fromHex("12345678 9abcdef0 12345678"), FunBigInt.fromHex("12345678 9abcdef0 12345678"));
		checkCompare(0, FunBigInt.fromHex("f2345678 9abcdef0 12345678"), FunBigInt.fromHex("f2345678 9abcdef0 12345678"));

		// less than, single-word
		checkCompareInt(-1, 0, 1);
		checkCompareInt(-1, 1, 2);
		checkCompareInt(-1, -1, 0);
		checkCompareInt(-1, -2, -1);
		checkCompareInt(-1, -2147483648, 2147483647);
		checkCompareInt(-1, -2147483648, -2147483647);
		checkCompareInt(-1, -2147483648, 0);
		checkCompareInt(-1, 0, 2147483647);
		checkCompareInt(-1, 1, 2147483647);
		checkCompareInt(-1, 2147483646, 2147483647);
		checkCompareInt(-1, -1, 2147483647);

		// less than, multi-word, same length
		checkCompare(-1, FunBigInt.fromHex("12345678 9abcdeef"), FunBigInt.fromHex("12345678 9abcdef0"));
		checkCompare(-1, FunBigInt.fromHex("12345677 9abcdef0"), FunBigInt.fromHex("12345678 9abcdef0"));
		checkCompare(-1, FunBigInt.fromHex("f2345678 9abcdef0"), FunBigInt.fromHex("12345678 9abcdef0"));
		checkCompare(-1, FunBigInt.fromHex("f2345678 9abcdeef"), FunBigInt.fromHex("f2345678 9abcdef0"));
		checkCompare(-1, FunBigInt.fromHex("f2345677 9abcdef0"), FunBigInt.fromHex("f2345678 9abcdef0"));

		// less than, multi-word, different length
		checkCompare(-1, FunBigInt.fromHex("12345678 9abcdef0"), FunBigInt.fromHex("00000001 12345678 9abcdef0"));
		checkCompare(-1, FunBigInt.fromHex("f2345678 9abcdef0"), FunBigInt.fromHex("00000001 12345678 9abcdef0"));
		checkCompare(-1, FunBigInt.fromHex("fffffffe 12345678 9abcdef0"), FunBigInt.fromHex("12345678 9abcdef0"));
		checkCompare(-1, FunBigInt.fromHex("fffffffe 12345678 9abcdef0"), FunBigInt.fromHex("f2345678 9abcdef0"));

		// greater than, single-word
		checkCompareInt(1, 1, 0);
		checkCompareInt(1, 2, 1);
		checkCompareInt(1, 0, -1);
		checkCompareInt(1, -1, -2);
		checkCompareInt(1, 2147483647, 2147483646);
		checkCompareInt(1, -2147483647, -2147483648);

		// greater than, multi-word, same length
		checkCompare(1, FunBigInt.fromHex("12345678 9abcdef1"), FunBigInt.fromHex("12345678 9abcdef0"));
		checkCompare(1, FunBigInt.fromHex("12345679 9abcdef0"), FunBigInt.fromHex("12345678 9abcdef0"));
		checkCompare(1, FunBigInt.fromHex("12345678 9abcdef0"), FunBigInt.fromHex("f2345678 9abcdef0"));
		checkCompare(1, FunBigInt.fromHex("f2345678 9abcdef1"), FunBigInt.fromHex("f2345678 9abcdef0"));
		checkCompare(1, FunBigInt.fromHex("f2345679 9abcdef0"), FunBigInt.fromHex("f2345678 9abcdef0"));

		// greater than, multi-word, different length
		checkCompare(1, FunBigInt.fromHex("00000001 12345678 9abcdef0"), FunBigInt.fromHex("12345678 9abcdef0"));
		checkCompare(1, FunBigInt.fromHex("00000001 12345678 9abcdef0"), FunBigInt.fromHex("f2345678 9abcdef0"));
		checkCompare(1, FunBigInt.fromHex("12345678 9abcdef0"), FunBigInt.fromHex("fffffffe 12345678 9abcdef0"));
		checkCompare(1, FunBigInt.fromHex("f2345678 9abcdef0"), FunBigInt.fromHex("fffffffe 12345678 9abcdef0"));

		checkCompare(1, FunBigInt.fromHex("00000001 ffffffff"), FunBigInt.fromHex("00000001 00000000"));
	}
	private function checkCompareInt(expected : Int, a : Int, b : Int) : Void
	{
		var an : FunBigInt = a;
		var am : FunMutableBigInt = a;
		switch (expected)
		{
			case -1:
				assertFalse(a  == b  );
				assertFalse(am == b  );
				assertFalse(an == b  );
				assertTrue (a  != b  );
				assertTrue (am != b  );
				assertTrue (an != b  );
				assertTrue (a  <  b  );
				assertTrue (am <  b  );
				assertTrue (an <  b  );
				assertTrue (a  <= b  );
				assertTrue (am <= b  );
				assertTrue (an <= b  );
				assertFalse(a  >  b  );
				assertFalse(am >  b  );
				assertFalse(an >  b  );
				assertFalse(a  >= b  );
				assertFalse(am >= b  );
				assertFalse(an >= b  );
			case 0:
				assertTrue (a  == b  );
				assertTrue (am == b  );
				assertTrue (an == b  );
				assertFalse(a  != b  );
				assertFalse(am != b  );
				assertFalse(an != b  );
				assertFalse(a  <  b  );
				assertFalse(am <  b  );
				assertFalse(an <  b  );
				assertTrue (a  <= b  );
				assertTrue (am <= b  );
				assertTrue (an <= b  );
				assertFalse(a  >  b  );
				assertFalse(am >  b  );
				assertFalse(an >  b  );
				assertTrue (a  >= b  );
				assertTrue (am >= b  );
				assertTrue (an >= b  );
			case 1:
				assertFalse(a  == b  );
				assertFalse(am == b  );
				assertFalse(an == b  );
				assertTrue (a  != b  );
				assertTrue (am != b  );
				assertTrue (an != b  );
				assertFalse(a  <  b  );
				assertFalse(am <  b  );
				assertFalse(an <  b  );
				assertFalse(a  <= b  );
				assertFalse(am <= b  );
				assertFalse(an <= b  );
				assertTrue (a  >  b  );
				assertTrue (am >  b  );
				assertTrue (an >  b  );
				assertTrue (a  >= b  );
				assertTrue (am >= b  );
				assertTrue (an >= b  );
		}
		checkCompare(expected, FunBigInt.fromInt(a), FunBigInt.fromInt(b));
	}
	private function checkCompare(expected : Int, a : FunBigInt, b : FunBigInt) : Void
	{
		checkCompareSingle( expected,  a,  b);
		checkCompareSingle(-expected, -a, -b);
		if ((expected != 0) && (a.sign() == b.sign()))
		{
			var s : Int = (a.sign() << 1) + 1;
			checkCompareSingle(-s, -a,  b);
			checkCompareSingle( s,  a, -b);
		}
	}
	private function checkCompareSingle(expected : Int, a : FunBigInt, b : FunBigInt) : Void
	{
		assertEquals(expected, FunBigIntArithmetic.compare(a, b));
		if (expected == 0)
		{
			assertEquals(expected, FunBigIntArithmetic.compare(b, a));
		}
		else
		{
			assertEquals(-expected, FunBigIntArithmetic.compare(b, a));
		}

		var am : FunMutableBigInt = a;
		var bm : FunMutableBigInt = b;
		switch (expected)
		{
			case -1:
				assertFalse(a  == b  );
				assertFalse(am == b  );
				assertFalse(a  == bm );
				assertFalse(am == bm );
				assertTrue (a  != b  );
				assertTrue (am != b  );
				assertTrue (a  != bm );
				assertTrue (am != bm );
				assertTrue (a  <  b  );
				assertTrue (am <  b  );
				assertTrue (a  <  bm );
				assertTrue (am <  bm );
				assertTrue (a  <= b  );
				assertTrue (am <= b  );
				assertTrue (a  <= bm );
				assertTrue (am <= bm );
				assertFalse(a  >  b  );
				assertFalse(am >  b  );
				assertFalse(a  >  bm );
				assertFalse(am >  bm );
				assertFalse(a  >= b  );
				assertFalse(am >= b  );
				assertFalse(a  >= bm );
				assertFalse(am >= bm );
			case 0:
				assertTrue (a  == b  );
				assertTrue (am == b  );
				assertTrue (a  == bm );
				assertTrue (am == bm );
				assertFalse(a  != b  );
				assertFalse(am != b  );
				assertFalse(a  != bm );
				assertFalse(am != bm );
				assertFalse(a  <  b  );
				assertFalse(am <  b  );
				assertFalse(a  <  bm );
				assertFalse(am <  bm );
				assertTrue (a  <= b  );
				assertTrue (am <= b  );
				assertTrue (a  <= bm );
				assertTrue (am <= bm );
				assertFalse(a  >  b  );
				assertFalse(am >  b  );
				assertFalse(a  >  bm );
				assertFalse(am >  bm );
				assertTrue (a  >= b  );
				assertTrue (am >= b  );
				assertTrue (a  >= bm );
				assertTrue (am >= bm );
			case 1:
				assertFalse(a  == b  );
				assertFalse(am == b  );
				assertFalse(a  == bm );
				assertFalse(am == bm );
				assertTrue (a  != b  );
				assertTrue (am != b  );
				assertTrue (a  != bm );
				assertTrue (am != bm );
				assertFalse(a  <  b  );
				assertFalse(am <  b  );
				assertFalse(a  <  bm );
				assertFalse(am <  bm );
				assertFalse(a  <= b  );
				assertFalse(am <= b  );
				assertFalse(a  <= bm );
				assertFalse(am <= bm );
				assertTrue (a  >  b  );
				assertTrue (am >  b  );
				assertTrue (a  >  bm );
				assertTrue (am >  bm );
				assertTrue (a  >= b  );
				assertTrue (am >= b  );
				assertTrue (a  >= bm );
				assertTrue (am >= bm );
		}
	}

	public function testMultiplicationAndDivisionSemantics() : Void
	{
		var dividend : FunMutableBigInt = 0;
		var divisor : FunMutableBigInt;
		var quotient : FunMutableBigInt;
		var remainder : FunMutableBigInt = 0;
		var remainderInt : Int;

		// if result of multiplication is an input, should throw an exception
		var a : FunMutableBigInt = 2;
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunBigIntArithmetic.multiply(a, a, FunBigInt.fromInt(2));
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunBigIntArithmetic.multiply(a, FunBigInt.fromInt(2), a);
		});

		// Multiplication of same inputs is ok
		var b : FunMutableBigInt = 0;
		FunBigIntArithmetic.multiply(b, a, a);
		assertBIEqualsInt(4, b);

		// division by zero should throw exception
		assertThrowsString(FunExceptions.FUN_DIVISION_BY_ZERO, function() : Void
		{
			FunBigInt.fromInt(1) / 0;
		});
		assertThrowsString(FunExceptions.FUN_DIVISION_BY_ZERO, function() : Void
		{
			FunBigInt.fromInt(0) / 0;
		});

		// check quotient overlaps with dividend, divisor < 65536 case
		quotient = 12345;
		remainderInt = FunBigIntArithmetic.divideInt(quotient, 11, quotient);
		assertBIEqualsInt(1122, quotient);
		assertEquals(3, remainderInt);
		quotient = 12345;
		FunBigIntArithmetic.divide(quotient, FunBigInt.fromInt(11), quotient, remainder);
		assertBIEqualsInt(1122, quotient);
		assertBIEqualsInt(3, remainder);

		// check quotient overlaps with dividend, divisor >= 65536 case
		quotient = 721018;
		divisor = 65537;
		FunBigIntArithmetic.divide(quotient, divisor, quotient, remainder);
		assertBIEqualsInt(11, quotient);
		assertBIEqualsInt(111, remainder);

		// check quotient overlaps with dividend, special case 1
		quotient = 0;
		divisor = 11;
		FunBigIntArithmetic.divide(quotient, divisor, quotient, remainder);
		assertBIEqualsInt(0, quotient);
		assertBIEqualsInt(0, remainder);

		// check quotient overlaps with dividend, special case 2
		quotient = 7;
		FunBigIntArithmetic.divide(quotient, FunBigInt.fromInt(1), quotient, remainder);
		assertBIEqualsInt(7, quotient);
		assertBIEqualsInt(0, remainder);

		// check quotient overlaps with dividend, special case 3
		quotient = 11;
		FunBigIntArithmetic.divide(quotient, FunBigInt.fromHex("1 00000000"), quotient, remainder);
		assertBIEqualsInt(0, quotient);
		assertBIEqualsInt(11, remainder);

		// check quotient overlaps with divisor, divisor < 65536 case
		quotient = 11;
		FunBigIntArithmetic.divide(FunBigInt.fromInt(12345), quotient, quotient, remainder);
		assertBIEqualsInt(1122, quotient);
		assertBIEqualsInt(3, remainder);

		// check quotient overlaps with divisor, divisor >= 65536 case
		quotient = 65537;
		FunBigIntArithmetic.divide(FunBigInt.fromInt(721018), quotient, quotient, remainder);
		assertBIEqualsInt(11, quotient);
		assertBIEqualsInt(111, remainder);

		// check quotient overlaps with divisor, special case 1
		quotient = 10;
		FunBigIntArithmetic.divide(FunBigInt.fromInt(0), quotient, quotient, remainder);
		assertBIEqualsInt(0, quotient);
		assertBIEqualsInt(0, remainder);

		// check quotient overlaps with divisor, special case 2
		quotient = 1;
		FunBigIntArithmetic.divide(FunBigInt.fromInt(7), quotient, quotient, remainder);
		assertBIEqualsInt(7, quotient);
		assertBIEqualsInt(0, remainder);

		// check quotient overlaps with divisor, special case 3
		quotient = FunBigInt.fromHex("1 00000000");
		FunBigIntArithmetic.divide(FunBigInt.fromInt(11), quotient, quotient, remainder);
		assertBIEqualsInt(0, quotient);
		assertBIEqualsInt(11, remainder);

		// check remainder overlaps with dividend, divisor < 65536 case
		remainder = 12345;
		FunBigIntArithmetic.divide(remainder, FunBigInt.fromInt(11), quotient, remainder);
		assertBIEqualsInt(1122, quotient);
		assertBIEqualsInt(3, remainder);

		// check remainder overlaps with dividend, divisor >= 65536 case
		remainder = 721018;
		FunBigIntArithmetic.divide(remainder, FunBigInt.fromInt(65537), quotient, remainder);
		assertBIEqualsInt(11, quotient);
		assertBIEqualsInt(111, remainder);

		// check remainder overlaps with dividend, special case 1
		remainder = 0;
		FunBigIntArithmetic.divide(remainder, FunBigInt.fromInt(10), quotient, remainder);
		assertBIEqualsInt(0, quotient);
		assertBIEqualsInt(0, remainder);

		// check remainder overlaps with dividend, special case 2
		remainder = 7;
		FunBigIntArithmetic.divide(remainder, FunBigInt.fromInt(1), quotient, remainder);
		assertBIEqualsInt(7, quotient);
		assertBIEqualsInt(0, remainder);

		// check remainder overlaps with dividend, special case 3
		remainder = 11;
		FunBigIntArithmetic.divide(remainder, FunBigInt.fromHex("1 00000000"), quotient, remainder);
		assertBIEqualsInt(0, quotient);
		assertBIEqualsInt(11, remainder);

		// check remainder overlaps with divisor, divisor < 65536 case
		remainder = 11;
		FunBigIntArithmetic.divide(FunBigInt.fromInt(12345), remainder, quotient, remainder);
		assertBIEqualsInt(1122, quotient);
		assertBIEqualsInt(3, remainder);

		// check remainder overlaps with divisor, divisor >= 65536 case
		remainder = 65537;
		FunBigIntArithmetic.divide(FunBigInt.fromInt(721018), remainder, quotient, remainder);
		assertBIEqualsInt(11, quotient);
		assertBIEqualsInt(111, remainder);

		// check remainder overlaps with divisor, special case 1
		remainder = 10;
		FunBigIntArithmetic.divide(FunBigInt.fromInt(0), remainder, quotient, remainder);
		assertBIEqualsInt(0, quotient);
		assertBIEqualsInt(0, remainder);

		// check remainder overlaps with divisor, special case 2
		remainder = 1;
		FunBigIntArithmetic.divide(FunBigInt.fromInt(7), remainder, quotient, remainder);
		assertBIEqualsInt(7, quotient);
		assertBIEqualsInt(0, remainder);

		// check remainder overlaps with divisor, special case 3
		remainder = FunBigInt.fromHex("1 00000000");
		FunBigIntArithmetic.divide(FunBigInt.fromInt(11), remainder, quotient, remainder);
		assertBIEqualsInt(0, quotient);
		assertBIEqualsInt(11, remainder);

		// quotient and remainder cannot be the same object
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunBigIntArithmetic.divide(FunBigInt.fromInt(1), FunBigInt.fromInt(10), quotient, quotient);
		});

		// quotient cannot be null
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunBigIntArithmetic.divideInt(FunBigInt.fromInt(1), 10, null);
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunBigIntArithmetic.divide(FunBigInt.fromInt(1), FunBigInt.fromInt(10), null, remainder);
		});

		// remainder can be null
		FunBigIntArithmetic.divide(FunBigInt.fromInt(1), FunBigInt.fromInt(10), quotient, null);
		assertBIEqualsInt(0, quotient);

		// dividend and divisor can be the same object
		divisor = 10;
		FunBigIntArithmetic.divide(divisor, divisor, quotient, remainder);
		assertBIEqualsInt(1, quotient);
		assertBIEqualsInt(0, remainder);

		// work may not overlap any input
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunBigIntArithmetic.divide(dividend, divisor, quotient, remainder, dividend);
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunBigIntArithmetic.divide(dividend, divisor, quotient, remainder, divisor);
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunBigIntArithmetic.divide(dividend, divisor, quotient, remainder, quotient);
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunBigIntArithmetic.divide(dividend, divisor, quotient, remainder, remainder);
		});
	}

	public function testMultiplicationAndDivision() : Void
	{
		checkLinearEqInt(FunBigInt.fromInt(0), 0, FunBigInt.fromInt(0), 0);
		checkLinearEqInt(FunBigInt.fromInt(0), 1, FunBigInt.fromInt(0), 0);
		checkLinearEqInt(FunBigInt.fromInt(0), 0, FunBigInt.fromInt(1), 0);
		checkLinearEqInt(FunBigInt.fromInt(0), 100, FunBigInt.fromInt(0), 0);
		checkLinearEqInt(FunBigInt.fromInt(1), 1, FunBigInt.fromInt(1), 0);
		checkLinearEqInt(FunBigInt.fromInt(1), 2, FunBigInt.fromInt(0), 1);
		checkLinearEqInt(FunBigInt.fromInt(2), 1, FunBigInt.fromInt(2), 0);
		checkLinearEqInt(FunBigInt.fromInt(2), 3, FunBigInt.fromInt(0), 2);
		checkLinearEqInt(FunBigInt.fromInt(3), 3, FunBigInt.fromInt(1), 0);
		checkLinearEqInt(FunBigInt.fromInt(4), 2, FunBigInt.fromInt(2), 0);
		checkLinearEqInt(FunBigInt.fromInt(4), 3, FunBigInt.fromInt(1), 1);
		checkLinearEqInt(FunBigInt.fromInt(5), 3, FunBigInt.fromInt(1), 2);
		checkLinearEqInt(FunBigInt.fromInt(6), 3, FunBigInt.fromInt(2), 0);
		checkLinearEqInt(FunBigInt.fromInt(6), 2, FunBigInt.fromInt(3), 0);
		checkLinearEqInt(FunBigInt.fromHex("12A05F2001"), 81, FunBigInt.fromInt(987654321), 0);

		checkLinearEq(FunBigInt.fromHex("0 fffffffe 00000001"), FunBigInt.fromHex("0 ffffffff"), FunBigInt.fromHex("0 ffffffff"), FunBigInt.fromInt(0));	// exercises qhat = 65536
		checkLinearEq(FunBigInt.fromHex("00003fff c0000000 7fff8000 00000000"), FunBigInt.fromHex("7fff8000 00000000"), FunBigInt.fromHex("00008000 00000001"), FunBigInt.fromInt(0));

		checkLinearEqInt(FunBigInt.fromInt(2147483647), 1, FunBigInt.fromInt(2147483647), 0);
		checkLinearEqInt(FunBigInt.fromInt(2147483647), 10, FunBigInt.fromInt(214748364), 7);
		checkLinearEqInt(FunBigInt.fromInt(2147483647), 100, FunBigInt.fromInt(21474836), 47);
		checkLinearEqInt(FunBigInt.fromInt(2147483647), 1000, FunBigInt.fromInt(2147483), 647);
		checkLinearEqInt(FunBigInt.fromInt(2147483647), 10000, FunBigInt.fromInt(214748), 3647);
		checkLinearEqInt(FunBigInt.fromInt(2147483647), 100000, FunBigInt.fromInt(21474), 83647);	// exercises rhat >= 65536
		checkLinearEqInt(FunBigInt.fromInt(2147483647), 1000000, FunBigInt.fromInt(2147), 483647);
		checkLinearEqInt(FunBigInt.fromInt(2147483647), 10000000, FunBigInt.fromInt(214), 7483647);
		checkLinearEqInt(FunBigInt.fromInt(2147483647), 100000000, FunBigInt.fromInt(21), 47483647);
		checkLinearEqInt(FunBigInt.fromInt(2147483647), 1000000000, FunBigInt.fromInt(2), 147483647);

		checkLinearEqInt(FunBigInt.fromInt(2147483647), 2147483647, FunBigInt.fromInt(1), 0);		// exercises use of uninitialized quotient data

		checkLinearEqInt(FunBigInt.fromHex("100000000"), 1, FunBigInt.fromHex("100000000"), 0);
		checkLinearEqInt(FunBigInt.fromHex("100000000"), 10, FunBigInt.fromInt(429496729), 6);
		checkLinearEqInt(FunBigInt.fromHex("100000000"), 100, FunBigInt.fromInt(42949672), 96);
		checkLinearEqInt(FunBigInt.fromHex("100000000"), 1000, FunBigInt.fromInt(4294967), 296);
		checkLinearEqInt(FunBigInt.fromHex("100000000"), 10000, FunBigInt.fromInt(429496), 7296);
		checkLinearEqInt(FunBigInt.fromHex("100000000"), 100000, FunBigInt.fromInt(42949), 67296);	// exercises rhat >= 65536
		checkLinearEqInt(FunBigInt.fromHex("100000000"), 1000000, FunBigInt.fromInt(4294), 967296);
		checkLinearEqInt(FunBigInt.fromHex("100000000"), 10000000, FunBigInt.fromInt(429), 4967296);
		checkLinearEqInt(FunBigInt.fromHex("100000000"), 100000000, FunBigInt.fromInt(42), 94967296);
		checkLinearEqInt(FunBigInt.fromHex("100000000"), 1000000000, FunBigInt.fromInt(4), 294967296);
		checkLinearEq(FunBigInt.fromHex("100000000"), FunBigInt.fromHex("2540BE400"), FunBigInt.fromInt(0), FunBigInt.fromHex("100000000"));

		checkLinearEqInt(FunBigInt.fromHex("08000"), 1, FunBigInt.fromHex("08000"), 0);
		checkLinearEqInt(FunBigInt.fromHex("080000000"), 1, FunBigInt.fromHex("080000000"), 0);
		checkLinearEqInt(FunBigInt.fromHex("0800000000000"), 1, FunBigInt.fromHex("0800000000000"), 0);
		checkLinearEqInt(FunBigInt.fromHex("08000000000000000"), 1, FunBigInt.fromHex("08000000000000000"), 0);
		checkLinearEqInt(FunBigInt.fromHex("10001"), 2, FunBigInt.fromHex("08000"), 1);
		checkLinearEqInt(FunBigInt.fromHex("100000001"), 2, FunBigInt.fromHex("080000000"), 1);
		checkLinearEqInt(FunBigInt.fromHex("1000000000001"), 2, FunBigInt.fromHex("0800000000000"), 1);
		checkLinearEqInt(FunBigInt.fromHex("10000000000000001"), 2, FunBigInt.fromHex("08000000000000000"), 1);

		checkLinearEqInt(FunBigInt.fromHex("0ffffffff"), 1, FunBigInt.fromHex("0ffffffff"), 0);
		checkLinearEqInt(FunBigInt.fromHex("0ffffffffffffffff"), 1, FunBigInt.fromHex("0ffffffffffffffff"), 0);
		checkLinearEqInt(FunBigInt.fromHex("0ffffffffffffffffffffffff"), 1, FunBigInt.fromHex("0ffffffffffffffffffffffff"), 0);
		checkLinearEqInt(FunBigInt.fromHex("0ffffffff"), 2, FunBigInt.fromHex("07fffffff"), 1);
		checkLinearEqInt(FunBigInt.fromHex("0ffffffffffffffff"), 2, FunBigInt.fromHex("07fffffffffffffff"), 1);
		checkLinearEqInt(FunBigInt.fromHex("0ffffffffffffffffffffffff"), 2, FunBigInt.fromHex("07fffffffffffffffffffffff"), 1);

		// exercise quotient with high bit set when length of divisor == length of dividend and divisor >= 65536
		checkLinearEq(FunBigInt.fromHex("4000000000000000"), FunBigInt.fromHex("080000000"), FunBigInt.fromHex("080000000"), FunBigInt.fromInt(0));		// exercises uninitialized work data
		checkLinearEq(FunBigInt.fromHex("4000000080000000"), FunBigInt.fromHex("080000001"), FunBigInt.fromHex("080000000"), FunBigInt.fromInt(0));
		checkLinearEq(FunBigInt.fromHex("4000000100000000"), FunBigInt.fromHex("080000001"), FunBigInt.fromHex("080000000"), FunBigInt.fromHex("080000000"));
		checkLinearEq(FunBigInt.fromHex("40000000ffffffff"), FunBigInt.fromHex("080000001"), FunBigInt.fromHex("080000000"), FunBigInt.fromHex("7fffffff"));
		checkLinearEq(FunBigInt.fromHex("4000000100000001"), FunBigInt.fromHex("080000001"), FunBigInt.fromHex("080000001"), FunBigInt.fromInt(0));

		checkLinearEq(FunBigInt.fromHex("08000"), FunBigInt.fromHex("0800000001"), FunBigInt.fromHex("0"), FunBigInt.fromHex("08000"));
		// these exercise the qhat reduction path
		checkLinearEq(FunBigInt.fromHex("080000000"), FunBigInt.fromHex("080000001"), FunBigInt.fromHex("0"), FunBigInt.fromHex("080000000"));
		checkLinearEq(FunBigInt.fromHex("0800080010000"), FunBigInt.fromHex("080000001"), FunBigInt.fromHex("10000"), FunBigInt.fromHex("080000000"));
		checkLinearEq(FunBigInt.fromHex("0800100010001"), FunBigInt.fromHex("080000001"), FunBigInt.fromHex("10001"), FunBigInt.fromHex("080000000"));
		checkLinearEq(FunBigInt.fromHex("08000000180000000"), FunBigInt.fromHex("080000001"), FunBigInt.fromHex("100000000"), FunBigInt.fromHex("080000000"));
		checkLinearEq(FunBigInt.fromHex("08000000200000001"), FunBigInt.fromHex("080000001"), FunBigInt.fromHex("100000001"), FunBigInt.fromHex("080000000"));

		// this exercises long division with a quotient with high bit set
		checkLinearEq(FunBigInt.fromHex("08000000180000000"), FunBigInt.fromHex("100000000"), FunBigInt.fromHex("080000001"), FunBigInt.fromHex("080000000"));

		// these exercise the "add back" path
		checkLinearEq(FunBigInt.fromHex("7fff800000000000"), FunBigInt.fromHex("0800000000001"), FunBigInt.fromHex("0fffe"), FunBigInt.fromHex("7fffffff0002"));
		checkLinearEq(FunBigInt.fromHex("7fffffff800000010000000000000000"), FunBigInt.fromHex("0800000008000000200000005"), FunBigInt.fromHex("0fffffffd"), FunBigInt.fromHex("080000000800000010000000f"));

		checkLinearEq(FunBigInt.fromInt(1), FunBigInt.fromHex("100000000"), FunBigInt.fromInt(0), FunBigInt.fromInt(1));
	}
	private function checkLinearEqInt(y : FunBigInt, a : Int, x : FunBigInt, b : Int) : Void
	{
		// checks that y = ax + b
		assertBIEqualsBI(y, a * x + b);
		assertBIEqualsBI(y, x * a + b);
		assertBIEqualsBI(y, b + a * x);
		assertBIEqualsBI(y, b + x * a);
		checkMultiplyInt(x, a, y - b);
		if (a != 0)
		{
			checkDivInt(y, a, x, b);
		}
		checkLinearEq(y, FunBigInt.fromInt(a), x, FunBigInt.fromInt(b));
	}
	private function checkLinearEq(y : FunBigInt, a : FunBigInt, x : FunBigInt, b : FunBigInt) : Void
	{
		// checks that y = ax + b
		assertBIEqualsBI(y, a * x + b);
		assertBIEqualsBI(y, x * a + b);
		assertBIEqualsBI(y, b + a * x);
		assertBIEqualsBI(y, b + x * a);
		checkMultiply(a, x, y - b);
		if (!a.isZero())
		{
			checkDiv(y, a, x, b);
		}
		// if we have n / d = q + r / d, then n / q = n * d / (n - r)
		var y_b = y - b;
		if (!y_b.isZero())
		{
			var q2 = y * a / y_b;
			var r2 = y - q2 * x;
			checkDiv(y, x, q2, r2);
		}
	}
	private function checkMultiplyInt(a : FunBigInt, b : Int, expected : FunBigInt) : Void
	{
		var am : FunMutableBigInt = a;
		assertBIEqualsBI(expected, a  * b);
		assertBIEqualsBI(expected, am * b);
		am *= b;
		assertBIEqualsBI(expected, am);

		checkMultiply(a, FunBigInt.fromInt(b), expected);
	}
	private function checkMultiply(a : FunBigInt, b : FunBigInt, expected : FunBigInt) : Void
	{
		checkMultiplyCommute( a,  b,  expected);
		checkMultiplyCommute(-a,  b, -expected);
		checkMultiplyCommute( a, -b, -expected);
		checkMultiplyCommute(-a, -b,  expected);
	}
	private function checkMultiplyCommute(a : FunBigInt, b : FunBigInt, expected : FunBigInt) : Void
	{
		checkMultiplySingle(a, b, expected);
		checkMultiplySingle(b, a, expected);
	}
	private function checkMultiplySingle(a : FunBigInt, b : FunBigInt, expected : FunBigInt) : Void
	{
		var am : FunMutableBigInt = a;
		var bm : FunMutableBigInt = b;

		assertBIEqualsBI(expected, a  * b );
		assertBIEqualsBI(expected, am * b );
		assertBIEqualsBI(expected, a  * bm);
		assertBIEqualsBI(expected, am * bm);

		am = a;
		am *= b;
		assertBIEqualsBI(expected, am);
		am = a;
		am *= bm;
		assertBIEqualsBI(expected, am);
	}
	private function checkDivInt(dividend : FunBigInt, divisor : Int, expectedQuotient : FunBigInt, expectedRemainder : Int) : Void
	{
		var dividendM : FunMutableBigInt = dividend;

		var quotient : FunMutableBigInt = 0;
		var remainder : Int;
		remainder = FunBigIntArithmetic.divideInt(dividend, divisor, quotient);
		assertEquals(expectedRemainder, remainder);
		assertBIEqualsBI(expectedQuotient, quotient);

		assertBIEqualsBI(expectedQuotient, dividend  / divisor );
		assertBIEqualsBI(expectedQuotient, dividendM / divisor );
		assertBIEqualsBI(expectedRemainder, dividend  % divisor );
		assertBIEqualsBI(expectedRemainder, dividendM % divisor );

		dividendM = dividend;
		dividendM /= divisor;
		assertBIEqualsBI(expectedQuotient, dividendM);
		dividendM = dividend;
		dividendM %= divisor;
		assertBIEqualsBI(expectedRemainder, dividendM);

		checkDiv(dividend, FunBigInt.fromInt(divisor), expectedQuotient, FunBigInt.fromInt(expectedRemainder));
	}
	private function checkDiv(dividend : FunBigInt, divisor : FunBigInt, expectedQuotient : FunBigInt, expectedRemainder : FunBigInt) : Void
	{
		checkDivSingle( dividend,  divisor,  expectedQuotient,  expectedRemainder);
		checkDivSingle( dividend, -divisor, -expectedQuotient,  expectedRemainder);
		checkDivSingle(-dividend,  divisor, -expectedQuotient, -expectedRemainder);
		checkDivSingle(-dividend, -divisor,  expectedQuotient, -expectedRemainder);
	}
	private function checkDivSingle(dividend : FunBigInt, divisor : FunBigInt, expectedQuotient : FunBigInt, expectedRemainder : FunBigInt) : Void
	{
		var dividendM : FunMutableBigInt = dividend;
		var divisorM : FunMutableBigInt = divisor;

		var quotient : FunMutableBigInt = 0;
		var remainder : FunMutableBigInt = 0;
		FunBigIntArithmetic.divide(dividend, divisor, quotient, remainder);
		assertBIEqualsBI(expectedRemainder, remainder);
		assertBIEqualsBI(expectedQuotient, quotient);

		assertBIEqualsBI(dividend, quotient * divisor + remainder);

		assertBIEqualsBI(expectedQuotient, dividend  / divisor );
		assertBIEqualsBI(expectedQuotient, dividendM / divisor );
		assertBIEqualsBI(expectedQuotient, dividend  / divisorM);
		assertBIEqualsBI(expectedQuotient, dividendM / divisorM);
		assertBIEqualsBI(expectedRemainder, dividend  % divisor );
		assertBIEqualsBI(expectedRemainder, dividendM % divisor );
		assertBIEqualsBI(expectedRemainder, dividend  % divisorM);
		assertBIEqualsBI(expectedRemainder, dividendM % divisorM);

		dividendM = dividend;
		dividendM /= divisor;
		assertBIEqualsBI(expectedQuotient, dividendM);
		dividendM = dividend;
		dividendM /= divisorM;
		assertBIEqualsBI(expectedQuotient, dividendM);
		dividendM = dividend;
		dividendM %= divisor;
		assertBIEqualsBI(expectedRemainder, dividendM);
		dividendM = dividend;
		dividendM %= divisorM;
		assertBIEqualsBI(expectedRemainder, dividendM);
	}

	public function testAssignment() : Void
	{
		var a : FunBigInt = 1;
		assertBIEqualsInt(1, a);
		a = 2;
		assertBIEqualsInt(2, a);
		var b : FunBigInt = 3;
		assertBIEqualsInt(3, b);
		a = 3;
		assertBIEqualsBI(b, a);
		a = b;
		assertBIEqualsBI(b, a);

		var c : FunMutableBigInt = 1;
		assertBIEqualsInt(1, c);
		c = 2;
		assertBIEqualsInt(2, c);
		c = a;
		assertBIEqualsInt(3, c);

		// TODO: What to do about this?
		/*var d : FunMutableBigInt = c;
		assertBIEqualsInt(3, d);
		c <<= 1;
		assertBIEqualsInt(6, c);
		assertBIEqualsInt(3, d);*/
	}

	public function testEquality() : Void
	{
		checkEquality(FunBigInt.fromInt(0), FunBigInt.fromInt(0), true);
		checkEquality(FunBigInt.fromInt(0), FunBigInt.fromInt(1), false);
		checkEquality(FunBigInt.fromInt(1), FunBigInt.fromInt(1), true);
		checkEquality(FunBigInt.fromInt(0x12345678), FunBigInt.fromInt(0x12345678), true);
		checkEquality(FunBigInt.fromInt(0x12345678), FunBigInt.fromInt(0x12345670), false);
		checkEquality(FunBigInt.fromHex("1234567800000000"), FunBigInt.fromInt(0), false);
		checkEquality(FunBigInt.fromHex("1234567800000000"), FunBigInt.fromHex("1234567800000000"), true);
		checkEquality(FunBigInt.fromHex("1234567800000000"), FunBigInt.fromHex("11234567800000000"), false);
		checkEquality(FunBigInt.fromHex("1234567800000000"), FunBigInt.fromHex("123456780000000"), false);
	}
	private function checkEquality(a : FunBigInt, b : FunBigInt, expected : Bool) : Void
	{
		assertEquals(expected, a == b);
		assertEquals(expected, b == a);

		var a1 : FunMutableBigInt = a;
		assertEquals(expected, a1 == b);
		assertEquals(expected, b == a1);

		var b1 : FunMutableBigInt = b;
		assertEquals(expected, a == b1);
		assertEquals(expected, b1 == a);

		assertEquals(expected, a1 == b1);
		assertEquals(expected, b1 == a1);
	}

	public function testAddAssignDoesntClobber() : Void
	{
		var a : FunBigInt = FunBigInt.fromInt(1);
		var b : FunMutableBigInt = a;
		b += 1;
		assertBIEqualsInt(1, a);
		assertBIEqualsInt(2, b);
	}

	public function testAdditionAndSubtraction() : Void
	{
		checkAddInt(FunBigInt.fromInt(0), 0, FunBigInt.fromInt(0));
		checkAddInt(FunBigInt.fromInt(0), 1, FunBigInt.fromInt(1));
		checkAddInt(FunBigInt.fromInt(1), 1, FunBigInt.fromInt(2));
		checkAddInt(FunBigInt.fromInt(-1), 0, FunBigInt.fromInt(-1));
		checkAddInt(FunBigInt.fromInt(-1), 1, FunBigInt.fromInt(0));
		checkAddInt(FunBigInt.fromInt(-1), 2, FunBigInt.fromInt(1));
		checkAddInt(FunBigInt.fromInt(-1), -1, FunBigInt.fromInt(-2));

		checkAddInt(FunBigInt.fromHex("000000000000000007fffffff"), 1, FunBigInt.fromHex("0000000000000000080000000"));
		checkAddInt(FunBigInt.fromHex("0000000007fffffffffffffff"), 1, FunBigInt.fromHex("0000000008000000000000000"));
		checkAddInt(FunBigInt.fromHex("07fffffffffffffffffffffff"), 1, FunBigInt.fromHex("0800000000000000000000000"));
		checkAddInt(FunBigInt.fromHex("0ffffffffffffffffffffffff"), 1, FunBigInt.fromHex("1000000000000000000000000"));
		checkAddInt(FunBigInt.fromHex("0fffffffffffffffeffffffff"), 1, FunBigInt.fromHex("0ffffffffffffffff00000000"));

		checkAdd(FunBigInt.fromHex("0ffffffffffffffff00000000"), FunBigInt.fromHex("100000000"), FunBigInt.fromHex("1000000000000000000000000"));
		checkAdd(FunBigInt.fromHex("0ffffffff0000000000000000"), FunBigInt.fromHex("10000000000000000"), FunBigInt.fromHex("1000000000000000000000000"));

		checkAdd(FunBigInt.fromHex("12345678"), FunBigInt.fromHex("11111111"), FunBigInt.fromHex("23456789"));
		checkAdd(FunBigInt.fromHex("1234567812345678"), FunBigInt.fromHex("1111111111111111"), FunBigInt.fromHex("2345678923456789"));
		checkAdd(FunBigInt.fromHex("123456781234567812345678"), FunBigInt.fromHex("111111111111111111111111"), FunBigInt.fromHex("234567892345678923456789"));
		checkAdd(FunBigInt.fromHex("1234567812345678"), FunBigInt.fromHex("11111111"), FunBigInt.fromHex("1234567823456789"));
		checkAdd(FunBigInt.fromHex("123456781234567812345678"), FunBigInt.fromHex("11111111"), FunBigInt.fromHex("123456781234567823456789"));
		checkAdd(FunBigInt.fromHex("1234567812345678"), FunBigInt.fromHex("1111111100000000"), FunBigInt.fromHex("2345678912345678"));
		checkAdd(FunBigInt.fromHex("123456781234567812345678"), FunBigInt.fromHex("111111110000000000000000"), FunBigInt.fromHex("234567891234567812345678"));
		checkAdd(FunBigInt.fromHex("123456781234567812345678"), FunBigInt.fromHex("111111110000000011111111"), FunBigInt.fromHex("234567891234567823456789"));
	}
	private function checkAddInt(a : FunBigInt, b : Int, expected : FunBigInt) : Void
	{
		var am : FunMutableBigInt = a;
		assertBIEqualsBI(expected, a  + b);
		assertBIEqualsBI(expected, am + b);
		am += b;
		assertBIEqualsBI(expected, am);

		checkAdd(a, FunBigInt.fromInt(b), expected);
	}
	private function checkAdd(a : FunBigInt, b : FunBigInt, expected : FunBigInt) : Void
	{
		checkAddCommute(a, b, expected);
		checkAddCommute(-a, -b, -expected);
		checkAddCommute(expected, -a, b);
		checkAddCommute(expected, -b, a);
	}
	private function checkAddCommute(a : FunBigInt, b : FunBigInt, expected : FunBigInt) : Void
	{
		checkAddSingle(a, b, expected);
		checkAddSingle(b, a, expected);
	}
	private function checkAddSingle(a : FunBigInt, b : FunBigInt, expected : FunBigInt) : Void
	{
		var am : FunMutableBigInt = a;
		var bm : FunMutableBigInt = b;
		var em : FunMutableBigInt = expected;

		// addition
		assertBIEqualsBI(expected, a  + b);
		assertBIEqualsBI(expected, am + bm);
		assertBIEqualsBI(expected, am + b );
		assertBIEqualsBI(expected, a  + bm);
		am = a;
		am += b;
		assertBIEqualsBI(expected, am);
		am = a;
		am += bm;
		assertBIEqualsBI(expected, am);

		// subtraction
		assertBIEqualsBI(a, expected - b);
		assertBIEqualsBI(a, expected - bm);
		assertBIEqualsBI(a, em - b);
		assertBIEqualsBI(a, em - bm);
		em = expected;
		em -= b;
		assertBIEqualsBI(a, em);
		em = expected;
		em -= bm;
		assertBIEqualsBI(a, em);
	}

	public function testNegate() : Void
	{
		assertBIEqualsInt(0, -FunBigInt.fromInt(0));
		assertBIEqualsInt(-1, -FunBigInt.fromInt(1));
		assertBIEqualsInt(1, -FunBigInt.fromInt(-1));
		assertBIEqualsInt(-100, -FunBigInt.fromInt(100));
		assertBIEqualsInt(100, -FunBigInt.fromInt(-100));
		assertBIEqualsBI(FunBigInt.fromHex("080000000"), -FunBigInt.fromInt(-2147483648));
		assertBIEqualsBI(FunBigInt.fromInt(-2147483648), -FunBigInt.fromHex("080000000"));
		assertBIEqualsBI(FunBigInt.fromHex("08000000000000000"), -FunBigInt.fromHex("8000000000000000"));
		assertBIEqualsBI(FunBigInt.fromHex("8000000000000000"), -FunBigInt.fromHex("08000000000000000"));
		assertBIEqualsBI(FunBigInt.fromHex("edcba98800000000"), -FunBigInt.fromHex("1234567800000000"));
	}

	public function testFromString() : Void
	{
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			var x = FunBigInt.fromString(null);
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			var x = FunBigInt.fromString("");
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			var x = FunBigInt.fromString("-");
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			var x = FunBigInt.fromString(" 0");
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			var x = FunBigInt.fromString("0 ");
		});
		assertBIEqualsInt(0, FunBigInt.fromString("0"));
		assertBIEqualsInt(1, FunBigInt.fromString("1"));
		assertBIEqualsInt(-1, FunBigInt.fromString("-1"));
		assertBIEqualsInt(100, FunBigInt.fromString("100"));
		assertBIEqualsInt(-100, FunBigInt.fromString("-100"));
		assertBIEqualsInt(2147483647, FunBigInt.fromString("2147483647"));
		assertBIEqualsInt(2147483647, FunBigInt.fromString("02147483647"));
		assertBIEqualsInt(-2147483648, FunBigInt.fromString("-2147483648"));
		assertBIEqualsInt(-2147483648, FunBigInt.fromString("-02147483648"));
		assertBIEqualsBI(FunBigInt.fromHex("080000000"), FunBigInt.fromString("2147483648"));
		assertBIEqualsBI(FunBigInt.fromHex("f7fffffff"), FunBigInt.fromString("-2147483649"));

		var a : FunMutableBigInt = 1;
		for (i in 0 ... 96)
		{
			assertBIEqualsBI( a, FunBigInt.fromString(s_powersOfTwo[i]));
			assertBIEqualsBI(-a, FunBigInt.fromString("-" + s_powersOfTwo[i]));
			a <<= 1;
		}
	}

	public function testArithmeticShiftLeftAssignDoesntClobber() : Void
	{
		var a : FunBigInt = FunBigInt.fromInt(1);
		var b : FunMutableBigInt = a;
		b <<= 1;
		assertBIEqualsInt(1, a);
		assertBIEqualsInt(2, b);
	}

	public function testArithmeticShiftRightAssignDoesntClobber() : Void
	{
		var a : FunBigInt = FunBigInt.fromInt(2);
		var b : FunMutableBigInt = a;
		b >>= 1;
		assertBIEqualsInt(2, a);
		assertBIEqualsInt(1, b);
	}

	public function testArithmeticShiftLeft() : Void
	{
		asl(FunBigInt.ZERO, 0, FunBigInt.ZERO);
		asl(FunBigInt.ZERO, 1, FunBigInt.ZERO);
		asl(FunBigInt.ZERO, 128, FunBigInt.ZERO);
		asl(FunBigInt.ZERO, 2147483647, FunBigInt.ZERO);

		var a : FunMutableBigInt = FunBigInt.ZERO;
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			a <<= -1;
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			a << -1;
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunBigInt.ONE << -1;
		});

		asl(FunBigInt.ONE, 1, FunBigInt.fromInt(2));
		asl(FunBigInt.ONE, 31, FunBigInt.fromHex("080000000"));
		asl(FunBigInt.fromHex("080000000"), 1, FunBigInt.fromHex("100000000"));

		var sb = new StringBuf();
		sb.add("1");
		for (i in 0 ... 100)
		{
			asl(FunBigInt.ONE, i * 4, FunBigInt.fromHex(sb.toString()));
			sb.add("0");
		}
		sb = new StringBuf();
		sb.add("08");
		for (i in 0 ... 100)
		{
			asl(FunBigInt.ONE, i * 4 + 3, FunBigInt.fromHex(sb.toString()));
			sb.add("0");
		}

		asl(FunBigInt.fromHex("08000000180000000"), 15, FunBigInt.fromHex("40000000c00000000000"));
	}
	private function asl(a : FunBigInt, b : Int, expected : FunBigInt) : Void
	{
		var result : FunMutableBigInt = 0;
		FunBigIntArithmetic.arithmeticShiftLeft(result, a, b);
		assertEqualsBI(expected, result);
		assertEqualsBI(expected, a << b);
		result = a;
		result <<= b;
		assertEqualsBI(expected, result);

		FunBigIntArithmetic.arithmeticShiftRight(result, expected, b);
		assertEqualsBI(a, result);
		assertEqualsBI(a, expected >> b);
		result = expected;
		result >>= b;
		assertEqualsBI(a, result);
	}

	public function testIsZero() : Void
	{
		assertEquals(true, FunBigInt.ZERO.isZero());
		assertEquals(false, FunBigInt.ONE.isZero());
		assertEquals(false, FunBigInt.NEGATIVE_ONE.isZero());
	}

	public function testSign() : Void
	{
		assertEquals(0, FunBigInt.ZERO.sign());
		assertEquals(0, FunBigInt.ONE.sign());
		assertEquals(-1, FunBigInt.NEGATIVE_ONE.sign());
		assertEquals(0, FunBigInt.fromInt(2147483647).sign());
		assertEquals(-1, FunBigInt.fromInt(-2147483648).sign());
	}

	public function testSetFromIntWithLargeLength() : Void
	{
		var x : FunMutableBigInt = FunBigInt.fromHex("1 00000000");
		x <<= 1;	// make it owned
		var y : FunMutableBigInt_ = x;
		y.setFromInt(11);
		assertEquals("11", y.toString());
	}

	public function testHexStrings() : Void
	{
		assertEquals("00000000", FunBigInt.ZERO.toHex());
		assertEquals("00000001", FunBigInt.ONE.toHex());
		assertEquals("ffffffff", FunBigInt.NEGATIVE_ONE.toHex());

		assertBIEqualsInt(0, FunBigInt.fromHex("0"));
		assertBIEqualsInt(1, FunBigInt.fromHex("1"));
		assertBIEqualsInt(-1, FunBigInt.fromHex("f"));

		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			var x = FunBigInt.fromHex(null);
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			var x = FunBigInt.fromHex("");
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			var x = FunBigInt.fromHex("0q0");
		});

		var sb = new StringBuf();
		var v = 1;
		for (i in 0 ... 32)
		{
			for (j in 0 ... 8)
			{
				var c : Int = (v < 10) ? (v + 48) : (v - 10 + 65);
				v = (v + 1) & 0x0f;
				sb.addChar(c);
			}
			checkHexString(sb.toString());
		}

		assertBIEqualsInt( 2147483647, FunBigInt.fromHex("07fffffff"));
		assertBIEqualsInt(-2147483648, FunBigInt.fromHex("f80000000"));

		assertBIEqualsInt(-2147483648, FunBigInt.fromHex("8000 0000"));

		assertEqualsBI(FunBigInt.fromHexSigned("080000000"), FunBigInt.fromHexUnsigned("80000000"));
		assertEqualsBI(FunBigInt.fromHexSigned("0ffffffff"), FunBigInt.fromHexUnsigned("ffffffff"));
		assertEqualsBI(FunBigInt.fromHexSigned("0f80000000"), FunBigInt.fromHexUnsigned("f80000000"));
	}
	private function checkHexString(value : String) : Void
	{
		var bi = FunBigInt.fromHex(value);
		assertEquals(value.toLowerCase(), bi.toHex().toLowerCase());
		var by = bi.toBytes();
		assertEquals(by.toHex().toLowerCase(), bi.toHex().toLowerCase());
	}

	public function testDecimalStrings() : Void
	{
		assertEquals("0", FunBigInt.ZERO.toString());
		checkDecString("1");
		checkDecString("99");
		checkDecString("2147483647");
		checkDecString("2147483648");
		checkDecString("2147483649");
		checkDecString("4294967295");
		checkDecString("4294967296");
		checkDecString("4294967297");
		for (i in 0 ... s_powersOfTwo.length)
		{
			var s = s_powersOfTwo[i];
			checkDecString(s);
			checkDecString("9" + s);
			checkDecString(s + "9");
			checkDecString("9" + s + "9");
		}
		var s = "1";
		for (i in 0 ... 100)
		{
			s = s + "0";
			checkDecString(s);
		}
		assertEquals("1512366075204170929049582354406559215", FunBigInt.fromHex("01234567 89abcdef 01234567 89abcdef").toString());
	}
	private function checkDecString(value : String) : Void
	{
		var biPos = FunBigInt.fromString(value);
		assertEquals(value, biPos.toString());
		value = "-" + value;
		var biNeg = FunBigInt.fromString(value);
		assertEquals(value, biNeg.toString());
	}

	private static var s_powersOfTwo = [
		"1",
		"2",
		"4",
		"8",
		"16",
		"32",
		"64",
		"128",
		"256",
		"512",
		"1024",
		"2048",
		"4096",
		"8192",
		"16384",
		"32768",
		"65536",
		"131072",
		"262144",
		"524288",
		"1048576",
		"2097152",
		"4194304",
		"8388608",
		"16777216",
		"33554432",
		"67108864",
		"134217728",
		"268435456",
		"536870912",
		"1073741824",
		"2147483648",
		"4294967296",
		"8589934592",
		"17179869184",
		"34359738368",
		"68719476736",
		"137438953472",
		"274877906944",
		"549755813888",
		"1099511627776",
		"2199023255552",
		"4398046511104",
		"8796093022208",
		"17592186044416",
		"35184372088832",
		"70368744177664",
		"140737488355328",
		"281474976710656",
		"562949953421312",
		"1125899906842624",
		"2251799813685248",
		"4503599627370496",
		"9007199254740992",
		"18014398509481984",
		"36028797018963968",
		"72057594037927936",
		"144115188075855872",
		"288230376151711744",
		"576460752303423488",
		"1152921504606846976",
		"2305843009213693952",
		"4611686018427387904",
		"9223372036854775808",
		"18446744073709551616",
		"36893488147419103232",
		"73786976294838206464",
		"147573952589676412928",
		"295147905179352825856",
		"590295810358705651712",
		"1180591620717411303424",
		"2361183241434822606848",
		"4722366482869645213696",
		"9444732965739290427392",
		"18889465931478580854784",
		"37778931862957161709568",
		"75557863725914323419136",
		"151115727451828646838272",
		"302231454903657293676544",
		"604462909807314587353088",
		"1208925819614629174706176",
		"2417851639229258349412352",
		"4835703278458516698824704",
		"9671406556917033397649408",
		"19342813113834066795298816",
		"38685626227668133590597632",
		"77371252455336267181195264",
		"154742504910672534362390528",
		"309485009821345068724781056",
		"618970019642690137449562112",
		"1237940039285380274899124224",
		"2475880078570760549798248448",
		"4951760157141521099596496896",
		"9903520314283042199192993792",
		"19807040628566084398385987584",
		"39614081257132168796771975168",
		/* 2^128 */	"340282366920938463463374607431768211456",
		/* 2^256 */	"115792089237316195423570985008687907853269984665640564039457584007913129639936",
		/* 2^512 */	"13407807929942597099574024998205846127479365820592393377723561443721764030073546976801874298166903427690031858186486050853753882811946569946433649006084096",
	];
}

class FunBigInt_Test1 extends FunBigInt_Test
{
	public override function setup() : Void
	{
		FunMutableBigInt_.s_testAllocation = false;
	}
	public function new() : Void
	{
		super();
	}
}

class FunBigInt_Test2 extends FunBigInt_Test
{
	public override function setup() : Void
	{
		FunMutableBigInt_.s_testAllocation = true;
		FunMutableBigInt_.s_debugAllocationPadding = 0;
	}
	public function new() : Void
	{
		super();
	}
}

class FunBigInt_Test3 extends FunBigInt_Test
{
	public override function setup() : Void
	{
		FunMutableBigInt_.s_testAllocation = true;
		FunMutableBigInt_.s_debugAllocationPadding = 1;
	}
	public function new() : Void
	{
		super();
	}
}
