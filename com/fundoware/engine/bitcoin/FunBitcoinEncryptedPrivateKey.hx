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
import com.fundoware.engine.bigint.FunBigIntArithmetic;
import com.fundoware.engine.bigint.FunBigIntTools;
import com.fundoware.engine.bigint.FunMutableBigInt;
import com.fundoware.engine.core.FunIClearable;
import com.fundoware.engine.crypto.ec.FunIEllipticCurvePoint;
import com.fundoware.engine.crypto.FunCryptoUtils;
import com.fundoware.engine.crypto.hash.FunHashTools;
import com.fundoware.engine.exception.FunExceptions;
import haxe.io.Bytes;

// Implements BIP0038
// https://github.com/bitcoin/bips/blob/master/bip-0038.mediawiki
// Retrieved 2014.11.24
class FunBitcoinEncryptedPrivateKey implements FunIClearable
{
	public static function fromString(context : FunBitcoinContext, input : String) : FunBitcoinEncryptedPrivateKey
	{
		var result = new FunBitcoinEncryptedPrivateKey(context);
		try
		{
			result._fromString(input);
		}
		catch (e : Dynamic)
		{
			result.clear();
			throw FunExceptions.rethrow(e);
		}
		return result;
	}

	public static function encryptString(context : FunBitcoinContext, input : FunBitcoinPrivateKey, password : String) : FunBitcoinEncryptedPrivateKey
	{
		var P = stringPasswordToBytes(context, password);
		var result : FunBitcoinEncryptedPrivateKey;
		try
		{
			result = encryptBytes(context, input, P);
		}
		catch (e : Dynamic)
		{
			FunCryptoUtils.clearBytes(P);
			throw FunExceptions.rethrow(e);
		}
		FunCryptoUtils.clearBytes(P);
		return result;
	}

	public static function encryptBytes(context : FunBitcoinContext, input : FunBitcoinPrivateKey, password : Bytes) : FunBitcoinEncryptedPrivateKey
	{
		if (password.length < 1)
		{
			throw FunExceptions.FUN_INVALID_ARGUMENT;
		}
		var result = new FunBitcoinEncryptedPrivateKey(context);
		try
		{
			result._fromKey(input, password);
		}
		catch (e : Dynamic)
		{
			result.clear();
			throw FunExceptions.rethrow(e);
		}
		return result;
	}

	public function toWIF() : String
	{
		return m_context.getBase58().encode(m_data);
	}

	public function decryptString(password : String) : FunBitcoinPrivateKey
	{
		var P = stringPasswordToBytes(m_context, password);
		var result : FunBitcoinPrivateKey;
		try
		{
			result = decryptBytes(P);
		}
		catch (e : Dynamic)
		{
			FunCryptoUtils.clearBytes(P);
			throw FunExceptions.rethrow(e);
		}
		FunCryptoUtils.clearBytes(P);
		return result;
	}

	public function decryptBytes(password : Bytes) : FunBitcoinPrivateKey
	{
		return isECMult() ? _decryptEC(password) : _decryptNoEC(password);
	}

	public function getPassphraseCodeString(password : String) : String
	{
		var P = stringPasswordToBytes(m_context, password);
		var result : String;
		try
		{
			result = getPassphraseCodeBytes(P);
		}
		catch (e : Dynamic)
		{
			FunCryptoUtils.clearBytes(P);
			throw FunExceptions.rethrow(e);
		}
		FunCryptoUtils.clearBytes(P);
		return result;
	}

	public function getPassphraseCodeBytes(password : Bytes) : String
	{
		if (!isECMult())
		{
			throw FunExceptions.FUN_INVALID_OPERATION;
		}
		FunCryptoUtils.clearBytes(m_private);
		m_private = getPassphraseBytes(password);
		var pp = Bytes.alloc(49);
		pp.set(0, 0x2C);
		pp.set(1, 0xE9);
		pp.set(2, 0xB3);
		pp.set(3, 0xE1);
		pp.set(4, 0xFF);
		pp.set(5, 0x39);
		pp.set(6, 0xE2);
		pp.set(7, hasLot() ? 0x51 : 0x53);
		pp.blit(8, m_data, 7, 8);
		pp.blit(16, m_private, 0, 33);
		var ppStr = m_context.getBase58().encode(pp);
		FunCryptoUtils.clearBytes(pp);
		return ppStr;
	}

	private function getPassphraseBytes(password : Bytes) : Bytes
	{
		var salt : Bytes;
		if (hasLot())
		{
			m_salt4 = FunCryptoUtils.safeAlloc(m_salt4, 4);
			m_salt4.blit(0, m_data, 7, 4);
			salt = m_salt4;
		}
		else
		{
			m_salt8 = FunCryptoUtils.safeAlloc(m_salt8, 8);
			m_salt8.blit(0, m_data, 7, 8);
			salt = m_salt8;
		}
		m_context.getScrypt_16384_8_8().run(password, salt, 1, 32, m_work);	// m_work = prefactor

		if (hasLot())
		{
			var hash = m_context.getHash256();
			hash.reset();
			hash.addBytes(m_work, 0, 32);
			hash.addBytes(m_data, 7, 8);
			hash.finish(m_work, 0);		// m_work = passfactor
		}

		if (FunBigIntTools.isNull(m_int1))
		{
			m_int1 = 0;
		}
		m_int1.setFromBigEndianBytesUnsigned(m_work, 0, 32);		// m_int = passfactor
		m_context.getCurve().pointMultiply(m_point, m_context.getCurve().get_G(), m_int1);	// m_point = passpoint
		return FunBitcoinPublicKey.fromPoint(m_context, m_point, true).toBytes();	// m_private = passpoint
	}

	private function _decryptEC(password : Bytes) : FunBitcoinPrivateKey
	{
		FunCryptoUtils.clearBytes(m_private);
		m_private = getPassphraseBytes(password);	// m_private = passpoint

		// Tricky: Code below relies on m_int1 having been set to
		// passfactor, which is done in getPassphraseBytes().

		m_salt12 = FunCryptoUtils.safeAlloc(m_salt12, 12);
		m_salt12.blit(0, m_data, 3, 12);
		m_context.getScrypt_1024_1_1().run(m_private, m_salt12, 1, 64, m_work);		// m_work = derivedhalf1 + derivedhalf2
		m_key.blit(0, m_work, 32, 32);	// m_key = derivedhalf2
		var aes = m_context.getAES();
		aes.setKey(m_key);
		aes.decrypt(m_data, 23, m_private, 8);
		FunCryptoUtils.XOR(m_private, 8, m_private, 8, m_work, 16, 16);
		m_private.blit(0, m_data, 15, 8);
		aes.decrypt(m_private, 0, m_private, 0);
		FunCryptoUtils.XOR(m_private, 0, m_private, 0, m_work, 0, 16);	// m_private = seedb

		var hash = m_context.getHash256();
		hash.reset();
		hash.addBytes(m_private, 0, 24);
		hash.finish(m_work, 0);		// m_work = factorb

		var field = m_context.getCurve().getField();
		if (FunBigIntTools.isNull(m_int2))
		{
			m_int2 = 0;
			m_int3 = 0;
			m_int4 = 0;
		}
		m_int2.setFromBigEndianBytesUnsigned(m_work, 0, 32);	// m_int2 = factorb
		FunBigIntArithmetic.multiply(m_int3, m_int1, m_int2);
		FunBigIntArithmetic.divide(m_int3, m_context.getCurve().get_order(), m_int1, m_int2, m_int4);
		var privKey = FunBitcoinPrivateKey.fromValue(m_context, m_int2, isCompressed());
		return _decryptFinish(privKey);
	}

	private function _decryptNoEC(password : Bytes) : FunBitcoinPrivateKey
	{
		m_salt4 = FunCryptoUtils.safeAlloc(m_salt4, 4);
		m_salt4.blit(0, m_data, 3, 4);
		m_context.getScrypt_16384_8_8().run(password, m_salt4, 1, 64, m_work);

		m_private = FunCryptoUtils.safeAlloc(m_private, 32);

		m_key.blit(0, m_work, 32, 32);

		var aes = m_context.getAES();
		aes.setKey(m_key);
		aes.decrypt(m_data, 7, m_private, 0);
		aes.decrypt(m_data, 23, m_private, 16);

		FunCryptoUtils.XOR(m_private, 0, m_private, 0, m_work, 0, 32);

		var privKey = FunBitcoinPrivateKey.fromBytes(m_context, m_private, isCompressed());
		return _decryptFinish(privKey);
	}

	private function _decryptFinish(privKey : FunBitcoinPrivateKey) : FunBitcoinPrivateKey
	{
		var address = privKey.toAddress();
		var hash = m_context.getHash256();
		hash.reset();
		FunHashTools.AddString(hash, address);
		hash.finish(m_work, 0);

		if (
			(m_work.get(0) != m_data.get(3)) ||
			(m_work.get(1) != m_data.get(4)) ||
			(m_work.get(2) != m_data.get(5)) ||
			(m_work.get(3) != m_data.get(6))
		) {
			privKey.clear();
			throw FunExceptions.FUN_CHECKSUM_MISMATCH;
		}
		return privKey;
	}

	public function clear() : Void
	{
		_clear();
		FunCryptoUtils.clearBytes(m_data);
		m_data = null;
	}

	private function _clear() : Void
	{
		FunCryptoUtils.clearBytes(m_private);
		FunCryptoUtils.clearBytes(m_key);
		FunCryptoUtils.clearBytes(m_work);
		FunCryptoUtils.clearBytes(m_salt4);
		FunCryptoUtils.clearBytes(m_salt8);
		FunCryptoUtils.clearBytes(m_salt12);
		if (!FunBigIntTools.isNull(m_int1))
		{
			m_int1.clear();
		}
		if (!FunBigIntTools.isNull(m_int2))
		{
			m_int2.clear();
			m_int3.clear();
			m_int4.clear();
		}
		m_context.getBase58().clear();
		m_context.getScrypt_16384_8_8().clear();
		m_context.getScrypt_1024_1_1().clear();
		m_context.getAES().clear();
	}

	private function new(context : FunBitcoinContext)
	{
		if (context == null)
		{
			throw FunExceptions.FUN_NULL_ARGUMENT;
		}
		m_context = context;
		m_work = Bytes.alloc(64);
		m_key = Bytes.alloc(32);
		m_point = m_context.getCurve().newInfinity();
	}

	private function _fromString(input : String) : Void
	{
		m_data = m_context.getBase58().decode(input);
		if (m_data.length < 2)
		{
			throw FunExceptions.FUN_INVALID_ARGUMENT;
		}
		if (m_data.get(0) != 0x01)
		{
			throw FunExceptions.FUN_INVALID_ARGUMENT;
		}
		if ((m_data.get(1) != 0x42) && (m_data.get(1) != 0x43))
		{
			throw FunExceptions.FUN_INVALID_ARGUMENT;
		}
		m_ecMult = (m_data.get(1) == 0x43);
		if (m_data.length != 39)
		{
			throw FunExceptions.FUN_INVALID_ARGUMENT;
		}
	}

	private function _fromKey(input : FunBitcoinPrivateKey, password : Bytes) : Void
	{
		var address = input.toAddress();
		var hash = m_context.getHash256();
		hash.reset();
		FunHashTools.AddString(hash, address);
		hash.finish(m_work, 0);
		m_salt4 = FunCryptoUtils.safeAlloc(m_salt4, 4);
		m_salt4.blit(0, m_work, 0, 4);

		m_context.getScrypt_16384_8_8().run(password, m_salt4, 1, 64, m_work);
		m_key.blit(0, m_work, 32, 32);

		FunCryptoUtils.clearBytes(m_private);
		m_private = input.toBytes();
		FunCryptoUtils.XOR(m_private, 0, m_private, 0, m_work, 0, 32);

		var aes = m_context.getAES();
		aes.setKey(m_key);
		aes.encrypt(m_private, 0, m_work, 0);
		aes.encrypt(m_private, 16, m_work, 16);

		m_data = Bytes.alloc(39);
		m_data.set(0, 0x01);
		m_data.set(1, 0x42);
		var flags : Int = 0xc0;
		flags |= input.isCompressed() ? 0x20 : 0x00;
		m_data.set(2, flags);
		m_data.blit(3, m_salt4, 0, 4);
		m_data.blit(7, m_work, 0, 32);

		_clear();
	}

	private inline function isCompressed() : Bool
	{
		return (m_data.get(2) & 0x20) != 0;
	}

	private inline function isECMult() : Bool
	{
		return m_data.get(1) == 0x43;
	}

	private inline function hasLot() : Bool
	{
		return (m_data.get(2) & 0x04) != 0;
	}

	private static inline function stringPasswordToBytes(context : FunBitcoinContext, password : String) : Bytes
	{
		return Bytes.ofString(context.getUnicode().toNFC(password));	// TODO: NFC normalization may "leak" password
	}

	private var m_context : FunBitcoinContext;
	private var m_data : Bytes;
	private var m_work : Bytes;
	private var m_key : Bytes;
	private var m_salt4 : Bytes;
	private var m_salt8 : Bytes;
	private var m_salt12 : Bytes;
	private var m_private : Bytes;
	private var m_point : FunIEllipticCurvePoint;
	private var m_int1 : FunMutableBigInt;
	private var m_int2 : FunMutableBigInt;
	private var m_int3 : FunMutableBigInt;
	private var m_int4 : FunMutableBigInt;
	private var m_ecMult : Bool;
}
