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

package com.fundoware.engine.crypto.hash.impl;

import com.fundoware.engine.bigint.FunMultiwordArithmetic;
import com.fundoware.engine.crypto.FunCryptoUtils;
import com.fundoware.engine.exception.FunExceptions;
import haxe.ds.Vector;
import haxe.io.Bytes;

class FunBlockHashBase
{
	public function reset() : Void
	{
		m_length = 0;
	}

	private function addBytesBE(bytes : Bytes, offset : Int, length : Int) : Void
	{
		if (offset < 0)
		{
			throw FunExceptions.FUN_INVALID_ARGUMENT;
		}
		if ((offset + length) > bytes.length)
		{
			throw FunExceptions.FUN_INVALID_ARGUMENT;
		}
		var bd = bytes.getData();
		while (((m_length & 3) != 0) && (length > 0))
		{
			addByteBE(Bytes.fastGet(bd, offset));
			++offset;
			--length;
		}
		while (length > 3)
		{
			var i : Int = (m_length >> 2) & 0x0f;
			m_block.set(i,
				(Bytes.fastGet(bd, offset + 0) << 24) |
				(Bytes.fastGet(bd, offset + 1) << 16) |
				(Bytes.fastGet(bd, offset + 2) <<  8) |
				(Bytes.fastGet(bd, offset + 3) <<  0));
			m_length += 4;
			if (m_length < 0)
			{
				throw FunExceptions.FUN_OVERFLOW;
			}
			if ((m_length & 0x3f) == 0)
			{
				processBlock();
			}
			offset += 4;
			length -= 4;
		}
		for (i in offset ... offset + length)
		{
			addByteBE(Bytes.fastGet(bd, i));
		}
	}

	private function addBytesLE(bytes : Bytes, offset : Int, length : Int) : Void
	{
		if (offset < 0)
		{
			throw FunExceptions.FUN_INVALID_ARGUMENT;
		}
		if ((offset + length) > bytes.length)
		{
			throw FunExceptions.FUN_INVALID_ARGUMENT;
		}
		var bd = bytes.getData();
		while (((m_length & 3) != 0) && (length > 0))
		{
			addByteLE(Bytes.fastGet(bd, offset));
			++offset;
			--length;
		}
		while (length > 3)
		{
			var i : Int = (m_length >> 2) & 0x0f;
			m_block.set(i,
				(Bytes.fastGet(bd, offset + 0) <<  0) |
				(Bytes.fastGet(bd, offset + 1) <<  8) |
				(Bytes.fastGet(bd, offset + 2) << 16) |
				(Bytes.fastGet(bd, offset + 3) << 24));
			m_length += 4;
			if (m_length < 0)
			{
				throw FunExceptions.FUN_OVERFLOW;
			}
			if ((m_length & 0x3f) == 0)
			{
				processBlock();
			}
			offset += 4;
			length -= 4;
		}
		for (i in offset ... offset + length)
		{
			addByteLE(Bytes.fastGet(bd, i));
		}
	}

	private function addByteBE(byte : Int) : Void
	{
		var b : Int = (3 - (m_length & 0x03)) << 3;
		var i : Int = (m_length >> 2) & 0x0f;
		m_block.set(i, m_block.get(i) & (~(0xff << b)) | ((byte & 0xff) << b));
		++m_length;
		if (m_length < 0)
		{
			throw FunExceptions.FUN_OVERFLOW;
		}
		if ((m_length & 0x3f) == 0)
		{
			processBlock();
		}
	}

	private function addByteLE(byte : Int) : Void
	{
		var b : Int = (m_length & 0x03) << 3;
		var i : Int = (m_length >> 2) & 0x0f;
		m_block.set(i, m_block.get(i) & (~(0xff << b)) | ((byte & 0xff) << b));
		++m_length;
		if (m_length < 0)
		{
			throw FunExceptions.FUN_OVERFLOW;
		}
		if ((m_length & 0x3f) == 0)
		{
			processBlock();
		}
	}

	private function new(blockSize : Int)
	{
		if ((blockSize & 3) != 0)
		{
			throw FunExceptions.FUN_INVALID_ARGUMENT;
		}
		m_block = new Vector<Int>(blockSize >> 2);
		FunMultiwordArithmetic.setZero(m_block, m_block.length);
		m_length = 0;
	}

	private static inline function putBE(dst : Bytes, offset : Int, val : Int) : Void
	{
		dst.set(offset + 0, (val >> 24) & 0xff);
		dst.set(offset + 1, (val >> 16) & 0xff);
		dst.set(offset + 2, (val >>  8) & 0xff);
		dst.set(offset + 3, (val >>  0) & 0xff);
	}

	private static inline function putLE(dst : Bytes, offset : Int, val : Int) : Void
	{
		dst.set(offset + 0, (val >>  0) & 0xff);
		dst.set(offset + 1, (val >>  8) & 0xff);
		dst.set(offset + 2, (val >> 16) & 0xff);
		dst.set(offset + 3, (val >> 24) & 0xff);
	}

	// Not directly defining clear() here so that subclasses are
	// forced to provide an implementation for clear().
	private function doClear() : Void
	{
		FunCryptoUtils.clearVectorInt(m_block);
	}

	private function processBlock() : Void
	{
		throw FunExceptions.FUN_ABSTRACT_METHOD;
	}

	private var m_length : Int;
	private var m_block : Vector<Int>;
}
