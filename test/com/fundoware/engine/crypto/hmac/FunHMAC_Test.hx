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

package com.fundoware.engine.crypto.hmac;

import com.fundoware.engine.core.FunUtils;
import com.fundoware.engine.crypto.hash.FunSHA1;
import com.fundoware.engine.crypto.hash.FunSHA2_256;
import com.fundoware.engine.test.FunTestCase;
import com.fundoware.engine.test.FunTestUtils;
import haxe.io.Bytes;

class FunHMAC_Test extends FunTestCase
{
	public function testRFC4231() : Void
	{
		// Test vectors from http://tools.ietf.org/rfc/rfc4231.txt
		// Retrieved 2014.11.24

		// Test Case 1
		checkRFC4231(
			FunTestUtils.MakeBytes(0x0b, 20),
			Bytes.ofString("Hi There"),
			"896fb1128abbdf196832107cd49df33f47b4b1169912ba4f53684b22",
			"b0344c61d8db38535ca8afceaf0bf12b881dc200c9833da726e9376c2e32cff7",
			"afd03944d84895626b0825f4ab46907f15f9dadbe4101ec682aa034c7cebc59cfaea9ea9076ede7f4af152e8b2fa9cb6",
			"87aa7cdea5ef619d4ff0b4241a1d6cb02379f4e2ce4ec2787ad0b30545e17cdedaa833b7d6b8a702038b274eaea3f4e4be9d914eeb61f1702e696c203a126854"
		);

		// Test Case 2
		checkRFC4231(
			Bytes.ofString("Jefe"),
			Bytes.ofString("what do ya want for nothing?"),
			"a30e01098bc6dbbf45690f3a7e9e6d0f8bbea2a39e6148008fd05e44",
			"5bdcc146bf60754e6a042426089575c75a003f089d2739839dec58b964ec3843",
			"af45d2e376484031617f78d2b58a6b1b9c7ef464f5a01b47e42ec3736322445e8e2240ca5e69e2c78b3239ecfab21649",
			"164b7a7bfcf819e2e395fbe73b56e0a387bd64222e831fd610270cd7ea2505549758bf75c05a994a6d034f65f8f0e6fdcaeab1a34d4a6b4b636e070a38bce737"
		);

		// Test Case 3
		checkRFC4231(
			FunTestUtils.MakeBytes(0xaa, 20),
			FunTestUtils.MakeBytes(0xdd, 50),
			"7fb3cb3588c6c1f6ffa9694d7d6ad2649365b0c1f65d69d1ec8333ea",
			"773ea91e36800e46854db8ebd09181a72959098b3ef8c122d9635514ced565fe",
			"88062608d3e6ad8a0aa2ace014c8a86f0aa635d947ac9febe83ef4e55966144b2a5ab39dc13814b94e3ab6e101a34f27",
			"fa73b0089d56a284efb0f0756c890be9b1b5dbdd8ee81a3655f83e33b2279d39bf3e848279a722c806b485a47e67c807b946a337bee8942674278859e13292fb"
		);

		// Test Case 4
		checkRFC4231(
			FunUtils.hexToBytes("0102030405060708090a0b0c0d0e0f10111213141516171819"),
			FunTestUtils.MakeBytes(0xcd, 50),
			"6c11506874013cac6a2abc1bb382627cec6a90d86efc012de7afec5a",
			"82558a389a443c0ea4cc819899f2083a85f0faa3e578f8077a2e3ff46729665b",
			"3e8a69b7783c25851933ab6290af6ca77a9981480850009cc5577c6e1f573b4e6801dd23c4a7d679ccf8a386c674cffb",
			"b0ba465637458c6990e5a8c5f61d4af7e576d97ff94b872de76f8050361ee3dba91ca5c11aa25eb4d679275cc5788063a5f19741120c4f2de2adebeb10a298dd"
		);

		// Test Case 5
		checkRFC4231(
			FunTestUtils.MakeBytes(0x0c, 20),
			Bytes.ofString("Test With Truncation"),
			"0e2aea68a90c8d37c988bcdb9fca6fa8",
			"a3b6167473100ee06e0c796c2955552b",
			"3abf34c3503b2a23a46efc619baef897",
			"415fad6271580a531d4179bc891d87a6",
			16
		);

		// Test Case 6
		checkRFC4231(
			FunTestUtils.MakeBytes(0xaa, 131),
			Bytes.ofString("Test Using Larger Than Block-Size Key - Hash Key First"),
			"95e9a0db962095adaebe9b2d6f0dbce2d499f112f2d2b7273fa6870e",
			"60e431591ee0b67f0d8a26aacbf5b77f8e0bc6213728c5140546040f0ee37f54",
			"4ece084485813e9088d2c63a041bc5b44f9ef1012a2b588f3cd11f05033ac4c60c2ef6ab4030fe8296248df163f44952",
			"80b24263c7c1a3ebb71493c1dd7be8b49b46d1f41b4aeec1121b013783f8f3526b56d037e05f2598bd0fd2215d6a1e5295e64f73f63f0aec8b915a985d786598"
		);

		// Test Case 7
		checkRFC4231(
			FunTestUtils.MakeBytes(0xaa, 131),
			Bytes.ofString("This is a test using a larger than block-size key and a larger than block-size data. The key needs to be hashed before being used by the HMAC algorithm."),
			"3a854166ac5d9f023f54d517d0b39dbd946770db9c2b95c9f6f565d1",
			"9b09ffa71b942fcb27635fbcd5b0e944bfdc63644f0713938a7f51535c3a35e2",
			"6617178e941f020d351e2f254e8fd32c602420feb0b8fb9adccebb82461e99c5a678cc31e799176d3860e6110c46523e",
			"e37b6a775dc87dbaa4dfa9f96e5e3ffddebd71f8867289865df5a32d20cdc944b6022cac3c4982b10d5eeb55c3e4de15134676fb6de0446065c97440fa8c6a58"
		);
	}
	private function checkRFC4231(key : Bytes, data : Bytes, expected224 : String, expected256 : String, expected384 : String, expected512 : String, trunc : Int = 0) : Void
	{
		var hmac = new FunHMAC_SHA256(new FunSHA2_256());
		var result = hmac.run(key, data, data.length);
		var actual = result.toHex();
		if (trunc > 0)
		{
			actual = actual.substr(0, trunc * 2);
		}
		assertEquals(expected256, actual);
		// TODO: check 224, 384, and 512 variations
	}

	public function testWikipedia() : Void
	{
		// Test vectors from http://en.wikipedia.org/wiki/Hash-based_message_authentication_code
		// Retrieved on 2014.09.05
		check("", "", "fbdb1d1b18aa6c08324b7d64b71fb76370690e1d");
		check("key", "The quick brown fox jumps over the lazy dog", "de7c9b85b8b78aa6bc8a7a36f70a90701c9db4d9");

		// Test vectors from http://en.wikipedia.org/wiki/Hash-based_message_authentication_code
		// Retrieved on 2014.11.24
		checkStringSHA256("", "", "b613679a0814d9ec772f95d778c35fc5ff1697c493715653c6c712144292c5ad");
		checkStringSHA256("key", "The quick brown fox jumps over the lazy dog", "f7bc83f430538424b13298e6aa6fb143ef4d59a14946175997479dbc2d1a3cd8");
	}

	public function testRFC2202() : Void
	{
		// Test vectors from http://www.ietf.org/rfc/rfc2202.txt
		// Retrieved on 2014.09.05
		check2(MakeBytes(0x0b, 20), Bytes.ofString("Hi There"), "b617318655057264e28bc0b6fb378c8ef146be00");
		check("Jefe", "what do ya want for nothing?", "effcdf6ae5eb2fa2d27416d5f184df9c259a7c79");
		check2(MakeBytes(0xaa, 20), MakeBytes(0xdd, 50), "125d7342b9ac11cd91a39af48aa17b4f63f175d3");

		// Test case 4
		var b = Bytes.alloc(25);
		for (i in 0 ... 25)
		{
			b.set(i, i + 1);
		}
		check2(b, MakeBytes(0xcd, 50), "4c9007f4026250c6bc8414f9bf50c86c2d7235da");

		check2(MakeBytes(0x0c, 20), Bytes.ofString("Test With Truncation"), "4c1a03424b55e07fe7f27be1d58bb9324a9a5a04");
		check2(MakeBytes(0xaa, 80), Bytes.ofString("Test Using Larger Than Block-Size Key - Hash Key First"), "aa4ae5e15272d00e95705637ce8a3b55ed402112");
		check2(MakeBytes(0xaa, 80), Bytes.ofString("Test Using Larger Than Block-Size Key and Larger Than One Block-Size Data"), "e8e99d0f45237d786d6bbaa7965c7808bbff1a91");
	}

	public static function MakeBytes(value : Int, count : Int) : Bytes
	{
		return FunTestUtils.MakeBytes(value, count);
	}

	public function checkStringSHA256(key : String, msg : String, ac : String) : Void
	{
		var hmac = new FunHMAC_SHA256(new FunSHA2_256());
		var M = Bytes.ofString(msg);
		var result = hmac.run(Bytes.ofString(key), M, M.length);
		assertEquals(ac, result.toHex());
	}

	public function check2(key : Bytes, msg : Bytes, ac : String) : Void
	{
		var hmac = new FunHMAC_SHA1(new FunSHA1());
		var result = hmac.run(key, msg, msg.length);
		assertEquals(ac, result.toHex());
	}

	public function check(key : String, msg : String, ac : String) : Void
	{
		check2(Bytes.ofString(key), Bytes.ofString(msg), ac);
	}
}
