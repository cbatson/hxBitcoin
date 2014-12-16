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

package com.fundoware.engine.crypto.pbe;

import com.fundoware.engine.crypto.hash.FunSHA2_256;
import com.fundoware.engine.crypto.hmac.FunHMAC_SHA256;
import haxe.io.Bytes;

class FunPBKDF2_HMAC_SHA256_Test extends FunPBKDFTestCase
{
	public function testRFCVectors() : Void
	{
		// Test vectors from https://tools.ietf.org/id/draft-josefsson-scrypt-kdf-01.txt
		// Retrieved 2014.11.24
		check256("passwd", "salt", 1, "55ac046e56e3089fec1691c22544b605f94185216dde0465e68b9d57c20dacbc49ca9cccf179b645991664b39d77ef317c71b845b1e30bd509112041d3a19783");
		#if !flash
			// too long for Flash
			check256("Password", "NaCl", 80000, "4ddcd8f60b98be21830cee5ef22701f9641a4418d04c0414aeff08876b34ab56a1d425a1225833549adb841b51c9b3176a272bdebba1d078478f62b397f33c8d");
		#end
	}

	private function check256(P : String, S : String, c : Int, expected : String) : Void
	{
		var kdf = newKDF();
		var dkLen = expected.length >> 1;
		var result = kdf.run(Bytes.ofString(P), Bytes.ofString(S), c, dkLen);
		assertEquals(expected, result.toHex());
	}

	public override function newKDF() : FunIPBKDF
	{
		return new FunPBKDF2_HMAC_SHA256(new FunHMAC_SHA256(new FunSHA2_256()));
	}
}
