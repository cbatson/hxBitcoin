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
import com.fundoware.engine.bigint.FunBigIntTools;
import com.fundoware.engine.bigint.FunMutableBigInt;
import com.fundoware.engine.core.FunIClearable;
import com.fundoware.engine.crypto.ec.FunIEllipticCurve;
import com.fundoware.engine.crypto.FunCryptoUtils;
import com.fundoware.engine.exception.FunExceptions;
import com.fundoware.engine.math.FunInteger;
import haxe.io.Bytes;

class FunBitcoinPrivateKey implements FunIClearable
{
	public static function fromString(context : FunBitcoinContext, value : String, allowTestnet : Bool = false) : FunBitcoinPrivateKey
	{
		var result = new FunBitcoinPrivateKey(context);
		result._fromWIF(value, allowTestnet);
		return result;
	}

	public static function fromBytes(context : FunBitcoinContext, value : Bytes, compress : Bool = true, testnet : Bool = false) : FunBitcoinPrivateKey
	{
		var result = new FunBitcoinPrivateKey(context);
		result._fromBytes(value);
		result.m_compress = compress;
		result.m_testnet = testnet;
		return result;
	}

	public static function fromPrivateKey(value : FunBitcoinPrivateKey, compress : Bool = true, testnet : Bool = false) : FunBitcoinPrivateKey
	{
		var result = new FunBitcoinPrivateKey(value.m_context);
		result._fromKey(value);
		result.m_compress = compress;
		result.m_testnet = testnet;
		return result;
	}

	public static function fromValue(context : FunBitcoinContext, value : Dynamic, compress : Bool = true, testnet : Bool = false) : FunBitcoinPrivateKey
	{
		var result = new FunBitcoinPrivateKey(context);
		result._fromValue(value);
		result.m_compress = compress;
		result.m_testnet = testnet;
		return result;
	}

	public static function fromAnything(context : FunBitcoinContext, value : Dynamic, compress : Bool = true, testnet : Bool = false) : FunBitcoinPrivateKey
	{
		// Is it another private key?
		if (Std.is(value, FunBitcoinPrivateKey))
		{
			return fromPrivateKey(cast value, compress, testnet);
		}

		// Is it a string?
		if (Std.is(value, String))
		{
			try
			{
				return fromString(context, cast value);
			}
			catch (e : Dynamic)
			{
				// Swallow
			}
		}

		// Value is last chance.
		return fromValue(context, value, compress, testnet);
	}

	public function toPublicKey() : FunBitcoinPublicKey
	{
		if (_isNull())
		{
			throw FunExceptions.FUN_INVALID_OPERATION;
		}
		var curve = m_context.getCurve();
		var result = curve.newPoint(0, 0);
		curve.pointMultiply(result, curve.get_G(), m_key);
		curve.clear();
		return FunBitcoinPublicKey.fromPoint(m_context, result, m_compress, m_testnet);
	}

	public function toAddress() : String
	{
		return toPublicKey().toAddress();
	}

	public function toBytes() : Bytes
	{
		_computeBytes();
		var result = Bytes.alloc(32);
		result.blit(0, m_data, 1, 32);
		return result;
	}

	public function toWIF() : String
	{
		_computeBytes();
		m_data.set(0, m_testnet ? 239 : 128);
		return m_context.getBase58().encode(m_data);
	}

	public function isCompressed() : Bool
	{
		return m_compress;
	}

	public function isTestnet() : Bool
	{
		return m_testnet;
	}

	public function clear() : Void
	{
		if (!FunBigIntTools.isNull(m_key))
		{
			m_key.clear();
			m_key = null;
		}
		FunCryptoUtils.clearBytes(m_data);
		m_context.getBase58().clear();
	}

	private function _computeBytes() : Void
	{
		if (m_data == null)
		{
			m_data = FunCryptoUtils.safeAlloc(m_data, m_compress ? 34 : 33);
			m_data.set(m_data.length - 1, 1);
			var src = m_key.toBytes();
			var srcLen = FunInteger.min(src.length, 32);
			var srcOff = src.length - srcLen;
			var dstOff = 32 - srcLen + 1;
			m_data.fill(1, 32, 0);
			m_data.blit(dstOff, src, srcOff, srcLen);
			FunCryptoUtils.clearBytes(src);
		}
	}

	private function new(context : FunBitcoinContext) : Void
	{
		if (context == null)
		{
			throw FunExceptions.FUN_NULL_ARGUMENT;
		}
		m_context = context;
	}

	private function _fromKey(other : FunBitcoinPrivateKey) : Void
	{
		if (other._isNull())
		{
			throw FunExceptions.FUN_INVALID_OPERATION;
		}
		m_key = 0;
		m_key.copyFrom(other.m_key);
	}

	private function _fromWIF(value : String, allowTestnet : Bool) : Void
	{
		var b = m_context.getBase58().decode(value);
		try
		{
			if ((b.length < 33) || (b.length > 34))
			{
				throw FunExceptions.FUN_INVALID_ARGUMENT;
			}
			var version = b.get(0);
			if ((version != 128) && (version != 239))
			{
				throw FunExceptions.FUN_INVALID_ARGUMENT;
			}
			m_testnet = (version == 239);
			if (m_testnet && (!allowTestnet))
			{
				throw FunExceptions.FUN_INVALID_ARGUMENT;
			}
			if ((b.length == 34) && (b.get(33) != 1))
			{
				throw FunExceptions.FUN_INVALID_ARGUMENT;
			}
			m_compress = (b.length == 34);
			m_key = 0;
			m_key.setFromBigEndianBytesUnsigned(b, 1, 32);
			_validate();
		}
		catch (e : Dynamic)
		{
			FunCryptoUtils.clearBytes(b);
			throw FunExceptions.rethrow(e);
		}
		FunCryptoUtils.clearBytes(b);
	}

	private function _fromValue(value : Dynamic) : Void
	{
		m_key = FunBigIntTools.parseValueUnsigned(value);	// TODO: this may result in an uncleared private key in the form of a FunBigInt
		_validate();
	}

	private function _fromBytes(value : Bytes) : Void
	{
		if (value.length < 32)
		{
			throw FunExceptions.FUN_INVALID_ARGUMENT;
		}
		m_key = 0;
		m_key.setFromBigEndianBytesUnsigned(value, 0, 32);
		_validate();
	}

	private function _validate() : Void
	{
		if ((m_key < 1) || (m_key >= m_context.getCurve().get_order()))
		{
			m_key.clear();
			m_key = null;
			throw FunExceptions.FUN_INVALID_ARGUMENT;
		}
	}

	private inline function _isNull() : Bool
	{
		return FunBigIntTools.isNull(m_key);
	}

	private var m_context : FunBitcoinContext;
	private var m_key : FunMutableBigInt;		// mutable because we want to call clear()
	private var m_compress = true;
	private var m_testnet = false;
	private var m_data : Bytes;
}
