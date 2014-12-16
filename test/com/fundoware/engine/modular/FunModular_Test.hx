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

package com.fundoware.engine.modular;

import com.fundoware.engine.bigint.FunBigInt;
import com.fundoware.engine.exception.FunExceptions;
import com.fundoware.engine.test.FunTestCase;
import haxe.PosInfos;

class FunModular_Test extends FunTestCase
{
	public function testBigDivide() : Void
	{
		m_field = newField("6277101735386680763835789423207666416083908700390324961279");

		var a1 = m_field.newInt("3861615048567063030691355956960560842237002122943048358239");
		var b1 = m_field.newInt("348100664587244062809715104560438820728046977854773301282");
		var q1 = m_field.newInt("442996917288222317913198944605928971379981873759372028722");

		var a2 = m_field.newInt("1335680743302409606460751157530926294178411748390233073016");
		var b2 = m_field.newInt("4581367024191461315665520390622841840424744408155112154967");
		var q2 = m_field.newInt("4333624757194722362394144531760267785726910312793230723770");

		var result = m_field.newInt();
		m_field.divide(result, a1, b1);
		assertEqualsMI(q1, result);
		m_field.divide(result, a2, b2);
		assertEqualsMI(q2, result);
		m_field.divide(result, a1, b1);
		assertEqualsMI(q1, result);
	}

	public function testNewFromModularInt() : Void
	{
		m_field = newField(23);
		var i1 = m_field.newInt(12);
		var i2 = m_field.newInt(i1);
		assertEqualsMI(i1, i2);
		assertFalse(i1 == i2);
	}

	public function testDivide() : Void
	{
		m_field = newField(23);

		checkDivide(m_field.newInt(0), m_field.newInt(0), m_field.newInt(1));

		checkDivide(m_field.newInt( 1), m_field.newInt(1), m_field.newInt( 1));
		checkDivide(m_field.newInt(12), m_field.newInt(1), m_field.newInt( 2));
		checkDivide(m_field.newInt( 8), m_field.newInt(1), m_field.newInt( 3));
		checkDivide(m_field.newInt( 6), m_field.newInt(1), m_field.newInt( 4));
		checkDivide(m_field.newInt(14), m_field.newInt(1), m_field.newInt( 5));
		checkDivide(m_field.newInt( 4), m_field.newInt(1), m_field.newInt( 6));
		checkDivide(m_field.newInt(10), m_field.newInt(1), m_field.newInt( 7));
		checkDivide(m_field.newInt( 3), m_field.newInt(1), m_field.newInt( 8));
		checkDivide(m_field.newInt(18), m_field.newInt(1), m_field.newInt( 9));
		checkDivide(m_field.newInt( 7), m_field.newInt(1), m_field.newInt(10));
		checkDivide(m_field.newInt(21), m_field.newInt(1), m_field.newInt(11));
		checkDivide(m_field.newInt( 2), m_field.newInt(1), m_field.newInt(12));
		checkDivide(m_field.newInt(16), m_field.newInt(1), m_field.newInt(13));
		checkDivide(m_field.newInt( 5), m_field.newInt(1), m_field.newInt(14));
		checkDivide(m_field.newInt(20), m_field.newInt(1), m_field.newInt(15));
		checkDivide(m_field.newInt(13), m_field.newInt(1), m_field.newInt(16));
		checkDivide(m_field.newInt(19), m_field.newInt(1), m_field.newInt(17));
		checkDivide(m_field.newInt( 9), m_field.newInt(1), m_field.newInt(18));
		checkDivide(m_field.newInt(17), m_field.newInt(1), m_field.newInt(19));
		checkDivide(m_field.newInt(15), m_field.newInt(1), m_field.newInt(20));
		checkDivide(m_field.newInt(11), m_field.newInt(1), m_field.newInt(21));
		checkDivide(m_field.newInt(22), m_field.newInt(1), m_field.newInt(22));

		checkDivide(m_field.newInt(13), m_field.newInt(3), m_field.newInt(2));

		// check division by zero
		assertThrowsString(FunExceptions.FUN_INVALID_OPERATION, function() : Void
		{
			checkDivide(m_field.newInt(0), m_field.newInt(0), m_field.newInt(0));
		});
		assertThrowsString(FunExceptions.FUN_INVALID_OPERATION, function() : Void
		{
			checkDivide(m_field.newInt(0), m_field.newInt(1), m_field.newInt(0));
		});

		m_field = newField("0xfffffffb");
		checkDivide(m_field.newInt(2147483646), m_field.newInt(1), m_field.newInt(2));
		checkDivide(m_field.newInt("0xaaaaaaa8"), m_field.newInt(1), m_field.newInt(2147483647));
		checkDivide(m_field.newInt("0xfffffffa"), m_field.newInt(1), m_field.newInt("0xfffffffa"));
		checkDivide(m_field.newInt(1), m_field.newInt("0xfffffffa"), m_field.newInt("0xfffffffa"));
	}
	private function checkDivide(expected : FunIModularInt, a : FunIModularInt, b : FunIModularInt) : Void
	{
		var one = m_field.newInt(1);

		var result = m_field.newInt();
		m_field.divide(result, a, b);
		assertEqualsMI(expected, result);

		if (m_field.compare(a, one) == 0)
		{
			m_field.divide(result, a, expected);
			assertEqualsMI(b, result);
		}

		m_field.divide(result, one, b);
		m_field.multiply(result, result, a);
		assertEqualsMI(expected, result);
	}

	public function testMultiply() : Void
	{
		m_field = newField(23);
		checkSquare(m_field.newInt( 0), m_field.newInt( 0));
		checkSquare(m_field.newInt( 1), m_field.newInt( 1));
		checkSquare(m_field.newInt( 4), m_field.newInt( 2));
		checkSquare(m_field.newInt( 9), m_field.newInt( 3));
		checkSquare(m_field.newInt(16), m_field.newInt( 4));
		checkSquare(m_field.newInt( 2), m_field.newInt( 5));
		checkSquare(m_field.newInt(13), m_field.newInt( 6));
		checkSquare(m_field.newInt( 3), m_field.newInt( 7));
		checkSquare(m_field.newInt(18), m_field.newInt( 8));
		checkSquare(m_field.newInt(12), m_field.newInt( 9));
		checkSquare(m_field.newInt( 8), m_field.newInt(10));
		checkSquare(m_field.newInt( 6), m_field.newInt(11));
		checkSquare(m_field.newInt( 6), m_field.newInt(12));
		checkSquare(m_field.newInt( 8), m_field.newInt(13));
		checkSquare(m_field.newInt(12), m_field.newInt(14));
		checkSquare(m_field.newInt(18), m_field.newInt(15));
		checkSquare(m_field.newInt( 3), m_field.newInt(16));
		checkSquare(m_field.newInt(13), m_field.newInt(17));
		checkSquare(m_field.newInt( 2), m_field.newInt(18));
		checkSquare(m_field.newInt(16), m_field.newInt(19));
		checkSquare(m_field.newInt( 9), m_field.newInt(20));
		checkSquare(m_field.newInt( 4), m_field.newInt(21));
		checkSquare(m_field.newInt( 1), m_field.newInt(22));
		checkMultiply(m_field.newInt(0), m_field.newInt(0), m_field.newInt(1));
		checkMultiply(m_field.newInt(1), m_field.newInt(12), m_field.newInt(2));
		checkMultiply(m_field.newInt(12), m_field.newInt(5), m_field.newInt(7));
	}
	private function checkSquare(expected : FunIModularInt, a : FunIModularInt) : Void
	{
		checkMultiply(expected, a, a);
	}
	private function checkMultiply(expected : FunIModularInt, a : FunIModularInt, b : FunIModularInt) : Void
	{
		checkMultiplySingle(expected, a, b);
		checkMultiplySingle(expected, b, a);
	}
	private function checkMultiplySingle(expected : FunIModularInt, a : FunIModularInt, b : FunIModularInt) : Void
	{
		var result = m_field.newInt();
		m_field.multiply(result, a, b);
		assertEqualsMI(expected, result);
	}

	public function testAdd() : Void
	{
		m_field = newField(5);
		checkAdd();
		m_field = newField(100);
		checkAdd();
		m_field = newField(FunBigInt.fromHex("1 00000000"));
		checkAdd();
		m_field = newField(FunBigInt.fromHex("1 00000001"));
		checkAdd();
		m_field = newField(FunBigInt.fromHex("1 ffffffff"));
		checkAdd();
		m_field = newField(FunBigInt.fromHex("2 00000000"));
		checkAdd();
		m_field = newField(FunBigInt.fromHex("2 00000001"));
		checkAdd();
	}
	private function checkAdd() : Void
	{
		var zero = m_field.newInt(0);
		var one = m_field.newInt(1);
		var mm1 = m_field.newInt(m_field.getModulus() - 1);
		var mo2 = m_field.newInt(m_field.getModulus() / 2);

		checkAddSingle(zero, zero, zero);
		checkAddSingle(one, one, zero);
		checkAddSingle(m_field.newInt(2), one, one);
		checkAddSingle(zero, mm1, one);
		checkAddSingle(mm1, mm1, zero);
		checkAddSingle(m_field.newInt(-2), mm1, mm1);

		var r : Int = m_field.getModulus() % 2;
		if (r != 0)
		{
			// odd
			checkAddSingle(mm1, mo2, mo2);
		}
		else
		{
			// even
			checkAddSingle(zero, mo2, mo2);
		}
	}
	private function checkAddSingle(expected : FunIModularInt, a : FunIModularInt, b : FunIModularInt) : Void
	{
		var result = m_field.newInt();
		m_field.add(result, a, b);
		assertEqualsMI(expected, result);
		m_field.add(result, b, a);
		assertEqualsMI(expected, result);

		m_field.subtract(result, expected, a);
		assertEqualsMI(b, result);
		m_field.subtract(result, expected, b);
		assertEqualsMI(a, result);
	}

	public function testCompareWrongField() : Void
	{
		var F5 = newField(5);
		var F7 = newField(7);
		var one5 = F5.newInt(1);
		var one7 = F7.newInt(1);
		assertEquals(0, F5.compare(one5, one5));
		assertEquals(0, F7.compare(one7, one7));
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			F5.compare(one5, one7);
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			F5.compare(one7, one5);
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			F7.compare(one5, one7);
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			F7.compare(one7, one5);
		});
	}

	public function testCompare() : Void
	{
		m_field = newField(5);
		checkCompareInt(0, 0, 0);
		checkCompareInt(0, 1, 1);
		checkCompareInt(-1, 0, 1);
		checkCompareInt(-1, 1, 2);

		m_field = newField("0x0fffffffb");
		checkCompare(-1, m_field.newInt(1), m_field.newInt("0x0fffffffa"));
	}
	private function checkCompareInt(expected : Int, a : Int, b : Int) : Void
	{
		checkCompare(expected, m_field.newInt(a), m_field.newInt(b));
	}
	private function checkCompare(expected : Int, a : FunIModularInt, b : FunIModularInt) : Void
	{
		checkCompareSingle( expected, a, b);
		checkCompareSingle(-expected, b, a);
	}
	private function checkCompareSingle(expected : Int, a : FunIModularInt, b : FunIModularInt) : Void
	{
		assertEquals(expected, m_field.compare(a, b));
	}

	public function testIntModulus() : Void
	{
		m_field = newField(5);
		assertEquals("5", m_field.getModulus().toString());
	}

	public function testInvalidModulus() : Void
	{
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			m_field = newField(-1);
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			m_field = newField(0);
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			m_field = newField(1);
		});
	}

	public function assertEqualsMI(expected : Dynamic, actual : Dynamic, ?c : PosInfos) : Void
	{
		if (Std.is(actual, FunIModularInt))
		{
			var mi = cast(actual, FunIModularInt);
			var ex : FunIModularInt = null;
			if (Std.is(expected, FunIModularInt))
			{
				ex = cast(expected, FunIModularInt);
			}
			else if (Std.is(expected, Int))
			{
				ex = m_field.newInt(expected);
			}
			assertEquals(ex.toString(), mi.toString());
			return;
		}
		throw "unhandled";
	}

	public function newField(modulus : Dynamic) : FunIModularField
	{
		return FunModularFields.newFieldOverPrime(modulus);
	}

	private var m_field : FunIModularField;
}
