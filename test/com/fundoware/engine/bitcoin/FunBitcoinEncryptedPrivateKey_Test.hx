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

import com.fundoware.engine.exception.FunExceptions;
import com.fundoware.engine.test.FunTestCase;
import com.fundoware.engine.test.FunTestUtils;
import com.fundoware.engine.unicode.FunUnicode;
import haxe.io.Bytes;

class FunBitcoinEncryptedPrivateKey_Test extends FunTestCase
{
	// This test takes too long for Flash.
	#if !flash
		public function testChecksumMismatchNoECMult() : Void
		{
			// Based on test vectors from https://github.com/bitcoin/bips/blob/master/bip-0038.mediawiki
			// Retrieved 2014.11.30
			var epk = FunBitcoinEncryptedPrivateKey.fromString(m_context, "6PRVWUbm2wcmqwcTTXAohTWNsnMxrJdbDD6Pq8zAdqBXGSrEFnQsLGuToc");
			assertThrowsString(FunExceptions.FUN_CHECKSUM_MISMATCH, function() : Void
			{
				var pk = epk.decryptString("TestingOneTwoThree");
			});
		}

		public function testChecksumMismatchECMult() : Void
		{
			// Based on test vectors from https://github.com/bitcoin/bips/blob/master/bip-0038.mediawiki
			// Retrieved 2014.11.30
			var epk = FunBitcoinEncryptedPrivateKey.fromString(m_context, "6PfQu77yiSiUa1mXM2a7Wv4KBAnrQWTpuv1iTC58Ub3dPKZpbAkz3Dx8oq");
			assertThrowsString(FunExceptions.FUN_CHECKSUM_MISMATCH, function() : Void
			{
				var pk = epk.decryptString("TestingOneTwoThree");
			});
		}

		public function testX_NoECMult(x : Int) : Int
		{
			var testVectors = [
				// Test vectors from https://github.com/bitcoin/bips/blob/master/bip-0038.mediawiki
				// Retrieved 2014.11.30

				// No compression, no EC multiply
				// Test 1
				["6PRVWUbkzzsbcVac2qwfssoUJAN1Xhrg6bNk8J7Nzm5H7kxEbn2Nh2ZoGg", "5KN7MzqK5wt2TP1fQCYyHBtDrXdJuXbUzm4A9rKAteGu3Qi5CVR", "TestingOneTwoThree"],
				// Test 2
				["6PRNFFkZc2NZ6dJqFfhRoFNMR9Lnyj7dYGrzdgXXVMXcxoKTePPX1dWByq", "5HtasZ6ofTHP6HCwTqTkLDuLQisYPah7aUnSKfC7h4hMUVw2gi5", "Satoshi"],
				// Test 3
				["6PRW5o9FLp4gJDDVqJQKJFTpMvdsSGJxMYHtHaQBF3ooa8mwD69bapcDQn", "5Jajm8eQ22H3pGWLEVCXyvND8dQZhiQhoLJNKjYXk9roUFTMSZ4", FunTestUtils.stringFromUnicode("03D2 0301 0000 10400 1F4A9")],

				// Compression, no EC multiply
				// Test 1
				["6PYNKZ1EAgYgmQfmNVamxyXVWHzK5s6DGhwP4J5o44cvXdoY7sRzhtpUeo", "L44B5gGEpqEDRS9vVPz7QT35jcBG2r3CZwSwQ4fCewXAhAhqGVpP", "TestingOneTwoThree"],
				// Test 2
				["6PYLtMnXvfG3oJde97zRyLYFZCYizPU5T3LwgdYJz1fRhh16bU7u6PPmY7", "KwYgW8gcxj1JWJXhPSu4Fqwzfhp5Yfi42mdYmMa4XqK7NJxXUSK7", "Satoshi"],
			];
			return check(testVectors, x);
		}

		public function testX_ECMult(x : Int) : Int
		{
			var testVectors = [
				// Test vectors from https://github.com/bitcoin/bips/blob/master/bip-0038.mediawiki
				// Retrieved 2014.11.30

				// EC multiply, no compression, no lot/sequence numbers
				// Test 1
				["6PfQu77ygVyJLZjfvMLyhLMQbYnu5uguoJJ4kMCLqWwPEdfpwANVS76gTX", "passphrasepxFy57B9v8HtUsszJYKReoNDV6VHjUSGt8EVJmux9n1J3Ltf1gRxyDGXqnf9qm", "1PE6TQi6HTVNz5DLwB1LcpMBALubfuN2z2", "5K4caxezwjGCGfnoPTZ8tMcJBLB7Jvyjv4xxeacadhq8nLisLR2", "TestingOneTwoThree"],
				// Test 2
				["6PfLGnQs6VZnrNpmVKfjotbnQuaJK4KZoPFrAjx1JMJUa1Ft8gnf5WxfKd", "passphraseoRDGAXTWzbp72eVbtUDdn1rwpgPUGjNZEc6CGBo8i5EC1FPW8wcnLdq4ThKzAS", "1CqzrtZC6mXSAhoxtFwVjz8LtwLJjDYU3V", "5KJ51SgxWaAYR13zd9ReMhJpwrcX47xTJh2D3fGPG9CM8vkv5sH", "Satoshi"],

				// EC multiply, no compression, lot/sequence numbers
				// Test 1
				["6PgNBNNzDkKdhkT6uJntUXwwzQV8Rr2tZcbkDcuC9DZRsS6AtHts4Ypo1j", "passphraseaB8feaLQDENqCgr4gKZpmf4VoaT6qdjJNJiv7fsKvjqavcJxvuR1hy25aTu5sX", "1Jscj8ALrYu2y9TD8NrpvDBugPedmbj4Yh", "5JLdxTtcTHcfYcmJsNVy1v2PMDx432JPoYcBTVVRHpPaxUrdtf8", "MOLON LABE"],
				// Confirmation code: cfrm38V8aXBn7JWA1ESmFMUn6erxeBGZGAxJPY4e36S9QWkzZKtaVqLNMgnifETYw7BPwWC9aPD; Lot/Sequence: 263183/1
				// Test 2
				["6PgGWtx25kUg8QWvwuJAgorN6k9FbE25rv5dMRwu5SKMnfpfVe5mar2ngH", "passphrased3z9rQJHSyBkNBwTRPkUGNVEVrUAcfAXDyRU1V28ie6hNFbqDwbFBvsTK7yWVK", "1Lurmih3KruL4xDB5FmHof38yawNtP9oGf", "5KMKKuUmAkiNbA3DazMQiLfDq47qs8MAEThm4yL8R2PhV1ov33D", FunTestUtils.stringFromUnicode("039C 039F 039B 03A9 039D 0020 039B 0391 0392 0395")],
				// Confirmation code: cfrm38V8G4qq2ywYEFfWLD5Cc6msj9UwsG2Mj4Z6QdGJAFQpdatZLavkgRd1i4iBMdRngDqDs51; Lot/Sequence: 806938/1

				// Test vectors generated on bitaddress.org
				// Retrieved 2014.11.30
				["6PfTY7gzXW6pqUUhquy3wYYToHv4gzcTm4hEMjignAUSff79pjoMwgy43G", null, "1F2agyATm5XERdgp2rezXyaTeHsh5LeHjM", "5JiKpauMdiim1rqwY5zZiUa7AsBbErkEuEWvJfKXaDUY8HCDbwW", "foo"],
				["6PfPD6ydmQDTK1TFMJHy8c1NbSKKh2cgRnPLeH8iQyCQazEaCRtKoBoo1U", null, "13yvKBZanGPyX2ssfMHymvWBgmkc6bgjdB", "5KfiqhWRQWuhzqo6aAJtm1qG4b9uJrUp2kAe2A8LZY1aQoGZot1", "test"],
			];
			return checkEC(testVectors, x);
		}
	#end

	private function check(testVectors : Array<Array<String>>, x : Int) : Int
	{
		var v = testVectors[x];
		var encWIF : String = v[0];
		var unencWIF : String = v[1];
		var password : String = v[2];

		var pk : FunBitcoinPrivateKey;
		var epk : FunBitcoinEncryptedPrivateKey;

		pk = FunBitcoinPrivateKey.fromString(m_context, unencWIF);
		epk = FunBitcoinEncryptedPrivateKey.encryptString(m_context, pk, password);
		assertEquals(encWIF, epk.toWIF());

		epk = FunBitcoinEncryptedPrivateKey.fromString(m_context, encWIF);
		pk = epk.decryptString(password);
		epk.clear();
		assertEquals(unencWIF, pk.toWIF());

		return testVectors.length;
	}

	private function checkEC(testVectors : Array<Array<String>>, x : Int) : Int
	{
		var v = testVectors[x];
		var encWIF : String = v[0];
		var passCode : String = v[1];
		var addr : String = v[2];
		var unencWIF : String = v[3];
		var password : String = v[4];

		var pk : FunBitcoinPrivateKey;
		var epk : FunBitcoinEncryptedPrivateKey;

		//pk = FunBitcoinPrivateKey.fromWIF(m_context, unencWIF);
		//epk = FunBitcoinEncryptedPrivateKey.encryptString(m_context, pk, password);
		//assertEquals(encWIF, epk.toWIF());

		epk = FunBitcoinEncryptedPrivateKey.fromString(m_context, encWIF);
		if (passCode != null)
		{
			assertEquals(passCode, epk.getPassphraseCodeString(password));
		}
		pk = epk.decryptString(password);
		epk.clear();
		assertEquals(unencWIF, pk.toWIF());
		assertEquals(addr, pk.toAddress());

		return testVectors.length;
	}

	private var m_context = new FunBitcoinContext();
}
