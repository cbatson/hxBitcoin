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

package com.fundoware.engine.crypto.ec;

import com.fundoware.engine.bigint.FunBigInt;
import com.fundoware.engine.exception.FunExceptions;

class FunEC_Test extends FunECTestCase
{
	public function testPointMultiply() : Void
	{
		var curve = FunEllipticCurves.newGeneralPrimeInt(29, 4, 20);
		var p = curve.newPoint(1, 5);
		checkPointMultiplyInt(curve.newInfinity(), p,  0);
		checkPointMultiplyInt(curve.newPoint( 1,  5), p,  1);
		checkPointMultiplyInt(curve.newPoint( 4, 19), p,  2);
		checkPointMultiplyInt(curve.newPoint(20,  3), p,  3);
		checkPointMultiplyInt(curve.newPoint(15, 27), p,  4);
		checkPointMultiplyInt(curve.newPoint( 6, 12), p,  5);
		checkPointMultiplyInt(curve.newPoint(17, 19), p,  6);
		checkPointMultiplyInt(curve.newPoint(24, 22), p,  7);
		checkPointMultiplyInt(curve.newPoint( 8, 10), p,  8);
		checkPointMultiplyInt(curve.newPoint(14, 23), p,  9);
		checkPointMultiplyInt(curve.newPoint(13, 23), p, 10);
		checkPointMultiplyInt(curve.newPoint(10, 25), p, 11);
		checkPointMultiplyInt(curve.newPoint(19, 13), p, 12);
		checkPointMultiplyInt(curve.newPoint(16, 27), p, 13);
		checkPointMultiplyInt(curve.newPoint( 5, 22), p, 14);
		checkPointMultiplyInt(curve.newPoint( 3,  1), p, 15);
		checkPointMultiplyInt(curve.newPoint( 0, 22), p, 16);
		checkPointMultiplyInt(curve.newPoint(27,  2), p, 17);
		checkPointMultiplyInt(curve.newPoint( 2, 23), p, 18);
		checkPointMultiplyInt(curve.newPoint( 2,  6), p, 19);
		checkPointMultiplyInt(curve.newPoint(27, 27), p, 20);
		checkPointMultiplyInt(curve.newPoint( 0,  7), p, 21);
		checkPointMultiplyInt(curve.newPoint( 3, 28), p, 22);
		checkPointMultiplyInt(curve.newPoint( 5,  7), p, 23);
		checkPointMultiplyInt(curve.newPoint(16,  2), p, 24);
		checkPointMultiplyInt(curve.newPoint(19, 16), p, 25);
		checkPointMultiplyInt(curve.newPoint(10,  4), p, 26);
		checkPointMultiplyInt(curve.newPoint(13,  6), p, 27);
		checkPointMultiplyInt(curve.newPoint(14,  6), p, 28);
		checkPointMultiplyInt(curve.newPoint( 8, 19), p, 29);
		checkPointMultiplyInt(curve.newPoint(24,  7), p, 30);
		checkPointMultiplyInt(curve.newPoint(17, 10), p, 31);
		checkPointMultiplyInt(curve.newPoint( 6, 17), p, 32);
		checkPointMultiplyInt(curve.newPoint(15,  2), p, 33);
		checkPointMultiplyInt(curve.newPoint(20, 26), p, 34);
		checkPointMultiplyInt(curve.newPoint( 4, 10), p, 35);
		checkPointMultiplyInt(curve.newPoint( 1, 24), p, 36);

		checkPointMultiplyInt(curve.newInfinity(), curve.newInfinity(), 1);

		// Check negative multiplicand
		var result = curve.newPoint(0, 0);
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			curve.pointMultiply(result, p, -1);
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			curve.pointMultiply(result, p, FunBigInt.fromInt(-1));
		});
	}
	private function checkPointMultiplyInt(expected : FunIEllipticCurvePoint, p : FunIEllipticCurvePoint, n : Int) : Void
	{
		checkPointMultiply(expected, p, n);
	}

	public function testPointDoubleP192() : Void
	{
		var curve = new com.fundoware.engine.crypto.ec.nist.FunNistP192Curve();

		var p = curve.newPoint("602046282375688656758213480587526111916698976636884684818", "174050332293622031404857552280219410364023488927386650641");
		var twoP = curve.newPoint("5369744403678710563432458361254544170966096384586764429448", "5429234379789071039750654906915254128254326554272718558123");
		var fourP = curve.newPoint("1305994880430903997305943738697779408316929565234787837114", "3981863977451150342116987835776121688410789618551673306674");

		var result = curve.newCopy(p);
		curve.pointDouble(result, result);
		assertEqualsPoint(twoP, result);
		curve.pointDouble(result, result);
		assertEqualsPoint(fourP, result);

		result = curve.newCopy(p);
		curve.pointDouble(result, result);
		assertEqualsPoint(twoP, result);
		curve.pointDouble(result, result);
		assertEqualsPoint(fourP, result);
	}

	public function testPointDouble() : Void
	{
		var curve = FunEllipticCurves.newGeneralPrimeInt(29, 4, 20);
		checkPointDouble(curve.newPoint(14, 6), curve.newPoint(5, 22));

		// Check when result overlaps operand
		var p = curve.newPoint(5, 22);
		curve.pointDouble(p, p);
		assertEqualsPoint(curve.newPoint(14, 6), p);

		// Check double of infinity
		p = curve.newInfinity();
		curve.pointDouble(p, p);
		assertTrue(curve.isInfinity(p));

		// Check double of point with y = 0
		var p = curve.newPoint(5, 0);
		curve.pointDouble(p, p);
		assertTrue(curve.isInfinity(p));
	}
	private function checkPointDouble(expected : FunIEllipticCurvePoint, input : FunIEllipticCurvePoint) : Void
	{
		var curve = expected.getCurve();
		var result = curve.newPoint(0, 0);
		curve.pointDouble(result, input);
		assertEqualsPoint(expected, result);
	}

	public function testPointAdd() : Void
	{
		var curve = FunEllipticCurves.newGeneralPrimeInt(29, 4, 20);
		var p1 = curve.newPoint(5, 22);
		var p2 = curve.newPoint(16, 27);
		var result = curve.newPoint(0, 0);
		curve.pointAdd(result, p1, p2);
		assertEqualsPoint(curve.newPoint(13, 6), result);

		// Check add with negative
		p1 = curve.newPoint(5, 22);
		p2 = curve.newPoint(5, -22);
		curve.pointAdd(result, p1, p2);
		assertTrue(curve.isInfinity(result));

		// Check overlap case 1
		p1 = curve.newPoint(5, 22);
		p2 = curve.newPoint(16, 27);
		curve.pointAdd(p1, p1, p2);
		assertEqualsPoint(curve.newPoint(13, 6), p1);

		// Check overlap case 2
		p1 = curve.newPoint(5, 22);
		p2 = curve.newPoint(16, 27);
		curve.pointAdd(p2, p1, p2);
		assertEqualsPoint(curve.newPoint(13, 6), p2);

		// Check add with infinity case 1
		p1 = curve.newInfinity();
		p2 = curve.newPoint(16, 27);
		curve.pointAdd(result, p1, p2);
		assertEqualsPoint(p2, result);

		// Check add with infinity case 2
		p1 = curve.newPoint(5, 22);
		p2 = curve.newInfinity();
		curve.pointAdd(result, p1, p2);
		assertEqualsPoint(p1, result);
	}
}
