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

package com.fundoware.engine.unicode;

import com.fundoware.engine.exception.FunExceptions;

class FunUTF16
{
	public static function getCodePointString(string : String, offset : Int) : Int
	{
		if (offset >= string.length)
		{
			throw FunExceptions.FUN_INVALID_ARGUMENT;
		}
		var c1 : Int = string.charCodeAt(offset);
		if (c1 < 0xd800)
		{
			return c1;
		}
		else if (c1 < 0xdc00)
		{
			if (offset + 2 > string.length)
			{
				return -1;
			}
			var c2 = string.charCodeAt(offset + 1);
			if (c2 < 0xdc00)
			{
				return -1;
			}
			else if (c2 < 0xe000)
			{
				return (((c1 & 0x3ff) << 10) | (c2 & 0x3ff)) + 0x10000;
			}
			else
			{
				return -1;
			}
		}
		else if (c1 < 0xe000)
		{
			return -1;
		}
		else
		{
			return c1;
		}
	}

	public static function getCodePointSize(codePoint : Int) : Int
	{
		if (codePoint < 0)
		{
			return -1;
		}
		else if (codePoint < 0x10000)
		{
			return 1;
		}
		else if (codePoint < 0x110000)
		{
			return 2;
		}
		else
		{
			return -1;
		}
	}

	public static function stringFromCodePoints(input : Array<Int>) : String
	{
		var sb = new StringBuf();
		for (i in 0 ... input.length)
		{
			var cp = input[i];
			appendCodePointToStringBuf(sb, cp);
		}
		return sb.toString();
	}

	public static function appendCodePointToStringBuf(sb : StringBuf, cp : Int) : Void
	{
		if (cp < 0)
		{
			sb.addChar(FunUnicode.kReplacement);
		}
		else if (cp < 0xd800)
		{
			sb.addChar(cp);
		}
		else if (cp < 0xe000)
		{
			sb.addChar(FunUnicode.kReplacement);
		}
		else if (cp < 0x10000)
		{
			sb.addChar(cp);
		}
		else if (cp < 0x110000)
		{
			cp -= 0x10000;
			sb.addChar(((cp >> 10) & 0x3ff) | 0xd800);
			sb.addChar(((cp >>  0) & 0x3ff) | 0xdc00);
		}
		else
		{
			sb.addChar(FunUnicode.kReplacement);
		}
	}
}
