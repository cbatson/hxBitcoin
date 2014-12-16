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

package com.fundoware.engine.bitcoin;

import com.fundoware.engine.bigint.FunBigInt;
import com.fundoware.engine.bigint.FunMutableBigInt;
import com.fundoware.engine.crypto.ec.FunEllipticCurves;
import com.fundoware.engine.crypto.hash.FunRIPEMD160;
import com.fundoware.engine.crypto.hash.FunSHA2_256;
import com.fundoware.engine.exception.FunExceptions;
import com.fundoware.engine.test.FunTestCase;

class FunBitcoinPrivateKey_Test extends FunTestCase
{
	public function testAllowTestnet() : Void
	{
		var privKey = FunBitcoinPrivateKey.fromString(m_context, "5KN7MzqK5wt2TP1fQCYyHBtDrXdJuXbUzm4A9rKAteGu3Qi5CVR", false);
		privKey = FunBitcoinPrivateKey.fromString(m_context, "5KN7MzqK5wt2TP1fQCYyHBtDrXdJuXbUzm4A9rKAteGu3Qi5CVR", true);
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			privKey = FunBitcoinPrivateKey.fromString(m_context, "9213qJab2HNEpMpYNBa7wHGFKKbkDn24jpANDs2huN3yi4J11ko", false);
		});
		privKey = FunBitcoinPrivateKey.fromString(m_context, "9213qJab2HNEpMpYNBa7wHGFKKbkDn24jpANDs2huN3yi4J11ko", true);
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			privKey = FunBitcoinPrivateKey.fromString(m_context, "9213qJab2HNEpMpYNBa7wHGFKKbkDn24jpANDs2huN3yi4J11ko");
		});
	}

	public function testX_WIF(x : Int) : Int
	{
		// Test vectors 0 through 8 from https://github.com/bitcoin/bips/blob/master/bip-0038.mediawiki
		// Retrieved 2014.11.24
		// Test vectors 9 through 15 from "Mastering Bitcoin", Early release revision 6; Andreas M. Antonopoulos; 2014.
		// Test vectors 16 through 39 from https://gitorious.org/bitcoin/bitcoind-stable/commit/d6b13283d19b3229ec1aee62bf7b4747c581ddab
		// Retrieved 2014.11.20
		var testString =
"5KN7MzqK5wt2TP1fQCYyHBtDrXdJuXbUzm4A9rKAteGu3Qi5CVR,cbf4b9f70470856bb4f40f80b87edb90865997ffee6df315ab166d713af433a5,1Jq6MksXQVWzrznvZzxkV6oY57oWXD9TXB|
5HtasZ6ofTHP6HCwTqTkLDuLQisYPah7aUnSKfC7h4hMUVw2gi5,09c2686880095b1a4c249ee3ac4eea8a014f11e6f986d0b5025ac1f39afbd9ae,1AvKt49sui9zfzGeo8EyL8ypvAhtR2KwbL|
5Jajm8eQ22H3pGWLEVCXyvND8dQZhiQhoLJNKjYXk9roUFTMSZ4,64eeab5f9be2a01a8365a579511eb3373c87c40da6d2a25f05bda68fe077b66e,16ktGzmfrurhbhi6JGqsMWf7TyqK9HNAeF|
L44B5gGEpqEDRS9vVPz7QT35jcBG2r3CZwSwQ4fCewXAhAhqGVpP,cbf4b9f70470856bb4f40f80b87edb90865997ffee6df315ab166d713af433a5,164MQi977u9GUteHr4EPH27VkkdxmfCvGW|
KwYgW8gcxj1JWJXhPSu4Fqwzfhp5Yfi42mdYmMa4XqK7NJxXUSK7,09c2686880095b1a4c249ee3ac4eea8a014f11e6f986d0b5025ac1f39afbd9ae,1HmPbwsvG5qJ3KJfxzsZRZWhbm1xBMuS8B|
5K4caxezwjGCGfnoPTZ8tMcJBLB7Jvyjv4xxeacadhq8nLisLR2,a43a940577f4e97f5c4d39eb14ff083a98187c64ea7c99ef7ce460833959a519,1PE6TQi6HTVNz5DLwB1LcpMBALubfuN2z2|
5KJ51SgxWaAYR13zd9ReMhJpwrcX47xTJh2D3fGPG9CM8vkv5sH,c2c8036df268f498099350718c4a3ef3984d2be84618c2650f5171dcc5eb660a,1CqzrtZC6mXSAhoxtFwVjz8LtwLJjDYU3V|
5JLdxTtcTHcfYcmJsNVy1v2PMDx432JPoYcBTVVRHpPaxUrdtf8,44ea95afbf138356a05ea32110dfd627232d0f2991ad221187be356f19fa8190,1Jscj8ALrYu2y9TD8NrpvDBugPedmbj4Yh|
5KMKKuUmAkiNbA3DazMQiLfDq47qs8MAEThm4yL8R2PhV1ov33D,ca2759aa4adb0f96c414f36abeb8db59342985be9fa50faac228c8e7d90e3006,1Lurmih3KruL4xDB5FmHof38yawNtP9oGf|
KyBsPXxTuVD82av65KZkrGrWi5qLMah5SdNq6uftawDbgKa2wv6S,3aba4162c7251c891207b747840551a71939b0de081f85c4e44cf7c13e41daa6,14cxpo3MBCYYWCgF74SWTdcmxipnGUsPw3|
5JG9hT3beGTJuUAmCQEmNaxAuMacCTfXuw1R3FCXig23RQHMr4K,3aba4162c7251c891207b747840551a71939b0de081f85c4e44cf7c13e41daa6,1thMirt546nngXqyPEz532S8fLwbozud8|
KxFC1jmwwCoACiCAWZ3eXa96mBM6tb3TYzGmf6YwgdGWZgawvrtJ,1e99423a4ed27608a15a2616a2b0e9e52ced330ac530edcc32c8ffc6a526aedd,1J7mdg5rbQyUHENYdx39WVWK7fsLpEoXZy|
5J3mBbAH58CpQ3Y5RNJpUKPE62SQ5tfcvU2JpbnkeyhfsYB1Jcn,1e99423a4ed27608a15a2616a2b0e9e52ced330ac530edcc32c8ffc6a526aedd,1424C2F4bC9JidNjjTUZCbUxv6Sa1Mt62x|
5K1TaGDVJD3XETBAi2GT7GzmS4Lna24XQ3Mp5RsZTRwfnvjrYLn,9d106bd7e77f1c5fcc5f05601b42078e09f7a69107b8e9f58956e3ece966abcb,1Ar6e15vfE5696ms8UBPuAcDckWVnmUGWv|
5Kk1vsHh4FVUWhnFx73vhRjmXbLxVFUjrnDuwFDDaNAZCysgQZX,fdb26b35b418bd90a8cd3aa1478659ae516979493f38b855cb8b7a949d6ae510,12wZqrmqhYqeGWp4WYgxBFPM59LS5UEARD|
5KekXEk4yhochWHScUqXLp8pVhnMVSNuh946zDCdm8xidUFvqEg,f1bd9bb3445cbdf08d8fae5a36934cb7e84745e61236253e6d1bf1611038b404,1At7sTYf5EHUF3DWXXdHf4hyTDvkrDCgzQ|
5Kd3NBUAdUnhyzenEwVLy9pBKxSwXvE9FMPyR4UKZvpe6E3AgLr,eddbdc1168f1daeadbd3e44c1e3f8f5a284c2029f78ad26af98583a499de5b19,1CH9yicUdqhrxL2EHmHaZMDxtPJ3YM3Kzm|
Kz6UJmQACJmLtaQj5A3JAge4kVTNQ8gbvXuwbmCj7bsaabudb3RD,55c9bccb9ed68446d1b75273bbce89d7fe013a8acd1625514420fb2aca1a21c4,12Vox8pNW85dFotFrpdAWBM9KN6TuCtX4m|
5K494XZwps2bGyeL71pWid4noiSNA2cfCibrvRWqcHSptoFn7rc,a326b95ebae30164217d7a7f57d72ab2b54e3be64928a19da0210b9568d4015e,19LMr5n6haVAVc2v7iND9bw7Rq6RTwEm5x|
L1RrrnXkcKut5DEMwtDthjwRcTTwED36thyL1DebVrKuwvohjMNi,7d998b45c219a1e38e99e7cbd312ef67f77a455a9b50c730c27f02c6f730dfb4,1LDsjB43N2NAQ1Vbc2xyHca4iBBciN8iwC|
5KaBW9vNtWNhc3ZEDyNCiXLPdVPHCikRxSBWwV9NrpLLa4LsXi9,e75d936d56377f432f404aabb406601f892fd49da90eb6ac558a733c93b47252,1AyR4CvX6weSkD6rAsN6thWLkAXqnd1zgH|
L1axzbSyynNYA8mCAhzxkipKkfHtAXYF4YQnhSKcLV8YXA874fgT,8248bd0375f2f75d7e274ae544fb920f51784480866b102384190b1addfbaa5c,14UBzd87jwwcvz8jqGZ5JteB5YYoWYohgR|
5HtH6GdcwCJA4ggWEL1B3jzBBUB8HPiBi9SBc5h9i4Wk4PSeApR,091035445ef105fa1bb125eccfb1882f3fe69592265956ade751fd095033d8d0,15Kkci7f26yEwsPPaAcXooG6pJkZc1L2VV|
L2xSYmMeVo3Zek3ZTsv9xUrXVAmrWxJ8Ua4cw8pkfbQhcEFhkXT8,ab2b4bcdfc91d34dee0ae2a8c6b6668dadaeb3a88b9859743156f462325187af,15y3abJqVAag4wwCF8iEcaPKGuhcFQB9XR|
5KQmDryMNDcisTzRp3zEq9e4awRmJrEVU1j5vFRTKpRNYPqYrMg,d1fab7ab7385ad26872237f1eb9789aa25cc986bacc695e07ac571d6cdac8bc0,12YSX5RkLCL6o9w68buMFGxixVipVVCHZY|
L39Fy7AC2Hhj95gh3Yb2AU5YHh1mQSAHgpNixvm27poizcJyLtUi,b0bbede33ef254e8376aceb1510253fc3550efd0fcf84dcd0c9998b288f166b3,1Cj1noWNbqvTgazwgeWdgRmuifpTc3R87B|
5KL6zEaMtPRXZKo1bbMq7JDjjo1bJuQcsgL33je3oY8uSJCR5b4,c7666842503db6dc6ea061f092cfb9c388448629a6fe868d068c42a488b478ae,1MP8Bafs9VvtZRaWNFnEAcLMUA3NPEazNM|
KwV9KAfwbwt51veZWNscRTeZs9CKpojyu1MsPnaKTF5kz69H1UN2,07f0803fc5399e773555ab1e8939907e9badacc17ca129e67a2f5f2ff84351dd,1JKSLRh3C1Fnhbr5ocuV3VYMvbJi3TayRn|
9213qJab2HNEpMpYNBa7wHGFKKbkDn24jpANDs2huN3yi4J11ko,36cb93b9ab1bdabf7fb9f2c04f1b9cc879933530ae7842398eef5a63a56800c2,mjLWQ2qDQk5JZpdw4igzqfzDFMMfZ3Ag76|
cTpB4YiyKiBcPxnefsDpbnDxFDffjqJob8wGCEDXxgQ7zQoMXJdH,b9f4892c9e8282028fea1d2667c4dc5213564d41fc5783896a0d843fc15089f3,mjmLX94Mc6eUWsNJvZ3YeamsbR8ePwKW6P|
93DVKyFYwSN6wEo3E2fCrFPUp17FtrtNi2Lf7n4G3garFb16CRj,d6bca256b5abc5602ec2e1c121a08b0da2556587430bcf7e1898af2224885203,mrAftit8pjghdQqywTTtM9F2RKSat4G1oX|
cTDVKtMGVYWTHCb1AFjmVbEbWjvKpKqKgMaR3QJxToMSQAhmCeTN,a81ca4e8f90181ec4b61b6a7eb998af17b2cb04de8a03b504b9e34c4c61db7d9,muWUbLyo8M3Zc6Qhvqyvvbe81KQf1tqEp7|
927CnUkUbasYtDwYwVn2j8GdTuACNnKkjZ1rpZd2yBB1CLcnXpo,44c4f6a096eac5238291a94cc24c01e3b19b8d8cef72874a079e00a242237a52,msDfW7icg5ou7NFsJyggffmNYUqx8kCsFG|
cUcfCMRjiQf85YMzzQEk9d1s5A4K7xL5SmBCLrezqXFuTVefyhY7,d1de707020a9059d6d3abaf85e17967c6555151143db13dbb06db78df0f15c69,mroECuQ3XaE1n2VxV9Xqs7fZQkxbqjTg8e|
92xFEve1Z9N8Z641KQQS7ByCSb8kGjsDzw6fAmjHN1LZGKQXyMq,b4204389cef18bbe2b353623cbf93e8678fbc92a475b664ae98ed594e6cf0856,n3XXxLwXbZfLMkoQHepg9pQFFBioXKv3gB|
cVM65tdYu1YK37tNoAyGoJTR13VBYFva1vg9FLuPAsJijGvG6NEA,e7b230133f1b5489843260236b06edca25f66adb1be455fbd38d4010d48faeef,mtHTkwNML481HXXhgNf3GQpnYHdSsz2fsR|
91cTVUcgydqyZLgaANpf1fvL55FH53QMm4BsnCADVNYuWuqdVys,037f4192c630f399d9271e26c575269b1d15be553ea1a7217f0cb8513cef41cb,n3HgUdFy4NZhmqgK8fZ1T6CSEFx6C7po73|
cQspfSzsgLeiJGB2u8vrAiWpCU4MxUT6JseWo2SjXy4Qbzn2fwDw,6251e205e8ad508bab5596bee086ef16cd4b239e0cc0c5d7c4e6035441e7d5de,mhYokRsgJ141ksmXfQUrEUsu1jkhLQjNk1|
93N87D6uxSBzwXvpokpzg8FFmfQPmvX4xHoWQe3pLdYpbiwT5YV,ea577acfb5d1d14d3b7b195c321566f12f87d2b77ea3a53f68df7ebf8604a801,myWAwUNCFhQ3qi4Koxa8Cc3u6AyzqfSUuD|
cMxXusSihaX58wpJ3tNuuUcZEQGt6DKJ1wEpxys88FFaQCYjku9h,0b3b34f0958d8a268193a9814da92c3e8b58b4a4378a542863e34ac289cd830c,n32HHekKxctm8uZDArRpDfLA1KDdfKP2XH";

		var testVectors = testString.split("|");
		var test = StringTools.trim(testVectors[x]);
		var v = test.split(",");
		var firstChar = v[0].charAt(0);
		var comp = (firstChar != "5") && (firstChar != "9");
		var testnet = (firstChar == "9") || (firstChar == "c");

		var privKey = FunBitcoinPrivateKey.fromValue(m_context, "0x" + v[1], comp, testnet);
		assertEquals(v[0], privKey.toWIF());
		assertEquals(v[2], privKey.toAddress());

		privKey = FunBitcoinPrivateKey.fromString(m_context, v[0], testnet);
		assertEquals(comp, privKey.isCompressed());
		assertEquals(testnet, privKey.isTestnet());
		assertEquals(v[1], privKey.toBytes().toHex());
		assertEquals(v[2], privKey.toAddress());

		return testVectors.length;
	}

	public function testFromBigIntThatIsCleared() : Void
	{
		// Test vector from "Mastering Bitcoin", Early release revision 6; Andreas M. Antonopoulos; 2014. p. 82.
		var bi : FunMutableBigInt = FunBigInt.fromHexUnsigned("3aba4162c7251c891207b747840551a71939b0de081f85c4e44cf7c13e41daa6");
		var privKey = FunBitcoinPrivateKey.fromValue(m_context, bi, false);
		assertEquals("5JG9hT3beGTJuUAmCQEmNaxAuMacCTfXuw1R3FCXig23RQHMr4K", privKey.toWIF());
		bi.clear();
		assertEquals("5JG9hT3beGTJuUAmCQEmNaxAuMacCTfXuw1R3FCXig23RQHMr4K", privKey.toWIF());
	}

	public function testBounds() : Void
	{
		var privKey = FunBitcoinPrivateKey.fromValue(m_context, "1");
		privKey = FunBitcoinPrivateKey.fromValue(m_context, "0x FFFFFFFF FFFFFFFF FFFFFFFF FFFFFFFE BAAEDCE6 AF48A03B BFD25E8C D0364140");
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			privKey = FunBitcoinPrivateKey.fromValue(m_context, "0");
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			privKey = FunBitcoinPrivateKey.fromValue(m_context, "0x FFFFFFFF FFFFFFFF FFFFFFFF FFFFFFFE BAAEDCE6 AF48A03B BFD25E8C D0364141");
		});
	}

	public function testToBytes() : Void
	{
		var privKey = FunBitcoinPrivateKey.fromValue(m_context, "0x1");
		assertEquals("0000000000000000000000000000000000000000000000000000000000000001", privKey.toBytes().toHex());
		privKey = FunBitcoinPrivateKey.fromValue(m_context, "0x8000000000000000000000000000000000000000000000000000000000000000");
		assertEquals("8000000000000000000000000000000000000000000000000000000000000000", privKey.toBytes().toHex());
		privKey = FunBitcoinPrivateKey.fromValue(m_context, "0x18E14A7B6A307F426A94F8114701E7C8E774E7F9A47E2C2035DB29A206321725");
		assertEquals("18e14a7b6a307f426a94f8114701e7c8e774e7f9a47e2c2035db29a206321725", privKey.toBytes().toHex());
	}

	public function testClear() : Void
	{
		// Test vector from https://en.bitcoin.it/wiki/Technical_background_of_version_1_Bitcoin_addresses
		// Retrieved 2014.11.21
		var privKey = FunBitcoinPrivateKey.fromValue(m_context, "0x18E14A7B6A307F426A94F8114701E7C8E774E7F9A47E2C2035DB29A206321725");
		privKey.clear();
		assertThrowsString(FunExceptions.FUN_INVALID_OPERATION, function() : Void
		{
			privKey.toPublicKey();
		});
	}

	public function testConvertToAddress() : Void
	{
		// Test vector from https://en.bitcoin.it/wiki/Technical_background_of_version_1_Bitcoin_addresses
		// Retrieved 2014.11.21
		var privKey = FunBitcoinPrivateKey.fromValue(m_context, "0x18E14A7B6A307F426A94F8114701E7C8E774E7F9A47E2C2035DB29A206321725", false);
		var pubKey = privKey.toPublicKey();
		privKey.clear();
		var pkb = pubKey.toBytes();
		assertEquals("0450863ad64a87ae8a2fe83c1af1a8403cb53f53e486d8511dad8a04887e5b23522cd470243453a299fa9e77237716103abc11a1df38855ed6f2ee187e9c582ba6", pkb.toHex());
		assertEquals("16UwLL9Risc3QfPqBUvKofHmBQ7wMtjvM", pubKey.toAddress());
	}

	private var m_context = new FunBitcoinContext();
}
