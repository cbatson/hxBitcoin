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

import com.fundoware.engine.test.FunTestCase;
import com.fundoware.engine.test.FunTestUtils;

class FunUnicodeNormalizationTestCase extends FunTestCase
{
	private function checkHex(c1 : String, c2 : String, c3 : String, c4 : String, c5 : String) : Void
	{
		return checkString(FunTestUtils.stringFromUnicode(c1), FunTestUtils.stringFromUnicode(c2), FunTestUtils.stringFromUnicode(c3), FunTestUtils.stringFromUnicode(c4), FunTestUtils.stringFromUnicode(c5));
	}

	private function checkString(c1 : String, c2 : String, c3 : String, c4 : String, c5 : String) : Void
	{
		/*
			CONFORMANCE:

			1. The following invariants must be true for all conformant implementations

			NFC
				c2 ==  toNFC(c1) ==  toNFC(c2) ==  toNFC(c3)
				c4 ==  toNFC(c4) ==  toNFC(c5)

			NFD
				c3 ==  toNFD(c1) ==  toNFD(c2) ==  toNFD(c3)
				c5 ==  toNFD(c4) ==  toNFD(c5)

			NFKC
				c4 == toNFKC(c1) == toNFKC(c2) == toNFKC(c3) == toNFKC(c4) == toNFKC(c5)

			NFKD
				c5 == toNFKD(c1) == toNFKD(c2) == toNFKD(c3) == toNFKD(c4) == toNFKD(c5)

			2. For every code point X assigned in this version of Unicode that is not specifically
			listed in Part 1, the following invariants must be true for all conformant
			implementations:

				X == toNFC(X) == toNFD(X) == toNFKC(X) == toNFKD(X)
		*/

		assertEquals(c2, m_unicode.toNFC(c1));
		assertEquals(c2, m_unicode.toNFC(c2));
		assertEquals(c2, m_unicode.toNFC(c3));
		assertEquals(c4, m_unicode.toNFC(c4));
		assertEquals(c4, m_unicode.toNFC(c5));

		assertEquals(c3, m_unicode.toNFD(c1));
		assertEquals(c3, m_unicode.toNFD(c2));
		assertEquals(c3, m_unicode.toNFD(c3));
		assertEquals(c5, m_unicode.toNFD(c4));
		assertEquals(c5, m_unicode.toNFD(c5));
	}

	public function new()
	{
		super();
	}

	private var m_unicode = new FunUnicodeNormalization();
}
