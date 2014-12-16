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

package com.fundoware.engine.crypto.ec.impl;

import com.fundoware.engine.bigint.FunBigInt;
import com.fundoware.engine.bigint.FunBigIntArithmetic;
import com.fundoware.engine.bigint.FunBigIntTools;
import com.fundoware.engine.bigint.FunMultiwordArithmetic;
import com.fundoware.engine.crypto.ec.FunIEllipticCurve;
import com.fundoware.engine.crypto.ec.FunIEllipticCurvePoint;
import com.fundoware.engine.crypto.FunCryptoUtils;
import com.fundoware.engine.exception.FunExceptions;
import com.fundoware.engine.modular.FunIModularField;
import com.fundoware.engine.modular.FunIModularInt;
import com.fundoware.engine.modular.impl.FunPrimeField;
import haxe.ds.Vector;

class FunGeneralAffinePrimeCurve implements FunIEllipticCurve
{
	public function get_G() : FunIEllipticCurvePoint
	{
		return m_G;
	}

	public function get_order() : FunBigInt
	{
		return m_order;
	}

	public function getField() : FunIModularField
	{
		return m_field;
	}

	public function newPoint(x : Dynamic, y : Dynamic) : FunIEllipticCurvePoint
	{
		var pt = new FunGeneralAffinePrimePoint(this);
		pt.m_x = m_field.newInt(x);
		pt.m_y = m_field.newInt(y);
		return pt;
	}

	public function newCopy(input : FunIEllipticCurvePoint) : FunIEllipticCurvePoint
	{
		return _newCopy(_check(input));
	}

	private function _newCopy(input : FunGeneralAffinePrimePoint) : FunIEllipticCurvePoint
	{
		var pt = new FunGeneralAffinePrimePoint(this);
		pt.m_x = m_field.newInt(input.m_x);
		pt.m_y = m_field.newInt(input.m_y);
		return pt;
	}

	public function pointAdd(result : FunIEllipticCurvePoint, operand1 : FunIEllipticCurvePoint, operand2 : FunIEllipticCurvePoint) : Void
	{
		_pointAdd(_check(result), _check(operand1), _check(operand2));
	}

	private function _pointAdd(result : FunGeneralAffinePrimePoint, operand1 : FunGeneralAffinePrimePoint, operand2 : FunGeneralAffinePrimePoint) : Void
	{
		if (_isInfinity(operand1))
		{
			_copy(result, operand2);
		}
		else if (_isInfinity(operand2))
		{
			_copy(result, operand1);
		}
		else
		{
			m_field.subtract(m_work2, operand2.m_x, operand1.m_x);
			if (m_field.isZero(m_work2))
			{
				_getInfinity(result);
			}
			else
			{
				m_field.subtract(m_work1, operand2.m_y, operand1.m_y);
				m_field.divide(m_work3, m_work1, m_work2);
				m_field.square(m_work2, m_work3);
				m_field.subtract(m_work2, m_work2, operand1.m_x);
				m_field.subtract(m_work2, m_work2, operand2.m_x);
				m_field.subtract(m_work1, operand1.m_x, m_work2);
				m_field.multiply(m_work3, m_work3, m_work1);
				m_field.subtract(result.m_y, m_work3, operand1.m_y);
				m_field.copy(result.m_x, m_work2);
			}
		}
	}

	public function pointDouble(result : FunIEllipticCurvePoint, operand : FunIEllipticCurvePoint) : Void
	{
		_pointDouble(_check(result), _check(operand));
	}

	private function _pointDouble(result : FunGeneralAffinePrimePoint, operand : FunGeneralAffinePrimePoint) : Void
	{
		if (_isInfinity(operand))
		{
			_copy(result, operand);
		}
		else if (m_field.isZero(operand.m_y))
		{
			_getInfinity(result);
		}
		else
		{
			m_field.square(m_work1, operand.m_x);
			m_field.add(m_work2, m_work1, m_work1);
			m_field.add(m_work2, m_work2, m_work1);
			m_field.add(m_work2, m_work2, m_a);
			m_field.add(m_work3, operand.m_y, operand.m_y);
			m_field.divide(m_work1, m_work2, m_work3);	// work1 = lambda
			m_field.square(m_work3, m_work1);
			m_field.subtract(m_work3, m_work3, operand.m_x);
			m_field.subtract(m_work3, m_work3, operand.m_x);
			m_field.subtract(m_work2, operand.m_x, m_work3);
			m_field.multiply(m_work1, m_work1, m_work2);
			m_field.subtract(result.m_y, m_work1, operand.m_y);
			m_field.copy(result.m_x, m_work3);
		}
	}

	public function pointMultiply(result : FunIEllipticCurvePoint, operand1 : FunIEllipticCurvePoint, operand2 : Dynamic) : Void
	{
		var op2 = FunBigIntTools.parseValueUnsigned(operand2);
		_pointMultiply(_check(result), _check(operand1), op2);
	}

	private function _pointMultiply(result : FunGeneralAffinePrimePoint, operand1 : FunGeneralAffinePrimePoint, operand2 : FunBigInt) : Void
	{
		// Implements Algorithm 3.27 (p. 97) from "Guide to Elliptic Curve Cryptography"; Hankerson, Menezes, and Vanstone; 2004.

		if (operand2.isNegative())
		{
			throw FunExceptions.FUN_INVALID_ARGUMENT;
		}

		var numBits : Int = FunBigIntArithmetic.floorLog2(operand2);
		_getInfinity(result);
		while (--numBits >= 0)
		{
			_pointDouble(result, result);
			if (operand2.getBit(numBits) != 0)
			{
				_pointAdd(result, result, operand1);
			}
		}
	}

	public function newInfinity() : FunIEllipticCurvePoint
	{
		var pt = new FunGeneralAffinePrimePoint(this);
		pt.m_x = m_field.newInt(0);
		pt.m_y = m_field.newInt(0);
		return pt;
	}

	private function _getInfinity(result : FunGeneralAffinePrimePoint) : Void
	{
		m_field.setZero(result.m_x);
		m_field.setZero(result.m_y);
	}

	public function isInfinity(point : FunIEllipticCurvePoint) : Bool
	{
		return _isInfinity(_check(point));
	}

	private function _isInfinity(point : FunGeneralAffinePrimePoint) : Bool
	{
		return m_field.isZero(point.m_x) && m_field.isZero(point.m_y);
	}

	private function _copy(result : FunGeneralAffinePrimePoint, from : FunGeneralAffinePrimePoint) : Void
	{
		if (result != from)
		{
			m_field.copy(result.m_x, from.m_x);
			m_field.copy(result.m_y, from.m_y);
		}
	}

	public function clear() : Void
	{
		m_work1.clear();
		m_work2.clear();
		m_work3.clear();
		FunCryptoUtils.clearVectorInt(m_buf);
	}

	public function new(field : FunPrimeField, a : Dynamic, b : Dynamic, Gx : Dynamic, Gy : Dynamic, order : Dynamic)
	{
		m_field = field;
		m_a = m_field.newInt(a);
		m_b = m_field.newInt(b);
		m_G = cast newPoint(Gx, Gy);
		m_order = FunBigIntTools.parseValueUnsigned(order);
		m_work1 = m_field.newInt();
		m_work2 = m_field.newInt();
		m_work3 = m_field.newInt();
		m_buf = new Vector<Int>(m_a.toInts(null));
	}

	private inline function _check(p : FunIEllipticCurvePoint) : FunGeneralAffinePrimePoint
	{
		if (p.getCurve() != this)
		{
			throw FunExceptions.FUN_INVALID_ARGUMENT;
		}
		return cast p;
	}

	private var m_field : FunIModularField;
	private var m_a : FunIModularInt;
	private var m_b : FunIModularInt;
	private var m_G : FunGeneralAffinePrimePoint;
	private var m_order : FunBigInt;

	private var m_work1 : FunIModularInt;
	private var m_work2 : FunIModularInt;
	private var m_work3 : FunIModularInt;

	private var m_buf : Vector<Int>;
}
