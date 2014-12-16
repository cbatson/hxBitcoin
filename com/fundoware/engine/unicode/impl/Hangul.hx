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

package com.fundoware.engine.unicode.impl;

class Hangul
{
	private static inline var SBase : Int = 0xAC00;
	private static inline var LBase : Int = 0x1100;
	private static inline var VBase:  Int = 0x1161;
	private static inline var TBase : Int = 0x11A7;
	private static inline var LCount : Int = 19;
	private static inline var VCount : Int = 21;
	private static inline var TCount : Int = 28;
	private static inline var NCount : Int = VCount * TCount; // 588
	private static inline var SCount : Int = LCount * NCount; // 11172

	public static function decomposeHangul(string : Array<Int>, index : Int) : Int
	{
		var s = string[index];
		var SIndex = s - SBase;
		if ((SIndex < 0) || (SIndex >= SCount))
		{
			return 0;
		}
		var L : Int = LBase + Std.int(SIndex / NCount);
		var V : Int = VBase + Std.int((SIndex % NCount) / TCount);
		var T : Int = TBase + SIndex % TCount;
		string[index] = L;
		string.insert(index + 1, V);
		if (T != TBase)
		{
			string.insert(index + 2, T);
			return 3;
		}
		return 2;
	}

	public static function composeHangulPair(a : Int, b : Int) : Int
	{
		// 1. check to see if two current characters are L and V
		var LIndex = a - LBase;
		if ((0 <= LIndex) && (LIndex < LCount))
		{
			var VIndex = b - VBase;
			if ((0 <= VIndex) && (VIndex < VCount))
			{
				// make syllable of form LV
				return SBase + (LIndex * VCount + VIndex) * TCount;
			}
		}

		// 2. check to see if two current characters are LV and T
		var SIndex = a - SBase;
		if ((0 <= SIndex) && (SIndex < SCount) && ((SIndex % TCount) == 0))
		{
			var TIndex = b - TBase;
			if ((0 < TIndex) && (TIndex < TCount))
			{
				// make syllable of form LVT
				return a + TIndex;
			}
		}

		return -1;
	}
}
