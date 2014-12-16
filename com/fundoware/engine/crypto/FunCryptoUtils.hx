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

package com.fundoware.engine.crypto;

import com.fundoware.engine.bigint.FunMultiwordArithmetic;
import com.fundoware.engine.exception.FunExceptions;
import haxe.ds.Vector;
import haxe.io.Bytes;

class FunCryptoUtils
{
	public static function XOR(dst : Bytes, dstOffset : Int, src1 : Bytes, src1Offset : Int, src2 : Bytes, src2Offset : Int, length : Int) : Void
	{
		if (dstOffset + length > dst.length)
		{
			throw FunExceptions.FUN_BUFFER_TOO_SMALL;
		}
		if (src1Offset + length > src1.length)
		{
			throw FunExceptions.FUN_BUFFER_TOO_SMALL;
		}
		if (src2Offset + length > src2.length)
		{
			throw FunExceptions.FUN_BUFFER_TOO_SMALL;
		}
		var s1 = src1.getData();
		var s2 = src2.getData();
		for (i in 0 ... length)
		{
			var a = Bytes.fastGet(s1, src1Offset + i);
			var b = Bytes.fastGet(s2, src2Offset + i);
			dst.set(dstOffset + i, a ^ b);
		}
	}

	public static inline function clearBytes(dst : Bytes) : Void
	{
		if (dst != null)
		{
			dst.fill(0, dst.length, 0);
		}
	}

	public static inline function clearVectorInt(dst : Vector<Int>) : Void
	{
		if (dst != null)
		{
			FunMultiwordArithmetic.setZero(dst, dst.length);
		}
	}

	public static inline function clearArrayInt(dst : Array<Int>) : Void
	{
		if (dst != null)
		{
			for (i in 0 ... dst.length)
			{
				dst[i] = 0;
			}
		}
	}

	public static function safeAlloc(b : Bytes, n : Int) : Bytes
	{
		if (b == null)
		{
			b = Bytes.alloc(n);
		}
		else if (b.length < n)
		{
			clearBytes(b);
			b = Bytes.alloc(n);
		}
		return b;
	}

	public static function bytesToIntsBE(output : Vector<Int>, input : Bytes, numInts : Int) : Void
	{
		if ((input.length < (numInts << 2)) || (output.length < numInts))
		{
			throw FunExceptions.FUN_BUFFER_TOO_SMALL;
		}
		for (i in 0 ... numInts)
		{
			output.set(i,
				(input.get((i << 2) + 0) << 24) |
				(input.get((i << 2) + 1) << 16) |
				(input.get((i << 2) + 2) <<  8) |
				(input.get((i << 2) + 3) <<  0));
		}
	}

	public static function intsToBytesBE(output : Bytes, input : Vector<Int>, numInts : Int) : Void
	{
		if ((input.length < numInts) || (output.length < (numInts << 2)))
		{
			throw FunExceptions.FUN_BUFFER_TOO_SMALL;
		}
		var v : Int;
		for (i in 0 ... numInts)
		{
			v = input.get(i);
			output.set((i << 2) + 0, (v >> 24) & 0xff);
			output.set((i << 2) + 1, (v >> 16) & 0xff);
			output.set((i << 2) + 2, (v >>  8) & 0xff);
			output.set((i << 2) + 3, (v >>  0) & 0xff);
		}
	}

	public static function bytesToIntsLE(output : Vector<Int>, input : Bytes, numInts : Int) : Void
	{
		if ((input.length < (numInts << 2)) || (output.length < numInts))
		{
			throw FunExceptions.FUN_BUFFER_TOO_SMALL;
		}
		for (i in 0 ... numInts)
		{
			output.set(i,
				(input.get((i << 2) + 0) <<  0) |
				(input.get((i << 2) + 1) <<  8) |
				(input.get((i << 2) + 2) << 16) |
				(input.get((i << 2) + 3) << 24));
		}
	}

	public static function intsToBytesLE(output : Bytes, input : Vector<Int>, numInts : Int) : Void
	{
		if ((input.length < numInts) || (output.length < (numInts << 2)))
		{
			throw FunExceptions.FUN_BUFFER_TOO_SMALL;
		}
		var v : Int;
		for (i in 0 ... numInts)
		{
			v = input.get(i);
			output.set((i << 2) + 0, (v >>  0) & 0xff);
			output.set((i << 2) + 1, (v >>  8) & 0xff);
			output.set((i << 2) + 2, (v >> 16) & 0xff);
			output.set((i << 2) + 3, (v >> 24) & 0xff);
		}
	}
}
