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

import com.fundoware.engine.crypto.aes.FunAES;
import com.fundoware.engine.crypto.ec.FunEllipticCurves;
import com.fundoware.engine.crypto.ec.FunIEllipticCurve;
import com.fundoware.engine.crypto.hash.FunRIPEMD160;
import com.fundoware.engine.crypto.hash.FunSHA2_256;
import com.fundoware.engine.crypto.hmac.FunHMAC_SHA256;
import com.fundoware.engine.crypto.pbe.FunPBKDF2_HMAC_SHA256;
import com.fundoware.engine.crypto.scrypt.FunScrypt;
import com.fundoware.engine.test.FunRuntimeTests;
import com.fundoware.engine.unicode.FunUnicodeNormalization;

class FunBitcoinContext
{
	public function getCurve() : FunIEllipticCurve
	{
		if (m_curve == null)
		{
			m_curve = FunEllipticCurves.newSecp256k1();
		}
		return m_curve;
	}

	public function getHash256() : FunBitcoinHash256
	{
		if (m_hash256 == null)
		{
			m_hash256 = new FunBitcoinHash256(getSHA256());
		}
		return m_hash256;
	}

	public function getHash160() : FunBitcoinHash160
	{
		if (m_hash160 == null)
		{
			m_hash160 = new FunBitcoinHash160(getSHA256(), getRIPEMD160());
		}
		return m_hash160;
	}

	public function getBase58() : FunBase58Check
	{
		if (m_base58 == null)
		{
			m_base58 = new FunBase58Check(getHash256());
		}
		return m_base58;
	}

	public function getScrypt_16384_8_8() : FunScrypt
	{
		if (m_scrypt_16384_8_8 == null)
		{
			m_scrypt_16384_8_8 = new FunScrypt(16384, 8, 8, getPBKDF2_HMAC_SHA256());
		}
		return m_scrypt_16384_8_8;
	}

	public function getScrypt_1024_1_1() : FunScrypt
	{
		if (m_scrypt_1024_1_1 == null)
		{
			m_scrypt_1024_1_1 = new FunScrypt(1024, 1, 1, getPBKDF2_HMAC_SHA256());
		}
		return m_scrypt_1024_1_1;
	}

	public function getAES() : FunAES
	{
		if (m_aes == null)
		{
			m_aes = new FunAES();
		}
		return m_aes;
	}

	public function getUnicode() : FunUnicodeNormalization
	{
		if (m_unicode == null)
		{
			m_unicode = new FunUnicodeNormalization();
		}
		return m_unicode;
	}

	private function getSHA256() : FunSHA2_256
	{
		if (m_sha256 == null)
		{
			m_sha256 = new FunSHA2_256();
		}
		return m_sha256;
	}

	private function getRIPEMD160() : FunRIPEMD160
	{
		if (m_ripemd160 == null)
		{
			m_ripemd160 = new FunRIPEMD160();
		}
		return m_ripemd160;
	}

	private function getPBKDF2_HMAC_SHA256() : FunPBKDF2_HMAC_SHA256
	{
		if (m_kdf == null)
		{
			m_kdf = new FunPBKDF2_HMAC_SHA256(getHMAC_SHA256());
		}
		return m_kdf;
	}

	private function getHMAC_SHA256() : FunHMAC_SHA256
	{
		if (m_hmac == null)
		{
			m_hmac = new FunHMAC_SHA256(getSHA256());
		}
		return m_hmac;
	}

	public function new(curve : FunIEllipticCurve = null, sha256 : FunSHA2_256 = null, ripemd160 : FunRIPEMD160 = null, base58 : FunBase58Check = null) : Void
	{
		FunRuntimeTests.run();
		m_curve = curve;
		m_sha256 = sha256;
		m_ripemd160 = ripemd160;
		m_base58 = base58;
	}

	private var m_sha256 : FunSHA2_256;
	private var m_ripemd160 : FunRIPEMD160;
	private var m_curve : FunIEllipticCurve;
	private var m_hash256 : FunBitcoinHash256;
	private var m_hash160 : FunBitcoinHash160;
	private var m_base58 : FunBase58Check;
	private var m_scrypt_16384_8_8 : FunScrypt;
	private var m_scrypt_1024_1_1 : FunScrypt;
	private var m_kdf : FunPBKDF2_HMAC_SHA256;
	private var m_hmac : FunHMAC_SHA256;
	private var m_aes : FunAES;
	private var m_unicode : FunUnicodeNormalization;
}
