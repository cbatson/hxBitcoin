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
import com.fundoware.engine.core.FunIClearable;
import com.fundoware.engine.core.FunUtils;
import com.fundoware.engine.crypto.FunCryptoUtils;
import haxe.io.Bytes;

@:enum abstract Type(Int)
{
	var kUnknown				= 0;
	var kPrivateKey				= 1;
	var kPublickKey				= 2;
	var kAddress				= 3;
	var kScriptHash				= 4;
	var kBIP0083EncryptedKey	= 5;
}

@:enum abstract Format(Int)
{
	var kUnknown	= 0;
	var kHex		= 1;
	var kBase58		= 2;
}

@:enum abstract Validity(Int)
{
	var kValid		= 0;	// syntactically valid
	var kInvalid	= 1;	// invalid
	var kChecksum	= 2;	// invalid due to a checksum mismatch
	var kMalformed	= 3;	// invalid due to mal-formed payload
}

class FunBitcoinStringIdentifier implements FunIClearable
{
	public function new(context : FunBitcoinContext, value : String) : Void
	{
		m_context = context;
		if ((value != null) && (value.length > 0))
		{
			var b58 = _fromBase58(value);
			if (!isValid())
			{
				var hex = _fromHex(value);
				if (!isValid())
				{
					// If both base58 and hex interpretations are valid,
					// then it's ambiguous.
					if (b58 && hex)
					{
						m_type = Type.kUnknown;
						m_format = Format.kUnknown;
						m_validity = Validity.kInvalid;
					}
				}
			}
		}
	}

	public inline function isValid() : Bool
	{
		return getValidity() == Validity.kValid;
	}

	public inline function getValidity() : Validity
	{
		return m_validity;
	}

	public inline function getType() : Type
	{
		return m_type;
	}

	public inline function getFormat() : Format
	{
		return m_format;
	}

	public function clear() : Void
	{
		FunCryptoUtils.clearBytes(m_data);
		m_context.getBase58().clear();
		m_context.getHash256().clear();
	}

	private function _fromHex(value : String) : Bool
	{
		try
		{
			m_data = FunUtils.hexToBytes(value);
		}
		catch (e : Dynamic)
		{
			return false;
		}
		m_format = Format.kHex;
		m_length = m_data.length;
		if (m_length == 32)
		{
			m_type = Type.kPrivateKey;
			m_validity = Validity.kValid;
			return true;
		}
		var version = m_data.get(0);
		if ((2 <= version) && (version <= 4))
		{
			m_type = Type.kPublickKey;
			var el = (version == 4) ? 65 : 33;
			m_validity = (el == m_length) ? Validity.kValid : Validity.kMalformed;
			return true;
		}
		return true;
	}

	private function _fromBase58(value : String) : Bool
	{
		try
		{
			m_data = FunCryptoUtils.safeAlloc(m_data, value.length);
			m_length = m_context.getBase58().decodeNoChecksum(value, m_data);
		}
		catch (e : Dynamic)
		{
			return false;
		}

		m_format = Format.kBase58;

		if (m_length < 5)
		{
			m_validity = Validity.kInvalid;
			return true;
		}

		var version = m_data.get(0);
		if ((version == 0) || (version == 111))
		{
			m_type = Type.kAddress;
			m_validity = (m_length == 25) ? Validity.kValid : Validity.kMalformed;
		}
		else if ((version == 5) || (version == 196))
		{
			m_type = Type.kScriptHash;
			m_validity = (m_length == 25) ? Validity.kValid : Validity.kMalformed;
		}
		else if ((version == 128) || (version == 239))
		{
			m_type = Type.kPrivateKey;
			if ((m_length < 37) || (m_length > 38))
			{
				m_validity = Validity.kMalformed;
			}
			else if ((m_length == 38) && (m_data.get(33) != 1))
			{
				m_validity = Validity.kMalformed;
			}
			else
			{
				m_validity = Validity.kValid;
			}
		}
		else if ((m_length >= 6) && (version == 1) && ((m_data.get(1) == 0x42) || (m_data.get(1) == 0x43)))
		{
			m_type = Type.kBIP0083EncryptedKey;
			m_validity = (m_length == 43) ? Validity.kValid : Validity.kMalformed;
		}

		var hash = m_context.getHash256();
		m_digest = FunCryptoUtils.safeAlloc(m_digest, hash.getDigestSize());
		hash.reset();
		hash.addBytes(m_data, 0, m_length - 4);
		hash.finish(m_digest, 0);

		if ((m_data.get(m_length - 4) != m_digest.get(0)) ||
			(m_data.get(m_length - 3) != m_digest.get(1)) ||
			(m_data.get(m_length - 2) != m_digest.get(2)) ||
			(m_data.get(m_length - 1) != m_digest.get(3)))
		{
			m_validity = Validity.kChecksum;
		}

		return true;
	}

	private var m_context : FunBitcoinContext;
	private var m_type = Type.kUnknown;
	private var m_format = Format.kUnknown;
	private var m_validity = Validity.kInvalid;
	private var m_data : Bytes;
	private var m_length : Int;
	private var m_digest : Bytes;
}
