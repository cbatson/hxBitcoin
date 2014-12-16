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

package com.fundoware.engine.core;

import com.fundoware.engine.exception.FunExceptions;
import haxe.io.Bytes;

class FunUtils
{
	public static function hexToBytes(str : String) : Bytes
	{
		if (str == null)
		{
			throw FunExceptions.FUN_NULL_ARGUMENT;
		}
		if ((str.length & 1) != 0)
		{
			throw FunExceptions.FUN_INVALID_ARGUMENT;
		}
		var len = str.length >> 1;
		var bytes = Bytes.alloc(len);
		for (i in 0 ... len)
		{
			bytes.set(i,
				(hexValue(str.charCodeAt(i << 1)) << 4) |
				hexValue(str.charCodeAt((i << 1) + 1))
			);
		}
		return bytes;
	}

	private static inline function hexValue(c : Int) : Int
	{
		if ((48 <= c) && (c <= 57))
		{
			return c - 48;
		}
		else if ((65 <= c) && (c <= 70))
		{
			return c - 55;
		}
		else if ((97 <= c) && (c <= 102))
		{
			return c - 87;
		}
		else
		{
			throw FunExceptions.FUN_INVALID_ARGUMENT;
		}
	}
}
