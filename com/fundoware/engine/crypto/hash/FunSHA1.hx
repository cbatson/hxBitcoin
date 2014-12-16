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

package com.fundoware.engine.crypto.hash;

import com.fundoware.engine.crypto.hash.impl.FunBlockHashBase;
import com.fundoware.engine.exception.FunExceptions;
import com.fundoware.engine.math.FunInteger;
import haxe.io.Bytes;

class FunSHA1 extends FunBlockHashBase implements FunIHash
{
	//-----------------------------------------------------------------------
	// Public interface
	//-----------------------------------------------------------------------

	public static inline var kDigestSize : Int = 20;
	public static inline var kBlockSize : Int = 64;

	public function new()
	{
		super(kBlockSize);
		reset();
	}

	public override function reset() : Void
	{
		super.reset();
		m_h0 = 0x67452301;
		m_h1 = 0xEFCDAB89;
		m_h2 = 0x98BADCFE;
		m_h3 = 0x10325476;
		m_h4 = 0xC3D2E1F0;
	}

	public function addByte(byte : Int) : Void
	{
		addByteBE(byte);
	}

	public function addBytes(bytes : Bytes, offset : Int, length : Int) : Void
	{
		addBytesBE(bytes, offset, length);
	}

	public function finish(digest : Bytes, offset : Int) : Void
	{
		if ((offset + kDigestSize) > digest.length)
		{
			throw FunExceptions.FUN_BUFFER_TOO_SMALL;
		}

		var len = m_length;
		addByteBE(0x80);
		while ((m_length & 0x3f) != 56)
		{
			addByteBE(0x00);
		}
		m_block.set(14, len >>> 29);
		m_block.set(15, len << 3);
		processBlock();

		FunBlockHashBase.putBE(digest, offset +  0, m_h0);
		FunBlockHashBase.putBE(digest, offset +  4, m_h1);
		FunBlockHashBase.putBE(digest, offset +  8, m_h2);
		FunBlockHashBase.putBE(digest, offset + 12, m_h3);
		FunBlockHashBase.putBE(digest, offset + 16, m_h4);
	}

	public function getDigestSize() : Int
	{
		return kDigestSize;
	}

	public function clear() : Void
	{
		super.doClear();
		reset();
	}

	//-----------------------------------------------------------------------
	// Private implementation
	//-----------------------------------------------------------------------

	private inline static function f1(a : Int, b : Int, c : Int, d : Int, e : Int, w : Int) : Int
	{
		return FunInteger.rotateLeft(a, 5) + ((b & c) | ((~b) & d)) + e + 0x5A827999 + w;
	}

	private inline static function f2(a : Int, b : Int, c : Int, d : Int, e : Int, w : Int) : Int
	{
		return FunInteger.rotateLeft(a, 5) + (b ^ c ^ d) + e + 0x6ED9EBA1 + w;
	}

	private inline static function f3(a : Int, b : Int, c : Int, d : Int, e : Int, w : Int) : Int
	{
		return FunInteger.rotateLeft(a, 5) + ((b & c) | (b & d) | (c & d)) + e + 0x8F1BBCDC + w;
	}

	private inline static function f4(a : Int, b : Int, c : Int, d : Int, e : Int, w : Int) : Int
	{
		return FunInteger.rotateLeft(a, 5) + (b ^ c ^ d) + e + 0xCA62C1D6 + w;
	}

	private inline function w(b3 : Int, b8 : Int, b14 : Int, b16 : Int) : Int
	{
		var w = FunInteger.rotateLeft(m_block.get(b3) ^ m_block.get(b8) ^ m_block.get(b14) ^ m_block.get(b16), 1);
		m_block.set(b16, w);
		return w;
	}

	private override function processBlock() : Void
	{
		var a = m_h0;
		var b = m_h1;
		var c = m_h2;
		var d = m_h3;
		var e = m_h4;
		e = f1(a, b,                           c,      d, e, m_block.get( 0));
		d = f1(e, a, b = FunInteger.rotateLeft(b, 30), c, d, m_block.get( 1));
		c = f1(d, e, a = FunInteger.rotateLeft(a, 30), b, c, m_block.get( 2));
		b = f1(c, d, e = FunInteger.rotateLeft(e, 30), a, b, m_block.get( 3));
		a = f1(b, c, d = FunInteger.rotateLeft(d, 30), e, a, m_block.get( 4));
		e = f1(a, b, c = FunInteger.rotateLeft(c, 30), d, e, m_block.get( 5));
		d = f1(e, a, b = FunInteger.rotateLeft(b, 30), c, d, m_block.get( 6));
		c = f1(d, e, a = FunInteger.rotateLeft(a, 30), b, c, m_block.get( 7));
		b = f1(c, d, e = FunInteger.rotateLeft(e, 30), a, b, m_block.get( 8));
		a = f1(b, c, d = FunInteger.rotateLeft(d, 30), e, a, m_block.get( 9));
		e = f1(a, b, c = FunInteger.rotateLeft(c, 30), d, e, m_block.get(10));
		d = f1(e, a, b = FunInteger.rotateLeft(b, 30), c, d, m_block.get(11));
		c = f1(d, e, a = FunInteger.rotateLeft(a, 30), b, c, m_block.get(12));
		b = f1(c, d, e = FunInteger.rotateLeft(e, 30), a, b, m_block.get(13));
		a = f1(b, c, d = FunInteger.rotateLeft(d, 30), e, a, m_block.get(14));
		e = f1(a, b, c = FunInteger.rotateLeft(c, 30), d, e, m_block.get(15));
		d = f1(e, a, b = FunInteger.rotateLeft(b, 30), c, d, w(13,  8,  2,  0));
		c = f1(d, e, a = FunInteger.rotateLeft(a, 30), b, c, w(14,  9,  3,  1));
		b = f1(c, d, e = FunInteger.rotateLeft(e, 30), a, b, w(15, 10,  4,  2));
		a = f1(b, c, d = FunInteger.rotateLeft(d, 30), e, a, w( 0, 11,  5,  3));
		e = f2(a, b, c = FunInteger.rotateLeft(c, 30), d, e, w( 1, 12,  6,  4));
		d = f2(e, a, b = FunInteger.rotateLeft(b, 30), c, d, w( 2, 13,  7,  5));
		c = f2(d, e, a = FunInteger.rotateLeft(a, 30), b, c, w( 3, 14,  8,  6));
		b = f2(c, d, e = FunInteger.rotateLeft(e, 30), a, b, w( 4, 15,  9,  7));
		a = f2(b, c, d = FunInteger.rotateLeft(d, 30), e, a, w( 5,  0, 10,  8));
		e = f2(a, b, c = FunInteger.rotateLeft(c, 30), d, e, w( 6,  1, 11,  9));
		d = f2(e, a, b = FunInteger.rotateLeft(b, 30), c, d, w( 7,  2, 12, 10));
		c = f2(d, e, a = FunInteger.rotateLeft(a, 30), b, c, w( 8,  3, 13, 11));
		b = f2(c, d, e = FunInteger.rotateLeft(e, 30), a, b, w( 9,  4, 14, 12));
		a = f2(b, c, d = FunInteger.rotateLeft(d, 30), e, a, w(10,  5, 15, 13));
		e = f2(a, b, c = FunInteger.rotateLeft(c, 30), d, e, w(11,  6,  0, 14));
		d = f2(e, a, b = FunInteger.rotateLeft(b, 30), c, d, w(12,  7,  1, 15));
		c = f2(d, e, a = FunInteger.rotateLeft(a, 30), b, c, w(13,  8,  2,  0));
		b = f2(c, d, e = FunInteger.rotateLeft(e, 30), a, b, w(14,  9,  3,  1));
		a = f2(b, c, d = FunInteger.rotateLeft(d, 30), e, a, w(15, 10,  4,  2));
		e = f2(a, b, c = FunInteger.rotateLeft(c, 30), d, e, w( 0, 11,  5,  3));
		d = f2(e, a, b = FunInteger.rotateLeft(b, 30), c, d, w( 1, 12,  6,  4));
		c = f2(d, e, a = FunInteger.rotateLeft(a, 30), b, c, w( 2, 13,  7,  5));
		b = f2(c, d, e = FunInteger.rotateLeft(e, 30), a, b, w( 3, 14,  8,  6));
		a = f2(b, c, d = FunInteger.rotateLeft(d, 30), e, a, w( 4, 15,  9,  7));
		e = f3(a, b, c = FunInteger.rotateLeft(c, 30), d, e, w( 5,  0, 10,  8));
		d = f3(e, a, b = FunInteger.rotateLeft(b, 30), c, d, w( 6,  1, 11,  9));
		c = f3(d, e, a = FunInteger.rotateLeft(a, 30), b, c, w( 7,  2, 12, 10));
		b = f3(c, d, e = FunInteger.rotateLeft(e, 30), a, b, w( 8,  3, 13, 11));
		a = f3(b, c, d = FunInteger.rotateLeft(d, 30), e, a, w( 9,  4, 14, 12));
		e = f3(a, b, c = FunInteger.rotateLeft(c, 30), d, e, w(10,  5, 15, 13));
		d = f3(e, a, b = FunInteger.rotateLeft(b, 30), c, d, w(11,  6,  0, 14));
		c = f3(d, e, a = FunInteger.rotateLeft(a, 30), b, c, w(12,  7,  1, 15));
		b = f3(c, d, e = FunInteger.rotateLeft(e, 30), a, b, w(13,  8,  2,  0));
		a = f3(b, c, d = FunInteger.rotateLeft(d, 30), e, a, w(14,  9,  3,  1));
		e = f3(a, b, c = FunInteger.rotateLeft(c, 30), d, e, w(15, 10,  4,  2));
		d = f3(e, a, b = FunInteger.rotateLeft(b, 30), c, d, w( 0, 11,  5,  3));
		c = f3(d, e, a = FunInteger.rotateLeft(a, 30), b, c, w( 1, 12,  6,  4));
		b = f3(c, d, e = FunInteger.rotateLeft(e, 30), a, b, w( 2, 13,  7,  5));
		a = f3(b, c, d = FunInteger.rotateLeft(d, 30), e, a, w( 3, 14,  8,  6));
		e = f3(a, b, c = FunInteger.rotateLeft(c, 30), d, e, w( 4, 15,  9,  7));
		d = f3(e, a, b = FunInteger.rotateLeft(b, 30), c, d, w( 5,  0, 10,  8));
		c = f3(d, e, a = FunInteger.rotateLeft(a, 30), b, c, w( 6,  1, 11,  9));
		b = f3(c, d, e = FunInteger.rotateLeft(e, 30), a, b, w( 7,  2, 12, 10));
		a = f3(b, c, d = FunInteger.rotateLeft(d, 30), e, a, w( 8,  3, 13, 11));
		e = f4(a, b, c = FunInteger.rotateLeft(c, 30), d, e, w( 9,  4, 14, 12));
		d = f4(e, a, b = FunInteger.rotateLeft(b, 30), c, d, w(10,  5, 15, 13));
		c = f4(d, e, a = FunInteger.rotateLeft(a, 30), b, c, w(11,  6,  0, 14));
		b = f4(c, d, e = FunInteger.rotateLeft(e, 30), a, b, w(12,  7,  1, 15));
		a = f4(b, c, d = FunInteger.rotateLeft(d, 30), e, a, w(13,  8,  2,  0));
		e = f4(a, b, c = FunInteger.rotateLeft(c, 30), d, e, w(14,  9,  3,  1));
		d = f4(e, a, b = FunInteger.rotateLeft(b, 30), c, d, w(15, 10,  4,  2));
		c = f4(d, e, a = FunInteger.rotateLeft(a, 30), b, c, w( 0, 11,  5,  3));
		b = f4(c, d, e = FunInteger.rotateLeft(e, 30), a, b, w( 1, 12,  6,  4));
		a = f4(b, c, d = FunInteger.rotateLeft(d, 30), e, a, w( 2, 13,  7,  5));
		e = f4(a, b, c = FunInteger.rotateLeft(c, 30), d, e, w( 3, 14,  8,  6));
		d = f4(e, a, b = FunInteger.rotateLeft(b, 30), c, d, w( 4, 15,  9,  7));
		c = f4(d, e, a = FunInteger.rotateLeft(a, 30), b, c, w( 5,  0, 10,  8));
		b = f4(c, d, e = FunInteger.rotateLeft(e, 30), a, b, w( 6,  1, 11,  9));
		a = f4(b, c, d = FunInteger.rotateLeft(d, 30), e, a, w( 7,  2, 12, 10));
		e = f4(a, b, c = FunInteger.rotateLeft(c, 30), d, e, w( 8,  3, 13, 11));
		d = f4(e, a, b = FunInteger.rotateLeft(b, 30), c, d, w( 9,  4, 14, 12));
		c = f4(d, e, a = FunInteger.rotateLeft(a, 30), b, c, w(10,  5, 15, 13));
		b = f4(c, d, e = FunInteger.rotateLeft(e, 30), a, b, w(11,  6,  0, 14));
		a = f4(b, c, d = FunInteger.rotateLeft(d, 30), e, a, w(12,  7,  1, 15));
		m_h0 += a;
		m_h1 += b;
		m_h2 += FunInteger.rotateLeft(c, 30);
		m_h3 += d;
		m_h4 += e;
	}

	private var m_h0 : Int;
	private var m_h1 : Int;
	private var m_h2 : Int;
	private var m_h3 : Int;
	private var m_h4 : Int;
}
