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

package com.fundoware.engine.modular.impl;

import com.fundoware.engine.bigint.FunBigInt;
import com.fundoware.engine.bigint.FunBigIntArithmetic;
import com.fundoware.engine.bigint.FunBigIntTools;
import com.fundoware.engine.bigint.FunMultiwordArithmetic;
import com.fundoware.engine.bigint.FunMutableBigInt;
import com.fundoware.engine.exception.FunExceptions;
import com.fundoware.engine.modular.FunIModularField;
import com.fundoware.engine.modular.FunIModularInt;
import com.fundoware.engine.modular.FunModularFields;
import haxe.ds.Vector;

class FunModularField implements FunIModularField
{
	public function divide(result : FunIModularInt, dividend : FunIModularInt, divisor : FunIModularInt) : Void
	{
		throw FunExceptions.FUN_INVALID_OPERATION;
	}

	public function square(result : FunIModularInt, operand : FunIModularInt) : Void
	{
		var o = _check(operand);
		_multiply(_check(result), o, o);
	}

	public function multiply(result : FunIModularInt, operand1 : FunIModularInt, operand2 : FunIModularInt) : Void
	{
		_multiply(_check(result), _check(operand1), _check(operand2));
	}

	private function _multiply(result : FunModularInt, operand1 : FunModularInt, operand2 : FunModularInt) : Void
	{
		_copy(m_work2, operand1);
		_setZero(m_work3);
		for (i in 0 ... m_numBits)
		{
			if (FunMultiwordArithmetic.getBitSigned(operand2.m_value, m_numWords, i) != 0)
			{
				_add(m_work3, m_work3, m_work2);
			}
			_add(m_work2, m_work2, m_work2);	// double
		}
		_copy(result, m_work3);
	}

	public function add(result : FunIModularInt, operand1 : FunIModularInt, operand2 : FunIModularInt) : Void
	{
		_add(_check(result), _check(operand1), _check(operand2));
	}

	private function _add(result : FunModularInt, operand1 : FunModularInt, operand2 : FunModularInt) : Void
	{
		// Implements Algorithm 2.7 (p. 31) from "Guide to Elliptic Curve Cryptography"; Hankerson, Menezes, and Vanstone; 2004.
		var c = FunMultiwordArithmetic.add(result.m_value, operand1.m_value, operand2.m_value, m_numWords);
		if ((c != 0) || (_compare(result, m_modulusMI) >= 0))
		{
			FunMultiwordArithmetic.subtract(result.m_value, result.m_value, m_modulusMI.m_value, m_numWords);
		}
	}

	public function subtract(result : FunIModularInt, operand1 : FunIModularInt, operand2 : FunIModularInt) : Void
	{
		_subtract(_check(result), _check(operand1), _check(operand2));
	}

	private function _subtract(result : FunModularInt, operand1 : FunModularInt, operand2 : FunModularInt) : Void
	{
		// Implements Algorithm 2.8 (p. 31) from "Guide to Elliptic Curve Cryptography"; Hankerson, Menezes, and Vanstone; 2004.
		var c = FunMultiwordArithmetic.subtract(result.m_value, operand1.m_value, operand2.m_value, m_numWords);
		if (c != 0)
		{
			FunMultiwordArithmetic.add(result.m_value, result.m_value, m_modulusMI.m_value, m_numWords);
		}
	}

	public function reduce(result : FunIModularInt, input : FunBigInt) : Void
	{
		_reduce(_check(result), input);
	}

	private function _reduce(result : FunModularInt, input : FunBigInt) : Void
	{
		FunBigIntArithmetic.divide(input, m_modulusBI, m_quotient, m_remainder, m_work);
		if (m_remainder.isNegative())
		{
			FunBigIntArithmetic.add(m_remainder, m_remainder, m_modulusBI);
		}
		var num : Int = m_remainder.toInts(result.m_value);
		for (i in num ... m_numWords)
		{
			result.m_value.set(i, 0);
		}
	}

	public function compare(a : FunIModularInt, b : FunIModularInt) : Int
	{
		return _compare(_check(a), _check(b));
	}

	private inline function _compare(a : FunModularInt, b : FunModularInt) : Int
	{
		return FunMultiwordArithmetic.compareUnsigned(a.m_value, b.m_value, m_numWords);
	}

	public function getModulus() : FunBigInt
	{
		return m_modulusBI;
	}

	public function newInt(value : Dynamic = null) : FunIModularInt
	{
		return _newInt(value, true);
	}

	private function _newInt(value : Dynamic, doReduce : Bool) : FunModularInt
	{
		var result = new FunModularInt(this, m_numWords);
		if (value != null)
		{
			_setInt(result, value, doReduce);
		}
		return result;
	}

	public function copy(result : FunIModularInt, from : FunIModularInt) : Void
	{
		_copy(_check(result), _check(from));
	}

	private inline function _copy(result : FunModularInt, from : FunModularInt) : Void
	{
		if (result != from)
		{
			Vector.blit(from.m_value, 0, result.m_value, 0, m_numWords);
		}
	}

	public function setZero(result : FunIModularInt) : Void
	{
		_setZero(_check(result));
	}

	private function _setZero(result : FunModularInt) : Void
	{
		for (i in 0 ... m_numWords)
		{
			result.m_value.set(i, 0);
		}
	}

	public function isZero(input : FunIModularInt) : Bool
	{
		return _isZero(_check(input));
	}

	private function _isZero(input : FunModularInt) : Bool
	{
		for (i in 0 ... m_numWords)
		{
			if (input.m_value.get(i) != 0)
			{
				return false;
			}
		}
		return true;
	}

	public function setInt(result : FunIModularInt, value : Dynamic) : Void
	{
		_setInt(_check(result), value, true);
	}

	private function _setInt(result : FunModularInt, value : Dynamic, doReduce : Bool) : Void
	{
		if (value == null)
		{
			throw FunExceptions.FUN_NULL_ARGUMENT;
		}
		var bi : FunBigInt;
		if (Std.is(value, FunIModularInt))
		{
			var mi : FunIModularInt = cast value;
			if (mi.getField() == this)
			{
				_copy(result, cast mi);
				return;
			}
			// TODO: Allow modular ints from other fields?
			throw FunExceptions.FUN_INVALID_ARGUMENT;
		}
		else
		{
			bi = FunBigIntTools.parseValueUnsigned(value);
		}
		if (doReduce)
		{
			reduce(result, bi);
		}
		else
		{
			bi.toInts(result.m_value);
		}
	}

	private function new(modulus : Dynamic) : Void
	{
		m_modulusBI = FunBigIntTools.parseValueUnsigned(modulus);
		if (m_modulusBI < 2)
		{
			throw FunExceptions.FUN_INVALID_ARGUMENT;
		}

		m_quotient = 0;
		m_remainder = 0;
		m_work = 0;

		m_numBits = FunBigIntArithmetic.floorLog2(m_modulusBI - 1);
		m_numWords = (m_numBits + 31) >> 5;
		m_modulusMI = _newInt(m_modulusBI, false);

		m_work2 = _newInt(null, false);
		m_work3 = _newInt(null, false);
	}

	private inline function _check(value : FunIModularInt) : FunModularInt
	{
		if (value.getField() != this)
		{
			throw FunExceptions.FUN_INVALID_ARGUMENT;
		}
		return cast value;
	}

	private var m_numWords : Int;
	private var m_numBits : Int;
	private var m_modulusBI : FunBigInt;
	private var m_modulusMI : FunModularInt;

	private var m_quotient : FunMutableBigInt;
	private var m_remainder : FunMutableBigInt;
	private var m_work : FunMutableBigInt;
	private var m_work2 : FunModularInt;
	private var m_work3 : FunModularInt;
}
