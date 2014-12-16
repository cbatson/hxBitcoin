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
import com.fundoware.engine.core.FunIClearable;
import com.fundoware.engine.modular.FunIModularField;
import com.fundoware.engine.modular.FunIModularInt;

interface FunIEllipticCurve extends FunIClearable
{
	function get_G() : FunIEllipticCurvePoint;

	function get_order() : FunBigInt;

	/**
		Get the field over which this curve is defined.
	**/
	function getField() : FunIModularField;

	function newPoint(x : Dynamic, y : Dynamic) : FunIEllipticCurvePoint;

	function newCopy(input : FunIEllipticCurvePoint) : FunIEllipticCurvePoint;

	function newInfinity() : FunIEllipticCurvePoint;

	function isInfinity(point : FunIEllipticCurvePoint) : Bool;

	/**
		Perform a point addition operation on this curve.

		`result` may be the same object as `operand1` or `operand2`.
	**/
	function pointAdd(result : FunIEllipticCurvePoint, operand1 : FunIEllipticCurvePoint, operand2 : FunIEllipticCurvePoint) : Void;

	/**
		Perform a point doubling operation on this curve.

		`result` and `operand` may be the same object.
	**/
	function pointDouble(result : FunIEllipticCurvePoint, operand : FunIEllipticCurvePoint) : Void;

	function pointMultiply(result : FunIEllipticCurvePoint, operand1 : FunIEllipticCurvePoint, operand2 : Dynamic) : Void;
}
