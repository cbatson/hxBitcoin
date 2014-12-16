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

interface FunIModularField
{
	/**
		Returns the modulus for this field.
	**/
	function getModulus() : FunBigInt;

	/**
		Creates a new integer value in this field.

		Acceptable types for input `value` are `Int`,
		`FunBigInt`, `FunMutableBigInt`, `FunIModularInt`,
		and `null`.
	**/
	function newInt(value : Dynamic = null) : FunIModularInt;

	/**
		Sets the value of an integer in this field to zero.
	**/
	function setZero(result : FunIModularInt) : Void;

	/**
		Sets the value of an integer in this field.

		Acceptable types for input `value` are `Int`,
		`FunBigInt`, `FunMutableBigInt`, `FunIModularInt`,
		and `null`.
	**/
	function setInt(result : FunIModularInt, value : Dynamic) : Void;

	/**
		Copy the value from one integer in this field to another.
	**/
	function copy(result : FunIModularInt, from : FunIModularInt) : Void;

	/**
		Returns `true` if the integer from this field `input`
		represents a value of 0; `false` otherwise.
	**/
	function isZero(input : FunIModularInt) : Bool;

	/**
		Compare two values from this field.

		If `a < b` the result is -1.
		If `a == b` the result is 0.
		If `a > b` the result is 1.
	**/
	function compare(a : FunIModularInt, b : FunIModularInt) : Int;

	/**
		Add the field integers `operand1` and `operand2` and store
		the result in `result`.

		`result` may refer to the inputs `operand1` and/or
		`operand2`.

		`operand1` and `operand2` may refer to the same object.

		All arguments must be integers from this field.
	**/
	function add(result : FunIModularInt, operand1 : FunIModularInt, operand2 : FunIModularInt) : Void;

	/**
		Subtract the field integer `operand2` from `operand1` and
		store the result in `result`.

		`result` may refer to the inputs `operand1` and/or
		`operand2`.

		`operand1` and `operand2` may refer to the same object.

		All arguments must be integers from this field.
	**/
	function subtract(result : FunIModularInt, operand1 : FunIModularInt, operand2 : FunIModularInt) : Void;

	/**
		Square the field integer `operand` and store the result in
		`result`.

		`result` and `operand` may refer to the same object.

		All arguments must be integers from this field.
	**/
	function square(result : FunIModularInt, operand : FunIModularInt) : Void;

	/**
		Multiply the field integers `operand1` and `operand2` and
		store the result in `result`.

		`result` may refer to the inputs `operand1` and/or
		`operand2`.

		`operand1` and `operand2` may refer to the same object.

		All arguments must be integers from this field.
	**/
	function multiply(result : FunIModularInt, operand1 : FunIModularInt, operand2 : FunIModularInt) : Void;

	/**
		Divide the field integer `dividend` by `divisor` and
		store the result in `result`.

		That is to say, this function finds `result` such that
		`result` * `divisor` = `dividend` modulo M, where M
		is this field's modulus.

		In other words, `result` = `dividend` * `divisor`<sup>-1</sup>.

		`result` may refer to the inputs `dividend` and/or
		`divisor`.

		`dividend` and `divisor` may refer to the same object.

		All arguments must be integers from this field.
	**/
	function divide(result : FunIModularInt, dividend : FunIModularInt, divisor : FunIModularInt) : Void;

	/**
		Reduce an arbitrary integer `input` into this field.
	**/
	function reduce(result : FunIModularInt, input : FunBigInt) : Void;
}
