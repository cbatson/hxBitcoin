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

package com.fundoware.engine.crypto.scrypt;

import com.fundoware.engine.crypto.hash.FunSHA2_256;
import com.fundoware.engine.crypto.hmac.FunHMAC_SHA256;
import com.fundoware.engine.crypto.pbe.FunIPBKDF;
import com.fundoware.engine.crypto.pbe.FunPBKDF2_HMAC_SHA256;
import com.fundoware.engine.crypto.pbe.FunPBKDFTestCase;
import com.fundoware.engine.crypto.pbe.FunPBKDFTools;

class FunScrypt_Test extends FunPBKDFTestCase
{
	public function testX_PDFVectors(x : Int) : Int
	{
		// Test vectors from https://www.tarsnap.com/scrypt/scrypt.pdf
		// Retrieved 2014.11.24
		var testVectors : Array<Array<Dynamic>> = [
			["", "", 16, 1, 1, 64, "77d6576238657b203b19ca42c18a0497f16b4844e3074ae8dfdffa3fede21442fcd0069ded0948f8326a753a0fc81f17e8d3e0fb2e0d3628cf35e20c38d18906"],
			["password", "NaCl", 1024, 8, 16, 64, "fdbabe1c9d3472007856e7190d01e9fe7c6ad7cbc8237830e77376634b3731622eaf30d92e22a3886ff109279d9830dac727afb94a83ee6d8360cbdfa2cc0640"],
			["pleaseletmein", "SodiumChloride", 16384, 8, 1, 64, "7023bdcb3afd7348461c06cd81fd38ebfda8fbba904f8e3ea9b543f6545da1f2d5432955613f0fcf62d49705242a9af9e61e85dc0d651e40dfcf017b45575887"],
			// The following test is too large/slow for some platforms
			#if (!(neko || flash || ios))
				["pleaseletmein", "SodiumChloride", 1048576, 8, 1, 64, "2101cb9b6a511aaeaddbbe09cf70f881ec568d574a2ffd4dabe5ee9820adaa478e56fd8f4ba5d09ffa1c6d927c40f4c337304049e8a952fbcbf45c6fa77a41a4"],
			#end
		];
		return checkX(testVectors, x);
	}

	private function checkX(testVectors : Array<Array<Dynamic>>, x : Int) : Int
	{
		var v = testVectors[x];
		var P = cast(v[0], String);
		var S = cast(v[1], String);
		var N = cast(v[2], Int);
		var r = cast(v[3], Int);
		var p = cast(v[4], Int);
		var dkLen = cast(v[5], Int);
		var expected = cast(v[6], String);
		check(P, S, N, r, p, dkLen, expected);
		return testVectors.length;
	}

	private function check(P : String, S : String, N : Int, r : Int, p : Int, dkLen : Int, expected : String) : Void
	{
		var kdf = new FunPBKDF2_HMAC_SHA256(new FunHMAC_SHA256(new FunSHA2_256()));
		var scrypt = new FunScrypt(N, r, p, kdf);
		var result = FunPBKDFTools.ofStrings(scrypt, P, S, 1, dkLen);
		assertEquals(expected, result.toHex());
	}

	public override function newKDF() : FunIPBKDF
	{
		var kdf = new FunPBKDF2_HMAC_SHA256(new FunHMAC_SHA256(new FunSHA2_256()));
		var scrypt = new FunScrypt(16, 1, 1, kdf);
		return scrypt;
	}
}
