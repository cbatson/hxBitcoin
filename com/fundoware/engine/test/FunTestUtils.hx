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

package com.fundoware.engine.test;

import com.fundoware.engine.core.FunUtils;
import com.fundoware.engine.exception.FunExceptions;
import com.fundoware.engine.unicode.FunUnicode;
import haxe.io.Bytes;
using StringTools;

class FunTestUtils
{
	public static function Unstringify(s : String) : String
	{
		return s.replace("`", "\"");
	}

	public static function MakeBytes(value : Int, count : Int) : Bytes
	{
		var b = Bytes.alloc(count);
		b.fill(0, count, value);
		return b;
	}

	public static function stringFromUnicode(input : String) : String
	{
		var a = input.split(" ");
		var s = new Array<Int>();
		for (i in 0 ... a.length)
		{
			s.push(Std.parseInt("0x" + a[i]));
		}
		return FunUnicode.stringFromCodePoints(s);
	}

	public static function unicodeToCodePointsArray(input : String) : Array<Int>
	{
		var a = new Array<Int>();
		var i = 0;
		while (i < input.length)
		{
			var cp = FunUnicode.getCodePoint(input, i);
			if (cp < 0)
			{
				throw FunExceptions.FUN_INVALID_ARGUMENT;
			}
			a.push(cp);
			i += FunUnicode.getCodePointSize(cp);
		}
		return a;
	}

	public static function unicodeToCodePointsString(input : String) : String
	{
		var sb = new StringBuf();
		var i = 0;
		while (i < input.length)
		{
			var cp = FunUnicode.getCodePoint(input, i);
			if (cp < 0)
			{
				throw FunExceptions.FUN_INVALID_ARGUMENT;
			}
			if (i > 0)
			{
				sb.addChar(32);
			}
			sb.add(StringTools.hex(cp, 4));
			i += FunUnicode.getCodePointSize(cp);
		}
		return sb.toString();
	}
	
	public static function getNthVector(strVectors : String, n : Int) : String
	{
		var start : Int = 0;
		var end : Int;
		while (start < strVectors.length)
		{
			end = strVectors.indexOf("|", start);
			if (end < 0)
			{
				return (n == 0) ? StringTools.trim(strVectors.substr(start)) : null;
			}
			if (n == 0)
			{
				return StringTools.trim(strVectors.substring(start, end));
			}
			start = end + 1;
			--n;
		}
		return null;
	}
	
	public static function countVectors(strVectors : String) : Int
	{
		var start : Int = 0;
		var end : Int;
		var n : Int = 1;
		while (start < strVectors.length)
		{
			end = strVectors.indexOf("|", start);
			if (end < 0)
			{
				return n;
			}
			start = end + 1;
			++n;
		}
		return n;
	}
}
