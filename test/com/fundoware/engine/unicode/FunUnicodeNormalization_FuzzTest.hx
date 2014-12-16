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

import com.fundoware.engine.random.FunRandom;
import com.fundoware.engine.test.FunTestUtils;

class FunUnicodeNormalization_FuzzTest extends FunUnicodeNormalizationTestCase
{
	public function _testCombos() : Void
	{
		var testVectors = FunUnicodeNormalization_TestVectors.s_testVectors_Part1;
		var a = testVectors.split("|");
		while (true)
		{
			var n1 = FunRandom.nextInt(0, a.length);
			var n2 = FunRandom.nextInt(0, a.length);
			var s1 = StringTools.trim(a[n1]);
			var s2 = StringTools.trim(a[n2]);
trace(">" + s1 + "+" + s2);
			var a1 = s1.split(",");
			var a2 = s2.split(",");
			var z1 = a1[0] + " " + a2[0];
			var z2 = a1[1] + " " + a2[1];
			var z3 = a1[2] + " " + a2[2];
			var z4 = a1[3] + " " + a2[3];
			var z5 = a1[4] + " " + a2[4];
			var y1 = FunTestUtils.stringFromUnicode(z1);
			var y2 = FunTestUtils.stringFromUnicode(z2);
			var y3 = FunTestUtils.stringFromUnicode(z3);
			var y4 = FunTestUtils.stringFromUnicode(z4);
			var y5 = FunTestUtils.stringFromUnicode(z5);
			y2 = m_unicode.toNFC(y2);
			y4 = m_unicode.toNFC(y4);
			checkString(y1, y2, y3, y4, y5);
		}
	}
}
