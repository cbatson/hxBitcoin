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
import haxe.io.Bytes;

class FunUTF8
{
	/**
		@return
			the unicode code point found at the given offset in the
			string; -1 otherwise.
	**/
	public static function getCodePointBytes(string : Bytes, offset : Int) : Int
	{
		if (offset >= string.length)
		{
			throw FunExceptions.FUN_INVALID_ARGUMENT;
		}
		var c2 : Int, c3 : Int, c4 : Int;
		var c1 : Int = string.get(offset);
		if (c1 < 0x80)
		{
			return c1;
		}
		else if (c1 < 0xC2)
		{
			// continuation or overlong 2-byte sequence
			return -1;
		}
		else if (c1 < 0xE0)
		{
			// 2-byte sequence
			if (offset + 2 > string.length)
			{
				// out of bounds
				return -1;
			}
			c2 = string.get(offset + 1);
			if ((c2 & 0xC0) != 0x80)
			{
				return -1;
			}
			return (c1 << 6) + c2 - 0x3080;
		}
		else if (c1 < 0xF0)
		{
			/* 3-byte sequence */
			if (offset + 3 > string.length)
			{
				// out of bounds
				return -1;
			}
			c2 = string.get(offset + 1);
			if ((c2 & 0xC0) != 0x80)
			{
				return -1;
			}
			if ((c1 == 0xE0) && (c2 < 0xA0))
			{
				// overlong
				return -1;
			}
			if ((c1 == 0xed) && (c2 >= 0xa0))
			{
				// UTF-16 surrogate
				return -1;
			}
			c3 = string.get(offset + 2);
			if ((c3 & 0xC0) != 0x80)
			{
				return -1;
			}
			return (c1 << 12) + (c2 << 6) + c3 - 0xE2080;
		}
		else if (c1 < 0xF5)
		{
			/* 4-byte sequence */
			if (offset + 4 > string.length)
			{
				// out of bounds
				return -1;
			}
			c2 = string.get(offset + 1);
			if ((c2 & 0xC0) != 0x80)
			{
				return -1;
			}
			if ((c1 == 0xF0) && (c2 < 0x90))
			{
				// overlong
				return -1;
			}
			if ((c1 == 0xF4) && (c2 >= 0x90))
			{
				// > U+10FFFF
				return -1;
			}
			c3 = string.get(offset + 2);
			if ((c3 & 0xC0) != 0x80)
			{
				return -1;
			}
			c4 = string.get(offset + 3);
			if ((c4 & 0xC0) != 0x80)
			{
				return -1;
			}
			return (c1 << 18) + (c2 << 12) + (c3 << 6) + c4 - 0x3C82080;
		}
		// > U+10FFFF
		return -1;
	}

	/**
		@return
			the unicode code point found at the given offset in the
			string; -1 otherwise.
	**/
	public static function getCodePointString(string : String, offset : Int) : Int
	{
		if (offset >= string.length)
		{
			throw FunExceptions.FUN_INVALID_ARGUMENT;
		}
		var c2 : Int, c3 : Int, c4 : Int;
		var c1 : Int = string.charCodeAt(offset);
		if (c1 < 0x80)
		{
			return c1;
		}
		else if (c1 < 0xC2)
		{
			// continuation or overlong 2-byte sequence
			return -1;
		}
		else if (c1 < 0xE0)
		{
			// 2-byte sequence
			if (offset + 2 > string.length)
			{
				// out of bounds
				return -1;
			}
			c2 = string.charCodeAt(offset + 1);
			if ((c2 & 0xC0) != 0x80)
			{
				return -1;
			}
			return (c1 << 6) + c2 - 0x3080;
		}
		else if (c1 < 0xF0)
		{
			/* 3-byte sequence */
			if (offset + 3 > string.length)
			{
				// out of bounds
				return -1;
			}
			c2 = string.charCodeAt(offset + 1);
			if ((c2 & 0xC0) != 0x80)
			{
				return -1;
			}
			if ((c1 == 0xE0) && (c2 < 0xA0))
			{
				// overlong
				return -1;
			}
			if ((c1 == 0xed) && (c2 >= 0xa0))
			{
				// UTF-16 surrogate
				return -1;
			}
			c3 = string.charCodeAt(offset + 2);
			if ((c3 & 0xC0) != 0x80)
			{
				return -1;
			}
			return (c1 << 12) + (c2 << 6) + c3 - 0xE2080;
		}
		else if (c1 < 0xF5)
		{
			/* 4-byte sequence */
			if (offset + 4 > string.length)
			{
				// out of bounds
				return -1;
			}
			c2 = string.charCodeAt(offset + 1);
			if ((c2 & 0xC0) != 0x80)
			{
				return -1;
			}
			if ((c1 == 0xF0) && (c2 < 0x90))
			{
				// overlong
				return -1;
			}
			if ((c1 == 0xF4) && (c2 >= 0x90))
			{
				// > U+10FFFF
				return -1;
			}
			c3 = string.charCodeAt(offset + 2);
			if ((c3 & 0xC0) != 0x80)
			{
				return -1;
			}
			c4 = string.charCodeAt(offset + 3);
			if ((c4 & 0xC0) != 0x80)
			{
				return -1;
			}
			return (c1 << 18) + (c2 << 12) + (c3 << 6) + c4 - 0x3C82080;
		}
		// > U+10FFFF
		return -1;
	}

	/**
		@return
			the size, in bytes, of the given unicode code point;
			otherwise -1 if it can't be encoded in UTF-8
	**/
	public static function getCodePointSize(codePoint : Int) : Int
	{
		if (codePoint < 0x80)
		{
			return 1;
		}
		else if (codePoint < 0x800)
		{
			return 2;
		}
		else if (codePoint < 0x10000)
		{
			return 3;
		}
		else if (codePoint < 0x110000)
		{
			return 4;
		}
		return -1;
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

	public static function stringFromBytes(input : Bytes) : String
	{
		var sb = new StringBuf();
		var i = 0;
		while (i < input.length)
		{
			var cp = getCodePointBytes(input, i);
			i += (cp < 0) ? 1 : getCodePointSize(cp);
			FunUnicode.kCharIs16Bits ? FunUTF16.appendCodePointToStringBuf(sb, cp) : appendCodePointToStringBuf(sb, cp);
		}
		return sb.toString();
	}

	public static function appendCodePointToStringBuf(sb : StringBuf, cp : Int) : Void
	{
		if ((cp < 0) || ((0xd800 <= cp) && (cp < 0xe000)) || (cp >= 0x110000))
		{
			cp = FunUnicode.kReplacement;
		}
		if (cp < 0x80)
		{
			sb.addChar(cp);
		}
		else if (cp < 0x800)
		{
			sb.addChar((cp >> 6) + 0xc0);
			sb.addChar((cp & 0x3f) + 0x80);
		}
		else if (cp < 0x10000)
		{
			sb.addChar((cp >> 12) + 0xe0);
			sb.addChar(((cp >> 6) & 0x3f) + 0x80);
			sb.addChar((cp & 0x3f) + 0x80);
		}
		else
		{
			sb.addChar((cp >> 18) + 0xf0);
			sb.addChar(((cp >> 12) & 0x3f) + 0x80);
			sb.addChar(((cp >> 6) & 0x3f) + 0x80);
			sb.addChar((cp & 0x3f) + 0x80);
		}
	}
}
