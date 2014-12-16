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

class FunBigIntTools
{
	public static inline function isNull(value : FunBigInt) : Bool
	{
		var a : FunBigInt_ = value;
		return a == null;
	}

	public static inline function isBigInt(value : Dynamic) : Bool
	{
		return Std.is(value, FunBigInt_);
	}

	public static inline function castFrom(value : Dynamic) : FunBigInt
	{
		return new FunBigInt(Std.instance(value, FunBigInt_));
	}

	public static function parseValueUnsigned(value : Dynamic) : FunBigInt
	{
		var bi : FunBigInt;
		if (Std.is(value, String))
		{
			bi = parseStringUnsigned(cast(value, String));
		}
		else if (isBigInt(value))
		{
			var t = new FunMutableBigInt_();
			t.copyFrom(castFrom(value));
			return new FunBigInt(t);
		}
		else if (Std.is(value, Int))
		{
			bi = FunBigInt.fromInt(cast(value, Int));
		}
		else
		{
			throw FunExceptions.FUN_INVALID_ARGUMENT;
		}
		return bi;
	}

	private static function parseStringUnsigned(value : String) : FunBigInt
	{
		var result = new FunMutableBigInt_();
		if (StringTools.startsWith(value, "0x"))
		{
			result.setFromHexUnsigned(value.substr(2));
		}
		else
		{
			result.setFromString(value);
		}
		var result2 : FunMutableBigInt = result;
		return result2;
	}
}
