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

import com.fundoware.engine.core.FunUtils;
import com.fundoware.engine.test.FunTestCase;
import haxe.io.Bytes;

class FunBitcoinStringIdentifier_Test extends FunTestCase
{
	public function testX_Vectors(x : Int) : Int
	{
		// TODO: What about strings that *would* be valid Base58 if, for example, "l" (letter L) became "1" (number 1)?
		var testVectors : Array<Array<Dynamic>> = [
			[null, FunBitcoinStringIdentifier.Type.kUnknown, FunBitcoinStringIdentifier.Format.kUnknown, FunBitcoinStringIdentifier.Validity.kInvalid],
			["", FunBitcoinStringIdentifier.Type.kUnknown, FunBitcoinStringIdentifier.Format.kUnknown, FunBitcoinStringIdentifier.Validity.kInvalid],
			["_", FunBitcoinStringIdentifier.Type.kUnknown, FunBitcoinStringIdentifier.Format.kUnknown, FunBitcoinStringIdentifier.Validity.kInvalid],
			["x", FunBitcoinStringIdentifier.Type.kUnknown, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kInvalid],
			["O", FunBitcoinStringIdentifier.Type.kUnknown, FunBitcoinStringIdentifier.Format.kUnknown, FunBitcoinStringIdentifier.Validity.kInvalid],
			["0", FunBitcoinStringIdentifier.Type.kUnknown, FunBitcoinStringIdentifier.Format.kUnknown, FunBitcoinStringIdentifier.Validity.kInvalid],
			["00", FunBitcoinStringIdentifier.Type.kUnknown, FunBitcoinStringIdentifier.Format.kHex, FunBitcoinStringIdentifier.Validity.kInvalid],
			["L", FunBitcoinStringIdentifier.Type.kUnknown, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kInvalid],
			["1", FunBitcoinStringIdentifier.Type.kUnknown, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kInvalid],
			["11", FunBitcoinStringIdentifier.Type.kUnknown, FunBitcoinStringIdentifier.Format.kUnknown, FunBitcoinStringIdentifier.Validity.kInvalid],
			["111", FunBitcoinStringIdentifier.Type.kUnknown, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kInvalid],
			["1111", FunBitcoinStringIdentifier.Type.kUnknown, FunBitcoinStringIdentifier.Format.kUnknown, FunBitcoinStringIdentifier.Validity.kInvalid],
			["11111", FunBitcoinStringIdentifier.Type.kAddress, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kChecksum],
			["111111", FunBitcoinStringIdentifier.Type.kUnknown, FunBitcoinStringIdentifier.Format.kUnknown, FunBitcoinStringIdentifier.Validity.kInvalid],
			["123456789ABCDEFabcdef", FunBitcoinStringIdentifier.Type.kAddress, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kChecksum],
			["1123456789ABCDEFabcdef", FunBitcoinStringIdentifier.Type.kUnknown, FunBitcoinStringIdentifier.Format.kUnknown, FunBitcoinStringIdentifier.Validity.kInvalid],
			// base58 value with valid checksum that can also be interpreted as hex
			["e23ec15111", FunBitcoinStringIdentifier.Type.kUnknown, FunBitcoinStringIdentifier.Format.kUnknown, FunBitcoinStringIdentifier.Validity.kInvalid],
			// address
			["1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i", FunBitcoinStringIdentifier.Type.kAddress, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kValid],
			// address, last digit incorrect
			["1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62j", FunBitcoinStringIdentifier.Type.kAddress, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kChecksum],
			// address, last digit missing
			["1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62", FunBitcoinStringIdentifier.Type.kAddress, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kChecksum],
			// address, extra digit at end
			["1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i1", FunBitcoinStringIdentifier.Type.kAddress, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kChecksum],
			// address, byte 0 of checksum incorrect
			["1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6iz5K4", FunBitcoinStringIdentifier.Type.kAddress, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kChecksum],
			// address, byte 1 of checksum incorrect
			["1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hWRWe", FunBitcoinStringIdentifier.Type.kAddress, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kChecksum],
			// address, byte 2 of checksum incorrect
			["1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW678", FunBitcoinStringIdentifier.Type.kAddress, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kChecksum],
			// address, byte 3 of checksum incorrect
			["1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62h", FunBitcoinStringIdentifier.Type.kAddress, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kChecksum],
			// address, valid checksum, 1 too few bytes
			["136kQLW8Lq4ykRkfUi1qjih9hS9rKNd1P", FunBitcoinStringIdentifier.Type.kAddress, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kMalformed],
			// address, valid checksum, 1 extra byte
			["1htrCfM82p9CMAFyeAAYTvLMgAGiVQxNzrC", FunBitcoinStringIdentifier.Type.kAddress, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kMalformed],
			// address (testnet)
			["mo9ncXisMeAoXwqcV5EWuyncbmCcQN4rVs", FunBitcoinStringIdentifier.Type.kAddress, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kValid],
			// address (testnet), byte 0 of checksum incorrect
			["mo9ncXisMeAoXwqcV5EWuyncbmCcQPYqnD", FunBitcoinStringIdentifier.Type.kAddress, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kChecksum],
			// address (testnet), byte 1 of checksum incorrect
			["mo9ncXisMeAoXwqcV5EWuyncbmCcQN4X1w", FunBitcoinStringIdentifier.Type.kAddress, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kChecksum],
			// address (testnet), byte 2 of checksum incorrect
			["mo9ncXisMeAoXwqcV5EWuyncbmCcQN4raH", FunBitcoinStringIdentifier.Type.kAddress, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kChecksum],
			// address (testnet), byte 3 of checksum incorrect
			["mo9ncXisMeAoXwqcV5EWuyncbmCcQN4rVt", FunBitcoinStringIdentifier.Type.kAddress, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kChecksum],
			// address (testnet), valid checksum, 1 too few bytes
			["BA1khLkPw3dSCxg3cmQak9tZ172iM9HwA", FunBitcoinStringIdentifier.Type.kAddress, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kMalformed],
			// address (testnet), valid checksum, 1 extra byte
			["4Qqu4Fvy6nNUfaGqsHdhNoRCkvpVu5KuYNiJ", FunBitcoinStringIdentifier.Type.kAddress, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kMalformed],
			// hex public key
			["0450863ad64a87ae8a2fe83c1af1a8403cb53f53e486d8511dad8a04887e5b23522cd470243453a299fa9e77237716103abc11a1df38855ed6f2ee187e9c582ba6", FunBitcoinStringIdentifier.Type.kPublickKey, FunBitcoinStringIdentifier.Format.kHex, FunBitcoinStringIdentifier.Validity.kValid],
			// hex public key, missing 1 byte
			["0450863ad64a87ae8a2fe83c1af1a8403cb53f53e486d8511dad8a04887e5b23522cd470243453a299fa9e77237716103abc11a1df38855ed6f2ee187e9c582b", FunBitcoinStringIdentifier.Type.kPublickKey, FunBitcoinStringIdentifier.Format.kHex, FunBitcoinStringIdentifier.Validity.kMalformed],
			// hex public key, 1 extra byte
			["0450863ad64a87ae8a2fe83c1af1a8403cb53f53e486d8511dad8a04887e5b23522cd470243453a299fa9e77237716103abc11a1df38855ed6f2ee187e9c582ba6cb", FunBitcoinStringIdentifier.Type.kPublickKey, FunBitcoinStringIdentifier.Format.kHex, FunBitcoinStringIdentifier.Validity.kMalformed],
			// hex public key, compressed (even)
			["0250863ad64a87ae8a2fe83c1af1a8403cb53f53e486d8511dad8a04887e5b2352", FunBitcoinStringIdentifier.Type.kPublickKey, FunBitcoinStringIdentifier.Format.kHex, FunBitcoinStringIdentifier.Validity.kValid],
			// hex public key, compressed (even), 1 extra byte
			["0250863ad64a87ae8a2fe83c1af1a8403cb53f53e486d8511dad8a04887e5b2352cb", FunBitcoinStringIdentifier.Type.kPublickKey, FunBitcoinStringIdentifier.Format.kHex, FunBitcoinStringIdentifier.Validity.kMalformed],
			// hex public key, compressed (odd)
			["0350863ad64a87ae8a2fe83c1af1a8403cb53f53e486d8511dad8a04887e5b2352", FunBitcoinStringIdentifier.Type.kPublickKey, FunBitcoinStringIdentifier.Format.kHex, FunBitcoinStringIdentifier.Validity.kValid],
			// hex public key, compressed (odd), 1 extra byte
			["0350863ad64a87ae8a2fe83c1af1a8403cb53f53e486d8511dad8a04887e5b2352cb", FunBitcoinStringIdentifier.Type.kPublickKey, FunBitcoinStringIdentifier.Format.kHex, FunBitcoinStringIdentifier.Validity.kMalformed],
			// hex private key
			["18E14A7B6A307F426A94F8114701E7C8E774E7F9A47E2C2035DB29A206321725", FunBitcoinStringIdentifier.Type.kPrivateKey, FunBitcoinStringIdentifier.Format.kHex, FunBitcoinStringIdentifier.Validity.kValid],
			// hex private key, possible confusion with uncompressed public key
			["04E14A7B6A307F426A94F8114701E7C8E774E7F9A47E2C2035DB29A206321725", FunBitcoinStringIdentifier.Type.kPrivateKey, FunBitcoinStringIdentifier.Format.kHex, FunBitcoinStringIdentifier.Validity.kValid],
			// hex private key, possible confusion with compressed (even) public key
			["02E14A7B6A307F426A94F8114701E7C8E774E7F9A47E2C2035DB29A206321725", FunBitcoinStringIdentifier.Type.kPrivateKey, FunBitcoinStringIdentifier.Format.kHex, FunBitcoinStringIdentifier.Validity.kValid],
			// hex private key, possible confusion with compressed (odd) public key
			["03E14A7B6A307F426A94F8114701E7C8E774E7F9A47E2C2035DB29A206321725", FunBitcoinStringIdentifier.Type.kPrivateKey, FunBitcoinStringIdentifier.Format.kHex, FunBitcoinStringIdentifier.Validity.kValid],
			// WIF private key (uncompressed)
			["5KN7MzqK5wt2TP1fQCYyHBtDrXdJuXbUzm4A9rKAteGu3Qi5CVR", FunBitcoinStringIdentifier.Type.kPrivateKey, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kValid],
			// WIF private key (uncompressed), byte 0 of checksum incorrect
			["5KN7MzqK5wt2TP1fQCYyHBtDrXdJuXbUzm4A9rKAteGu3QjZBmm", FunBitcoinStringIdentifier.Type.kPrivateKey, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kChecksum],
			// WIF private key (uncompressed), byte 1 of checksum incorrect
			["5KN7MzqK5wt2TP1fQCYyHBtDrXdJuXbUzm4A9rKAteGu3Qi5XyM", FunBitcoinStringIdentifier.Type.kPrivateKey, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kChecksum],
			// WIF private key (uncompressed), byte 2 of checksum incorrect
			["5KN7MzqK5wt2TP1fQCYyHBtDrXdJuXbUzm4A9rKAteGu3Qi5CZq", FunBitcoinStringIdentifier.Type.kPrivateKey, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kChecksum],
			// WIF private key (uncompressed), byte 3 of checksum incorrect
			["5KN7MzqK5wt2TP1fQCYyHBtDrXdJuXbUzm4A9rKAteGu3Qi5CVS", FunBitcoinStringIdentifier.Type.kPrivateKey, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kChecksum],
			// WIF private key (uncompressed), missing last byte
			["yiwTWR61DS9wTjk8yYG1x2du19E7v9igpbFJs9CJbGqW7LKni", FunBitcoinStringIdentifier.Type.kPrivateKey, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kMalformed],
			// WIF private key (uncompressed), 1 extra byte that is 0xCB
			["L44B5gGEpqEDRS9vVPz7QT35jcBG2r3CZwSwQ4fCewXAhZUdf3b6", FunBitcoinStringIdentifier.Type.kPrivateKey, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kMalformed],
			// WIF private key (uncompressed), 1 extra byte that is 0x00
			["L44B5gGEpqEDRS9vVPz7QT35jcBG2r3CZwSwQ4fCewXAhAZtCmBX", FunBitcoinStringIdentifier.Type.kPrivateKey, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kMalformed],
			// WIF private key (uncompressed), 1 extra byte that is 0x02
			["L44B5gGEpqEDRS9vVPz7QT35jcBG2r3CZwSwQ4fCewXAhApUJAMe", FunBitcoinStringIdentifier.Type.kPrivateKey, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kMalformed],
			// WIF private key (compressed)
			["L44B5gGEpqEDRS9vVPz7QT35jcBG2r3CZwSwQ4fCewXAhAhqGVpP", FunBitcoinStringIdentifier.Type.kPrivateKey, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kValid],
			// Script hash
			["3CMNFxN1oHBc4R1EpboAL5yzHGgE611Xou", FunBitcoinStringIdentifier.Type.kScriptHash, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kValid],
			// Script hash (testnet)
			["2N2JD6wb56AfK4tfmM6PwdVmoYk2dCKf4Br", FunBitcoinStringIdentifier.Type.kScriptHash, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kValid],
			// BIP0038, no compression, no EC multiply
			["6PRVWUbkzzsbcVac2qwfssoUJAN1Xhrg6bNk8J7Nzm5H7kxEbn2Nh2ZoGg", FunBitcoinStringIdentifier.Type.kBIP0083EncryptedKey, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kValid],
			// BIP0038, compression, no EC multiply
			["6PYNKZ1EAgYgmQfmNVamxyXVWHzK5s6DGhwP4J5o44cvXdoY7sRzhtpUeo", FunBitcoinStringIdentifier.Type.kBIP0083EncryptedKey, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kValid],
			// BIP0038, EC multiply, no lot/sequence
			["6PfQu77ygVyJLZjfvMLyhLMQbYnu5uguoJJ4kMCLqWwPEdfpwANVS76gTX", FunBitcoinStringIdentifier.Type.kBIP0083EncryptedKey, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kValid],
			// BIP0038, EC multiply, lot/sequence
			["6PgNBNNzDkKdhkT6uJntUXwwzQV8Rr2tZcbkDcuC9DZRsS6AtHts4Ypo1j", FunBitcoinStringIdentifier.Type.kBIP0083EncryptedKey, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kValid],
			// Like BIP0038, but beginning with 0x0141
			["6NTMBywApqoSQj8rxUw77DtPYikwzooAGk9fp568C7vcFz2V1enegpTEe2", FunBitcoinStringIdentifier.Type.kUnknown, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kInvalid],
			// Like BIP0038, but beginning with 0x0144
			["6RMn9TvwMK1v22U6BZxoRBddo3a8bVyhkHptkk9tc3NcqJojn2VpoSKHhW", FunBitcoinStringIdentifier.Type.kUnknown, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kInvalid],
			// BIP0038, 0x0142, missing last byte
			["2DnRasCxHK6aDaD9Pd1c6BbzqkMcvBASdA9YyUtk3fXsn2oVujppsmY39", FunBitcoinStringIdentifier.Type.kBIP0083EncryptedKey, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kMalformed],
			// BIP0038, 0x0142, extra last byte
			["Qmy6q6pRCzSKmf9Kd92JbZE7UkKjLXLFZgiyMCXA5wXt8pzo2Vj51roNRNn", FunBitcoinStringIdentifier.Type.kBIP0083EncryptedKey, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kMalformed],
			// BIP0038, 0x0143, missing last byte
			["2E19LvywsLFDeScCMSN8As1MQFGRV1D3vo8SFPgnwvHyrxw9Rg2b1oFYM", FunBitcoinStringIdentifier.Type.kBIP0083EncryptedKey, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kMalformed],
			// BIP0038, 0x0143, extra last byte
			["QrEuYjLk3pUgPbJwkPkoEeaQSVLUvu7mCszgPdzhRoW9eXJ3R7fed8wNveF", FunBitcoinStringIdentifier.Type.kBIP0083EncryptedKey, FunBitcoinStringIdentifier.Format.kBase58, FunBitcoinStringIdentifier.Validity.kMalformed],
		];
//trace(m_context.getBase58().encode(FunUtils.hexToBytes("")));
		var v = testVectors[x];
//trace(v);
		var si = new FunBitcoinStringIdentifier(m_context, v[0]);
		var v1 : FunBitcoinStringIdentifier.Type = v[1];
		var v2 : FunBitcoinStringIdentifier.Format = v[2];
		var v3 : FunBitcoinStringIdentifier.Validity = v[3];
		assertEquals(v1, si.getType());
		assertEquals(v2, si.getFormat());
		assertEquals(v3, si.getValidity());
		si.clear();
		return testVectors.length;
	}

	public function testX_ValidAddresses(x : Int) : Int
	{
		// Test vectors from https://gitorious.org/bitcoin/bitcoind-stable/commit/d6b13283d19b3229ec1aee62bf7b4747c581ddab
		// Retrieved 2014.11.20
		// TODO: Move the payload and testnet values for addresses and script hashes into other tests.
		var testVectors : Array<Array<Dynamic>> = [
			["1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i", "65a16059864a2fdbc7c99a4723a8395bc6f188eb", FunBitcoinStringIdentifier.Type.kAddress, false],
			["3CMNFxN1oHBc4R1EpboAL5yzHGgE611Xou", "74f209f6ea907e2ea48f74fae05782ae8a665257", FunBitcoinStringIdentifier.Type.kScriptHash, false],
			["mo9ncXisMeAoXwqcV5EWuyncbmCcQN4rVs", "53c0307d6851aa0ce7825ba883c6bd9ad242b486", FunBitcoinStringIdentifier.Type.kAddress, true],
			["2N2JD6wb56AfK4tfmM6PwdVmoYk2dCKf4Br", "6349a418fc4578d10a372b54b45c280cc8c4382f", FunBitcoinStringIdentifier.Type.kScriptHash, true],
			["5Kd3NBUAdUnhyzenEwVLy9pBKxSwXvE9FMPyR4UKZvpe6E3AgLr", null, FunBitcoinStringIdentifier.Type.kPrivateKey, false, false],
			["Kz6UJmQACJmLtaQj5A3JAge4kVTNQ8gbvXuwbmCj7bsaabudb3RD", null, FunBitcoinStringIdentifier.Type.kPrivateKey, false, true],
			["9213qJab2HNEpMpYNBa7wHGFKKbkDn24jpANDs2huN3yi4J11ko", null, FunBitcoinStringIdentifier.Type.kPrivateKey, true, false],
			["cTpB4YiyKiBcPxnefsDpbnDxFDffjqJob8wGCEDXxgQ7zQoMXJdH", null, FunBitcoinStringIdentifier.Type.kPrivateKey, true, true],
			["1Ax4gZtb7gAit2TivwejZHYtNNLT18PUXJ", "6d23156cbbdcc82a5a47eee4c2c7c583c18b6bf4", FunBitcoinStringIdentifier.Type.kAddress, false],
			["3QjYXhTkvuj8qPaXHTTWb5wjXhdsLAAWVy", "fcc5460dd6e2487c7d75b1963625da0e8f4c5975", FunBitcoinStringIdentifier.Type.kScriptHash, false],
			["n3ZddxzLvAY9o7184TB4c6FJasAybsw4HZ", "f1d470f9b02370fdec2e6b708b08ac431bf7a5f7", FunBitcoinStringIdentifier.Type.kAddress, true],
			["2NBFNJTktNa7GZusGbDbGKRZTxdK9VVez3n", "c579342c2c4c9220205e2cdc285617040c924a0a", FunBitcoinStringIdentifier.Type.kScriptHash, true],
			["5K494XZwps2bGyeL71pWid4noiSNA2cfCibrvRWqcHSptoFn7rc", null, FunBitcoinStringIdentifier.Type.kPrivateKey, false, false],
			["L1RrrnXkcKut5DEMwtDthjwRcTTwED36thyL1DebVrKuwvohjMNi", null, FunBitcoinStringIdentifier.Type.kPrivateKey, false, true],
			["93DVKyFYwSN6wEo3E2fCrFPUp17FtrtNi2Lf7n4G3garFb16CRj", null, FunBitcoinStringIdentifier.Type.kPrivateKey, true, false],
			["cTDVKtMGVYWTHCb1AFjmVbEbWjvKpKqKgMaR3QJxToMSQAhmCeTN", null, FunBitcoinStringIdentifier.Type.kPrivateKey, true, true],
			["1C5bSj1iEGUgSTbziymG7Cn18ENQuT36vv", "7987ccaa53d02c8873487ef919677cd3db7a6912", FunBitcoinStringIdentifier.Type.kAddress, false],
			["3AnNxabYGoTxYiTEZwFEnerUoeFXK2Zoks", "63bcc565f9e68ee0189dd5cc67f1b0e5f02f45cb", FunBitcoinStringIdentifier.Type.kScriptHash, false],
			["n3LnJXCqbPjghuVs8ph9CYsAe4Sh4j97wk", "ef66444b5b17f14e8fae6e7e19b045a78c54fd79", FunBitcoinStringIdentifier.Type.kAddress, true],
			["2NB72XtkjpnATMggui83aEtPawyyKvnbX2o", "c3e55fceceaa4391ed2a9677f4a4d34eacd021a0", FunBitcoinStringIdentifier.Type.kScriptHash, true],
			["5KaBW9vNtWNhc3ZEDyNCiXLPdVPHCikRxSBWwV9NrpLLa4LsXi9", null, FunBitcoinStringIdentifier.Type.kPrivateKey, false, false],
			["L1axzbSyynNYA8mCAhzxkipKkfHtAXYF4YQnhSKcLV8YXA874fgT", null, FunBitcoinStringIdentifier.Type.kPrivateKey, false, true],
			["927CnUkUbasYtDwYwVn2j8GdTuACNnKkjZ1rpZd2yBB1CLcnXpo", null, FunBitcoinStringIdentifier.Type.kPrivateKey, true, false],
			["cUcfCMRjiQf85YMzzQEk9d1s5A4K7xL5SmBCLrezqXFuTVefyhY7", null, FunBitcoinStringIdentifier.Type.kPrivateKey, true, true],
			["1Gqk4Tv79P91Cc1STQtU3s1W6277M2CVWu", "adc1cc2081a27206fae25792f28bbc55b831549d", FunBitcoinStringIdentifier.Type.kAddress, false],
			["33vt8ViH5jsr115AGkW6cEmEz9MpvJSwDk", "188f91a931947eddd7432d6e614387e32b244709", FunBitcoinStringIdentifier.Type.kScriptHash, false],
			["mhaMcBxNh5cqXm4aTQ6EcVbKtfL6LGyK2H", "1694f5bc1a7295b600f40018a618a6ea48eeb498", FunBitcoinStringIdentifier.Type.kAddress, true],
			["2MxgPqX1iThW3oZVk9KoFcE5M4JpiETssVN", "3b9b3fd7a50d4f08d1a5b0f62f644fa7115ae2f3", FunBitcoinStringIdentifier.Type.kScriptHash, true],
			["5HtH6GdcwCJA4ggWEL1B3jzBBUB8HPiBi9SBc5h9i4Wk4PSeApR", null, FunBitcoinStringIdentifier.Type.kPrivateKey, false, false],
			["L2xSYmMeVo3Zek3ZTsv9xUrXVAmrWxJ8Ua4cw8pkfbQhcEFhkXT8", null, FunBitcoinStringIdentifier.Type.kPrivateKey, false, true],
			["92xFEve1Z9N8Z641KQQS7ByCSb8kGjsDzw6fAmjHN1LZGKQXyMq", null, FunBitcoinStringIdentifier.Type.kPrivateKey, true, false],
			["cVM65tdYu1YK37tNoAyGoJTR13VBYFva1vg9FLuPAsJijGvG6NEA", null, FunBitcoinStringIdentifier.Type.kPrivateKey, true, true],
			["1JwMWBVLtiqtscbaRHai4pqHokhFCbtoB4", "c4c1b72491ede1eedaca00618407ee0b772cad0d", FunBitcoinStringIdentifier.Type.kAddress, false],
			["3QCzvfL4ZRvmJFiWWBVwxfdaNBT8EtxB5y", "f6fe69bcb548a829cce4c57bf6fff8af3a5981f9", FunBitcoinStringIdentifier.Type.kScriptHash, false],
			["mizXiucXRCsEriQCHUkCqef9ph9qtPbZZ6", "261f83568a098a8638844bd7aeca039d5f2352c0", FunBitcoinStringIdentifier.Type.kAddress, true],
			["2NEWDzHWwY5ZZp8CQWbB7ouNMLqCia6YRda", "e930e1834a4d234702773951d627cce82fbb5d2e", FunBitcoinStringIdentifier.Type.kScriptHash, true],
			["5KQmDryMNDcisTzRp3zEq9e4awRmJrEVU1j5vFRTKpRNYPqYrMg", null, FunBitcoinStringIdentifier.Type.kPrivateKey, false, false],
			["L39Fy7AC2Hhj95gh3Yb2AU5YHh1mQSAHgpNixvm27poizcJyLtUi", null, FunBitcoinStringIdentifier.Type.kPrivateKey, false, true],
			["91cTVUcgydqyZLgaANpf1fvL55FH53QMm4BsnCADVNYuWuqdVys", null, FunBitcoinStringIdentifier.Type.kPrivateKey, true, false],
			["cQspfSzsgLeiJGB2u8vrAiWpCU4MxUT6JseWo2SjXy4Qbzn2fwDw", null, FunBitcoinStringIdentifier.Type.kPrivateKey, true, true],
			["19dcawoKcZdQz365WpXWMhX6QCUpR9SY4r", "5eadaf9bb7121f0f192561a5a62f5e5f54210292", FunBitcoinStringIdentifier.Type.kAddress, false],
			["37Sp6Rv3y4kVd1nQ1JV5pfqXccHNyZm1x3", "3f210e7277c899c3a155cc1c90f4106cbddeec6e", FunBitcoinStringIdentifier.Type.kScriptHash, false],
			["myoqcgYiehufrsnnkqdqbp69dddVDMopJu", "c8a3c2a09a298592c3e180f02487cd91ba3400b5", FunBitcoinStringIdentifier.Type.kAddress, true],
			["2N7FuwuUuoTBrDFdrAZ9KxBmtqMLxce9i1C", "99b31df7c9068d1481b596578ddbb4d3bd90baeb", FunBitcoinStringIdentifier.Type.kScriptHash, true],
			["5KL6zEaMtPRXZKo1bbMq7JDjjo1bJuQcsgL33je3oY8uSJCR5b4", null, FunBitcoinStringIdentifier.Type.kPrivateKey, false, false],
			["KwV9KAfwbwt51veZWNscRTeZs9CKpojyu1MsPnaKTF5kz69H1UN2", null, FunBitcoinStringIdentifier.Type.kPrivateKey, false, true],
			["93N87D6uxSBzwXvpokpzg8FFmfQPmvX4xHoWQe3pLdYpbiwT5YV", null, FunBitcoinStringIdentifier.Type.kPrivateKey, true, false],
			["cMxXusSihaX58wpJ3tNuuUcZEQGt6DKJ1wEpxys88FFaQCYjku9h", null, FunBitcoinStringIdentifier.Type.kPrivateKey, true, true],
			["13p1ijLwsnrcuyqcTvJXkq2ASdXqcnEBLE", "1ed467017f043e91ed4c44b4e8dd674db211c4e6", FunBitcoinStringIdentifier.Type.kAddress, false],
			["3ALJH9Y951VCGcVZYAdpA3KchoP9McEj1G", "5ece0cadddc415b1980f001785947120acdb36fc", FunBitcoinStringIdentifier.Type.kScriptHash, false],
		];
		var v = testVectors[x];
		var si = new FunBitcoinStringIdentifier(m_context, v[0]);
		assertTrue(si.isValid());
		assertEquals(v[2], si.getType());
		return testVectors.length;
	}

	public function testX_InvalidAddresses(x : Int) : Int
	{
		// Test vectors from https://gitorious.org/bitcoin/bitcoind-stable/commit/d6b13283d19b3229ec1aee62bf7b4747c581ddab
		// Retrieved 2014.11.20
		var testString =
"|
x|
37qgekLpCCHrQuSjvX3fs496FWTGsHFHizjJAs6NPcR47aefnnCWECAhHV6E3g4YN7u7Yuwod5Y|
dzb7VV1Ui55BARxv7ATxAtCUeJsANKovDGWFVgpTbhq9gvPqP3yv|
MuNu7ZAEDFiHthiunm7dPjwKqrVNCM3mAz6rP9zFveQu14YA8CxExSJTHcVP9DErn6u84E6Ej7S|
rPpQpYknyNQ5AEHuY6H8ijJJrYc2nDKKk9jjmKEXsWzyAQcFGpDLU2Zvsmoi8JLR7hAwoy3RQWf|
4Uc3FmN6NQ6zLBK5QQBXRBUREaaHwCZYsGCueHauuDmJpZKn6jkEskMB2Zi2CNgtb5r6epWEFfUJq|
7aQgR5DFQ25vyXmqZAWmnVCjL3PkBcdVkBUpjrjMTcghHx3E8wb|
17QpPprjeg69fW1DV8DcYYCKvWjYhXvWkov6MJ1iTTvMFj6weAqW7wybZeH57WTNxXVCRH4veVs|
KxuACDviz8Xvpn1xAh9MfopySZNuyajYMZWz16Dv2mHHryznWUp3|
7nK3GSmqdXJQtdohvGfJ7KsSmn3TmGqExug49583bDAL91pVSGq5xS9SHoAYL3Wv3ijKTit65th|
cTivdBmq7bay3RFGEBBuNfMh2P1pDCgRYN2Wbxmgwr4ki3jNUL2va|
gjMV4vjNjyMrna4fsAr8bWxAbwtmMUBXJS3zL4NJt5qjozpbQLmAfK1uA3CquSqsZQMpoD1g2nk|
emXm1naBMoVzPjbk7xpeTVMFy4oDEe25UmoyGgKEB1gGWsK8kRGs|
7VThQnNRj1o3Zyvc7XHPRrjDf8j2oivPTeDXnRPYWeYGE4pXeRJDZgf28ppti5hsHWXS2GSobdqyo|
1G9u6oCVCPh2o8m3t55ACiYvG1y5BHewUkDSdiQarDcYXXhFHYdzMdYfUAhfxn5vNZBwpgUNpso|
31QQ7ZMLkScDiB4VyZjuptr7AEc9j1SjstF7pRoLhHTGkW4Q2y9XELobQmhhWxeRvqcukGd1XCq|
DHqKSnpxa8ZdQyH8keAhvLTrfkyBMQxqngcQA5N8LQ9KVt25kmGN|
2LUHcJPbwLCy9GLH1qXmfmAwvadWw4bp4PCpDfduLqV17s6iDcy1imUwhQJhAoNoN1XNmweiJP4i|
7USRzBXAnmck8fX9HmW7RAb4qt92VFX6soCnts9s74wxm4gguVhtG5of8fZGbNPJA83irHVY6bCos|
1DGezo7BfVebZxAbNT3XGujdeHyNNBF3vnficYoTSp4PfK2QaML9bHzAMxke3wdKdHYWmsMTJVu|
2D12DqDZKwCxxkzs1ZATJWvgJGhQ4cFi3WrizQ5zLAyhN5HxuAJ1yMYaJp8GuYsTLLxTAz6otCfb|
8AFJzuTujXjw1Z6M3fWhQ1ujDW7zsV4ePeVjVo7D1egERqSW9nZ|
163Q17qLbTCue8YY3AvjpUhotuaodLm2uqMhpYirsKjVqnxJRWTEoywMVY3NbBAHuhAJ2cF9GAZ|
2MnmgiRH4eGLyLc9eAqStzk7dFgBjFtUCtu|
461QQ2sYWxU7H2PV4oBwJGNch8XVTYYbZxU|
2UCtv53VttmQYkVU4VMtXB31REvQg4ABzs41AEKZ8UcB7DAfVzdkV9JDErwGwyj5AUHLkmgZeobs|
cSNjAsnhgtiFMi6MtfvgscMB2Cbhn2v1FUYfviJ1CdjfidvmeW6mn|
gmsow2Y6EWAFDFE1CE4Hd3Tpu2BvfmBfG1SXsuRARbnt1WjkZnFh1qGTiptWWbjsq2Q6qvpgJVj|
nksUKSkzS76v8EsSgozXGMoQFiCoCHzCVajFKAXqzK5on9ZJYVHMD5CKwgmX3S3c7M1U3xabUny|
L3favK1UzFGgdzYBF2oBT5tbayCo4vtVBLJhg2iYuMeePxWG8SQc|
7VxLxGGtYT6N99GdEfi6xz56xdQ8nP2dG1CavuXx7Rf2PrvNMTBNevjkfgs9JmkcGm6EXpj8ipyPZ|
2mbZwFXF6cxShaCo2czTRB62WTx9LxhTtpP|
dB7cwYdcPSgiyAwKWL3JwCVwSk6epU2txw|
HPhFUhUAh8ZQQisH8QQWafAxtQYju3SFTX|
4ctAH6AkHzq5ioiM1m9T3E2hiYEev5mTsB|
Hn1uFi4dNexWrqARpjMqgT6cX1UsNPuV3cHdGg9ExyXw8HTKadbktRDtdeVmY3M1BxJStiL4vjJ|
Sq3fDbvutABmnAHHExJDgPLQn44KnNC7UsXuT7KZecpaYDMU9Txs|
6TqWyrqdgUEYDQU1aChMuFMMEimHX44qHFzCUgGfqxGgZNMUVWJ|
giqJo7oWqFxNKWyrgcBxAVHXnjJ1t6cGoEffce5Y1y7u649Noj5wJ4mmiUAKEVVrYAGg2KPB3Y4|
cNzHY5e8vcmM3QVJUcjCyiKMYfeYvyueq5qCMV3kqcySoLyGLYUK|
37uTe568EYc9WLoHEd9jXEvUiWbq5LFLscNyqvAzLU5vBArUJA6eydkLmnMwJDjkL5kXc2VK7ig|
EsYbG4tWWWY45G31nox838qNdzksbPySWc|
nbuzhfwMoNzA3PaFnyLcRxE9bTJPDkjZ6Rf6Y6o2ckXZfzZzXBT|
cQN9PoxZeCWK1x56xnz6QYAsvR11XAce3Ehp3gMUdfSQ53Y2mPzx|
1Gm3N3rkef6iMbx4voBzaxtXcmmiMTqZPhcuAepRzYUJQW4qRpEnHvMojzof42hjFRf8PE2jPde|
2TAq2tuN6x6m233bpT7yqdYQPELdTDJn1eU|
ntEtnnGhqPii4joABvBtSEJG6BxjT2tUZqE8PcVYgk3RHpgxgHDCQxNbLJf7ardf1dDk2oCQ7Cf|
Ky1YjoZNgQ196HJV3HpdkecfhRBmRZdMJk89Hi5KGfpfPwS2bUbfd|
2A1q1YsMZowabbvta7kTy2Fd6qN4r5ZCeG3qLpvZBMzCixMUdkN2Y4dHB1wPsZAeVXUGD83MfRED";
		var testVectors = testString.split("|");
		var v = StringTools.trim(testVectors[x]);
		var si = new FunBitcoinStringIdentifier(m_context, v);
		assertFalse(si.isValid());
		return testVectors.length;
	}

	public function _testFindHexAndBase58Match() : Void
	{
		var base58 = m_context.getBase58();
		var alpha = "123456789ABCDEFabcdef";
		var digits = 10;
		while (true)
		{
			trace(digits + " digits");
			var values = Bytes.alloc(digits);
			values.fill(0, values.length, 0);

			while (true)
			{
				var sb = new StringBuf();
				for (j in 0 ... digits)
				{
					sb.addChar(alpha.charCodeAt(values.get(j)));
				}
				var t = sb.toString();
//trace(t);
				try
				{
					var v = base58.decode(t);
					trace("* " + t);
				}
				catch (e : Dynamic)
				{
					//
				}

				var j = 0;
				while (j < digits)
				{
					var x = values.get(j) + 1;
					if (x >= alpha.length)
					{
						values.set(j, 0);
					}
					else
					{
						values.set(j, x);
						break;
					}
					++j;
				}
				if (j >= digits)
				{
					break;
				}
			}

			digits += 2;
		}
	}

	private var m_context = new FunBitcoinContext();
}
