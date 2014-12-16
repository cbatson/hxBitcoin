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

import com.fundoware.engine.crypto.hash.FunSHA1;
import com.fundoware.engine.crypto.hmac.FunHMAC_SHA1;
import haxe.crypto.Base64;
import haxe.io.Bytes;

class FunPBKDF2_HMAC_SHA1_Test extends FunPBKDFTestCase
{
	public function testRFCVectors() : Void
	{
		// Test vectors from http://www.ietf.org/rfc/rfc6070.txt
		// Retrieved 2014.09.05
		check1("password", "salt", 1, 20, "0c60c80f961f0e71f3a9b524af6012062fe037a6");
		check1("password", "salt", 2, 20, "ea6c014dc72d6f8ccd1ed92ace1d41f0d8de8957");
		check1("password", "salt", 4096, 20, "4b007901b765489abead49d926f721d065a429c1");
		check1("passwordPASSWORDpassword", "saltSALTsaltSALTsaltSALTsaltSALTsalt", 4096, 25, "3d2eec4fe41c849b80c8d83662c0e44a8b291a964cf2f07038");

		// "pass\0word", "sa\0lt"
		check2(Base64.decode("cGFzcwB3b3Jk"), Base64.decode("c2EAbHQ="), 4096, 16, "56fa6aa75548099dcc37d7f03425e0c3");
	}

	// This one gets its own test function because it takes so long to run.
	#if (!(neko || flash))
		public function testPBKDF2_HMAC_SHA1_Long() : Void
		{
			// Test vectors from http://www.ietf.org/rfc/rfc6070.txt
			// Retrieved 2014.09.05
			check1("password", "salt", 16777216, 20, "eefe3d61cd4da4e4e9945b3d6ba2158c2634e984");
		}
	#end
	
	private function check2(P : Bytes, S : Bytes, c : Int, dkLen : Int, expected : String) : Void
	{
		var kdf = newKDF();
		var result = kdf.run(P, S, c, dkLen);
		assertEquals(expected, result.toHex());
	}

	private function check1(P : String, S : String, c : Int, dkLen : Int, expected : String) : Void
	{
		check2(Bytes.ofString(P), Bytes.ofString(S), c, dkLen, expected);
	}

	public override function newKDF() : FunIPBKDF
	{
		return new FunPBKDF2_HMAC_SHA1(new FunHMAC_SHA1(new FunSHA1()));
	}
}
