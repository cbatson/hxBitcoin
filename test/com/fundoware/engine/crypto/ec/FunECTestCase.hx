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

import com.fundoware.engine.test.FunTestCase;
import haxe.PosInfos;

class FunECTestCase extends FunTestCase
{
	private function checkPointMultiply(expected : FunIEllipticCurvePoint, p : FunIEllipticCurvePoint, n : Dynamic) : Void
	{
		var m_curve = expected.getCurve();
		var result = m_curve.newPoint(0, 0);
		m_curve.pointMultiply(result, p, n);
		if (m_curve.isInfinity(expected))
		{
			assertTrue(m_curve.isInfinity(result));
		}
		else
		{
			assertEqualsPoint(expected, result);
		}
	}

	public function assertEqualsPoint(expected : Dynamic, actual : Dynamic, ?c : PosInfos)
	{
		assertEquals(expected.toString(), actual.toString(), c);
	}

	public function new()
	{
		super();
	}
}
