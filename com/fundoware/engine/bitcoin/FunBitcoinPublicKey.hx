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
import com.fundoware.engine.crypto.ec.FunIEllipticCurvePoint;
import com.fundoware.engine.crypto.FunCryptoUtils;
import com.fundoware.engine.crypto.hash.FunRIPEMD160;
import com.fundoware.engine.crypto.hash.FunSHA2_256;
import com.fundoware.engine.exception.FunExceptions;
import com.fundoware.engine.math.FunInteger;
import haxe.ds.Vector;
import haxe.io.Bytes;

class FunBitcoinPublicKey
{
	public static function fromPoint(context : FunBitcoinContext, point : FunIEllipticCurvePoint, compress : Bool = true, testnet : Bool = false) : FunBitcoinPublicKey
	{
		var result = new FunBitcoinPublicKey(context);
		var size = point.get_x().toInts(null);
		if (size > 8)
		{
			throw FunExceptions.FUN_INVALID_ARGUMENT;
		}
		var tmp = new Vector<Int>(size);
		point.get_x().toInts(tmp);
		result.m_x = FunBigInt.fromUnsignedInts(tmp, size);
		point.get_y().toInts(tmp);
		result.m_y = FunBigInt.fromUnsignedInts(tmp, size);
		result.m_compress = compress;
		result.m_testnet = testnet;
		return result;
	}

	public static function fromPublicKey(key : FunBitcoinPublicKey, compress : Bool = true, testnet : Bool = false) : FunBitcoinPublicKey
	{
		var result = new FunBitcoinPublicKey(key.m_context);
		result.m_x = key.m_x;
		result.m_y = key.m_y;
		result.m_compress = compress;
		result.m_testnet = testnet;
		return result;
	}

	private function _toBytesCompressed() : Bytes
	{
		var result = Bytes.alloc(33);
		result.fill(1, 32, 0);
		var src = m_x.toBytes();
		var srcLen = FunInteger.min(src.length, 32);
		var srcPos = src.length - srcLen;
		var dstPos = 32 - srcLen;
		result.blit(1 + dstPos, src, srcPos, srcLen);
		result.set(0, 2 + m_y.getBit(0));
		return result;
	}

	private function _toBytesUncompressed() : Bytes
	{
		var result = Bytes.alloc(65);
		result.fill(1, 64, 0);
		var src = m_x.toBytes();
		var srcLen = FunInteger.min(src.length, 32);
		var srcPos = src.length - srcLen;
		var dstPos = 32 - srcLen;
		result.blit(1 + dstPos, src, srcPos, srcLen);
		src = m_y.toBytes();
		srcLen = FunInteger.min(src.length, 32);
		srcPos = src.length - srcLen;
		dstPos = 32 - srcLen;
		result.blit(33 + dstPos, src, srcPos, srcLen);
		result.set(0, 4);
		return result;
	}

	public function toBytes() : Bytes
	{
		return m_compress ? _toBytesCompressed() : _toBytesUncompressed();
	}

	public function toHash() : Bytes
	{
		_computeHash();
		var digest = Bytes.alloc(20);
		digest.blit(0, m_data, 1, 20);
		return digest;
	}

	public function toAddress() : String
	{
		_computeHash();
		m_data.set(0, m_testnet ? 111 : 0);
		return m_context.getBase58().encode(m_data);
	}

	private function _computeHash() : Void
	{
		if (m_data == null)
		{
			m_data = FunCryptoUtils.safeAlloc(m_data, 21);
			var bytes = toBytes();
			var hash = m_context.getHash160();
			hash.reset();
			hash.addBytes(bytes, 0, bytes.length);
			hash.finish(m_data, 1);
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

	private var m_context : FunBitcoinContext;
	private var m_x : FunBigInt;
	private var m_y : FunBigInt;
	private var m_compress = true;
	private var m_testnet = false;
	private var m_data : Bytes;
}
