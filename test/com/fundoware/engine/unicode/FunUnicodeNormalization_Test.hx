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

import com.fundoware.engine.test.FunTestUtils;
import haxe.io.Bytes;

class FunUnicodeNormalization_Test extends FunUnicodeNormalizationTestCase
{
	public function testBIP38Vector() : Void
	{
		// Test vector from https://github.com/bitcoin/bips/blob/master/bip-0038.mediawiki
		// Retrieved 2014.11.30
		var s = FunTestUtils.stringFromUnicode("03D2 0301 0000 10400 1F4A9");
		s = m_unicode.toNFC(s);
		assertEquals("cf9300f0909080f09f92a9", Bytes.ofString(s).toHex());
	}

	public function testX_Normalization_Part0(x : Int) : Int
	{
		return checkX(FunUnicodeNormalization_TestVectors.s_testVectors_Part0, x);
	}

	public function testX_Normalization_Part1(x : Int) : Int
	{
		return checkX(FunUnicodeNormalization_TestVectors.s_testVectors_Part1, x);
	}

	public function testX_Normalization_Part2(x : Int) : Int
	{
		return checkX(FunUnicodeNormalization_TestVectors.s_testVectors_Part2, x);
	}

	public function testX_Normalization_Part3(x : Int) : Int
	{
		return checkX(FunUnicodeNormalization_TestVectors.s_testVectors_Part3, x);
	}

	private function checkX(testVectors : String, x : Int) : Int
	{
		var a = testVectors.split("|");
		var s = StringTools.trim(a[x]);
		var v = s.split(",");
		checkHex(v[0], v[1], v[2], v[3], v[4]);
		return a.length;
	}
}
