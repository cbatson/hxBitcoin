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

@:allow(com.fundoware.engine.unicode)
class FunUnicode
{
	public static inline function getCodePoint(string : String, offset : Int) : Int
	{
		return kCharIs16Bits ? FunUTF16.getCodePointString(string, offset) : FunUTF8.getCodePointString(string, offset);
	}

	public static inline function getCodePointSize(codePoint : Int) : Int
	{
		return kCharIs16Bits ? FunUTF16.getCodePointSize(codePoint) : FunUTF8.getCodePointSize(codePoint);
	}

	public static inline function stringFromCodePoints(input : Array<Int>) : String
	{
		return kCharIs16Bits ? FunUTF16.stringFromCodePoints(input) : FunUTF8.stringFromCodePoints(input);
	}

	public static inline var kReplacement = 0xfffd;

	private static inline var kCharIs16Bits : Bool =
		#if flash
			true
		#elseif (neko || cpp)
			false
		#else
			"unknown"
		#end
		;
}
