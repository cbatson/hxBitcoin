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

import com.fundoware.engine.test.FunTestCase;
import haxe.PosInfos;
import haxe.ds.Vector;

class FunBigIntTestCase extends FunTestCase
{
	public function assertEqualsBI(expected : Dynamic, actual : Dynamic, length : Int = 0, ?c : PosInfos) : Void
	{
		if (Std.is(actual, FunBigInt_))
		{
			var e = Std.instance(expected, FunBigInt_);
			if (e == null)
			{
				if (Std.is(expected, Int))
				{
					e = FunBigInt.fromInt(cast(expected, Int));
				}
			}
			this.assertEquals(e.toHex(), cast(actual, FunBigInt_).toHex(), c);
			return;
		}
		if (isVector(actual))
		{
			var vActual : Vector<Int> = cast actual;
			var vExpected : Vector<Int> = null;
			if (Std.is(expected, Int))
			{
				vExpected = new Vector<Int>(vActual.length);
				FunMultiwordArithmetic.setFromIntUnsigned(vExpected, vExpected.length, cast(expected, Int));
			}
			else if (isVector(expected))
			{
				vExpected = cast expected;
			}
			this.assertEquals(FunMultiwordArithmetic.toHex(vExpected, (length != 0) ? length : vExpected.length), FunMultiwordArithmetic.toHex(vActual, (length != 0) ? length : vActual.length), c);
			return;
		}
		throw "unhandled";
	}
	private static inline function isVector(v : Dynamic) : Bool
	{
		// TODO
		//return Std.is(v, flash.Vector);
		return true;
	}

	public function assertBIEqualsInt(expected : Int, actual : FunBigInt, ?c : PosInfos) : Void
	{
		assertBIEqualsBI(FunBigInt.fromInt(expected), actual, c);
	}

	public function assertBIEqualsBI(expected : FunBigInt, actual : FunBigInt, ?c : PosInfos) : Void
	{
		this.assertEquals(expected.toHex(), actual.toHex(), c);
	}

	public function new()
	{
		super();
	}
}
