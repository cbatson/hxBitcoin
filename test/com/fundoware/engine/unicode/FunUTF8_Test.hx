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

import com.fundoware.engine.core.FunUtils;
import com.fundoware.engine.exception.FunExceptions;
import com.fundoware.engine.test.FunTestCase;
import haxe.ds.Vector;

class FunUTF8_Test extends FunTestCase
{
	public function testX_OtherBoundaries(x : Int) : Int
	{
		// Test vectors manually crafted on 2014.12.05
		var testVectors : Array<Array<Dynamic>> = [
			["f5808080", -1],
			["f880808080", -1],
			["fc8080808080", -1],
		];
		return checkX(testVectors, x);
	}

	public function testX_MarkusKuhnVectors(x : Int) : Int
	{
		// Test vectors from http://www.cl.cam.ac.uk/~mgk25/ucs/examples/UTF-8-test.txt
		// Retrieved 2014.12.05
		var testVectors : Array<Array<Dynamic>> = [
			// 2.1  First possible sequence of a certain length
			["00", 0],
			["c280", 0x80],
			["e0a080", 0x800],
			["f0908080", 0x10000],
			// 2.2  Last possible sequence of a certain length
			["7f", 0x7f],
			["dfbf", 0x7ff],
			["efbfbf", 0xffff],
			["f48fbfbf", 0x10ffff],
			// 2.3  Other boundary conditions
			["ed9fbf", 0xd7ff],
			["ee8080", 0xe000],
			["efbfbd", 0xfffd],
			["f4908080", -1],	// 0x110000
			// 3.1  Unexpected continuation bytes
			["80", -1],
			["bf", -1],
			// 3.2.1  All 32 first bytes of 2-byte sequences (0xc0-0xdf), each followed by a space character:
			["c020", -1],
			["c120", -1],
			["c220", -1],
			["c320", -1],
			["c420", -1],
			["c520", -1],
			["c620", -1],
			["c720", -1],
			["c820", -1],
			["c920", -1],
			["ca20", -1],
			["cb20", -1],
			["cc20", -1],
			["cd20", -1],
			["ce20", -1],
			["cf20", -1],
			["d020", -1],
			["d120", -1],
			["d220", -1],
			["d320", -1],
			["d420", -1],
			["d520", -1],
			["d620", -1],
			["d720", -1],
			["d820", -1],
			["d920", -1],
			["da20", -1],
			["db20", -1],
			["dc20", -1],
			["dd20", -1],
			["de20", -1],
			["df20", -1],
			// 3.2.2  All 16 first bytes of 3-byte sequences (0xe0-0xef), each followed by a space character:
			["e020", -1],
			["e120", -1],
			["e220", -1],
			["e320", -1],
			["e420", -1],
			["e520", -1],
			["e620", -1],
			["e720", -1],
			["e820", -1],
			["e920", -1],
			["ea20", -1],
			["eb20", -1],
			["ec20", -1],
			["ed20", -1],
			["ee20", -1],
			["ef20", -1],
			// 3.2.3  All 8 first bytes of 4-byte sequences (0xf0-0xf7), each followed by a space character:
			["f020", -1],
			["f120", -1],
			["f220", -1],
			["f320", -1],
			["f420", -1],
			["f520", -1],
			["f620", -1],
			["f720", -1],
			// 3.3  Sequences with last continuation byte missing
			["c0", -1],
			["e080", -1],
			["f08080", -1],
			["df", -1],
			["efbf", -1],
			["f48fbf", -1],
			// 3.5  Impossible bytes
			["fe", -1],
			["ff", -1],
			["fefeffff", -1],
			// 4.1  Examples of an overlong ASCII character
			["c0af", -1],
			["e080af", -1],
			["f08080af", -1],
			["f8808080af", -1],
			["fc80808080af", -1],
			// 4.2  Maximum overlong sequences
			["c1bf", -1],
			["e09fbf", -1],
			["f08fbfbf", -1],
			["f887bfbfbf", -1],
			["fc83bfbfbfbf", -1],
			// 4.3  Overlong representation of the NUL character
			["c080", -1],
			["e08080", -1],
			["f0808080", -1],
			["f880808080", -1],
			["fc8080808080", -1],
			// 5.1 Single UTF-16 surrogates
			["eda080", -1],
			["edadbf", -1],
			["edae80", -1],
			["edafbf", -1],
			["edb080", -1],
			["edbe80", -1],
			["edbfbf", -1],
			// 5.2 Paired UTF-16 surrogates
			["eda080edb080", -1],
			["eda080edbfbf", -1],
			["edadbfedb080", -1],
			["edadbfedbfbf", -1],
			["edae80edb080", -1],
			["edae80edbfbf", -1],
			["edafbfedb080", -1],
			["edafbfedbfbf", -1],
			// 5.3 Other illegal code positions
			#if false
			["efbfbe", -1],
			["efbfbf", -1],
			#end
		];
		return checkX(testVectors, x);
	}

	public function testWikipediaVectors() : Void
	{
		// Test vectors from http://en.wikipedia.org/wiki/UTF-8
		// Retrieved 2014.12.05
		checkCP("24", 0x24);
		checkCP("c2a2", 0xa2);
		checkCP("e282ac", 0x20ac);
		checkCP("f0a4ada2", 0x24b62);
	}

	public function testOutOfBounds() : Void
	{
		var b = FunUtils.hexToBytes("c2a2");
		var s = b.toString();
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunUTF8.getCodePointBytes(b, 2);
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunUTF8.getCodePointString(s, 2);
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunUTF16.getCodePointString(s, 2);
		});
	}

	private function checkX(testVectors : Array<Array<Dynamic>>, x : Int) : Int
	{
		var v = testVectors[x];
		checkCP(cast(v[0], String), cast(v[1], Int));
		return testVectors.length;
	}

	private function checkCP(hex : String, expectedCP : Int) : Void
	{
		var b = FunUtils.hexToBytes(hex);
		var cp = FunUTF8.getCodePointBytes(b, 0);
		assertEquals(expectedCP, cp);

		var sb = new StringBuf();
		for (i in 0 ... b.length)
		{
			sb.addChar(b.get(i));
		}
		cp = FunUTF8.getCodePointString(sb.toString(), 0);
		assertEquals(expectedCP, cp);

		if (expectedCP >= 0)
		{
			var s = FunUTF8.stringFromBytes(b);
			var cp = FunUnicode.getCodePoint(s, 0);
			assertEquals(expectedCP, cp);

			var v = new Array<Int>();
			v.push(expectedCP);
			var s2 = FunUnicode.stringFromCodePoints(v);
			assertEquals(s, s2);
		}
	}
}
