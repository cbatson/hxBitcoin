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

package com.fundoware.engine.crypto.salsa20;

import com.fundoware.engine.bigint.FunMultiwordArithmetic;
import com.fundoware.engine.crypto.FunCryptoUtils;
import com.fundoware.engine.crypto.hash.impl.FunBlockHashBase;
import com.fundoware.engine.exception.FunExceptions;
import com.fundoware.engine.math.FunInteger;
import haxe.ds.Vector;
import haxe.io.Bytes;

// See http://cr.yp.to/snuffle/spec.pdf
class FunSalsa20
{
	public static inline var kBlockSize : Int = 64;

	public static function core(output : Vector<Int>, outputOffset : Int, input : Vector<Int>, numRounds : Int = 20) : Void
	{
		if ((numRounds & 1) != 0)
		{
			throw FunExceptions.FUN_INVALID_ARGUMENT;
		}
		if ((outputOffset + 16 > output.length) || (input.length < 16))
		{
			throw FunExceptions.FUN_BUFFER_TOO_SMALL;
		}

		var x0 : Int = input.get(0);
		var x1 : Int = input.get(1);
		var x2 : Int = input.get(2);
		var x3 : Int = input.get(3);
		var x4 : Int = input.get(4);
		var x5 : Int = input.get(5);
		var x6 : Int = input.get(6);
		var x7 : Int = input.get(7);
		var x8 : Int = input.get(8);
		var x9 : Int = input.get(9);
		var xa : Int = input.get(10);
		var xb : Int = input.get(11);
		var xc : Int = input.get(12);
		var xd : Int = input.get(13);
		var xe : Int = input.get(14);
		var xf : Int = input.get(15);

		for (i in 0 ... numRounds >> 1)
		{
			x4 ^= FunInteger.rotateLeft(x0 + xc, 7);
			x9 ^= FunInteger.rotateLeft(x5 + x1, 7);
			xe ^= FunInteger.rotateLeft(xa + x6, 7);
			x3 ^= FunInteger.rotateLeft(xf + xb, 7);
			x8 ^= FunInteger.rotateLeft(x4 + x0, 9);
			xd ^= FunInteger.rotateLeft(x9 + x5, 9);
			x2 ^= FunInteger.rotateLeft(xe + xa, 9);
			x7 ^= FunInteger.rotateLeft(x3 + xf, 9);
			xc ^= FunInteger.rotateLeft(x8 + x4, 13);
			x1 ^= FunInteger.rotateLeft(xd + x9, 13);
			x6 ^= FunInteger.rotateLeft(x2 + xe, 13);
			xb ^= FunInteger.rotateLeft(x7 + x3, 13);
			x0 ^= FunInteger.rotateLeft(xc + x8, 18);
			x5 ^= FunInteger.rotateLeft(x1 + xd, 18);
			xa ^= FunInteger.rotateLeft(x6 + x2, 18);
			xf ^= FunInteger.rotateLeft(xb + x7, 18);

			x1 ^= FunInteger.rotateLeft(x0 + x3, 7);
			x6 ^= FunInteger.rotateLeft(x5 + x4, 7);
			xb ^= FunInteger.rotateLeft(xa + x9, 7);
			xc ^= FunInteger.rotateLeft(xf + xe, 7);
			x2 ^= FunInteger.rotateLeft(x1 + x0, 9);
			x7 ^= FunInteger.rotateLeft(x6 + x5, 9);
			x8 ^= FunInteger.rotateLeft(xb + xa, 9);
			xd ^= FunInteger.rotateLeft(xc + xf, 9);
			x3 ^= FunInteger.rotateLeft(x2 + x1, 13);
			x4 ^= FunInteger.rotateLeft(x7 + x6, 13);
			x9 ^= FunInteger.rotateLeft(x8 + xb, 13);
			xe ^= FunInteger.rotateLeft(xd + xc, 13);
			x0 ^= FunInteger.rotateLeft(x3 + x2, 18);
			x5 ^= FunInteger.rotateLeft(x4 + x7, 18);
			xa ^= FunInteger.rotateLeft(x9 + x8, 18);
			xf ^= FunInteger.rotateLeft(xe + xd, 18);
		}

		output.set(outputOffset++, input.get( 0) + x0);
		output.set(outputOffset++, input.get( 1) + x1);
		output.set(outputOffset++, input.get( 2) + x2);
		output.set(outputOffset++, input.get( 3) + x3);
		output.set(outputOffset++, input.get( 4) + x4);
		output.set(outputOffset++, input.get( 5) + x5);
		output.set(outputOffset++, input.get( 6) + x6);
		output.set(outputOffset++, input.get( 7) + x7);
		output.set(outputOffset++, input.get( 8) + x8);
		output.set(outputOffset++, input.get( 9) + x9);
		output.set(outputOffset++, input.get(10) + xa);
		output.set(outputOffset++, input.get(11) + xb);
		output.set(outputOffset++, input.get(12) + xc);
		output.set(outputOffset++, input.get(13) + xd);
		output.set(outputOffset++, input.get(14) + xe);
		output.set(outputOffset++, input.get(15) + xf);
	}

	public static inline function bytesToInts(output : Vector<Int>, input : Bytes) : Void
	{
		FunCryptoUtils.bytesToIntsLE(output, input, 16);
	}

	public static inline function intsToBytes(output : Bytes, input : Vector<Int>) : Void
	{
		FunCryptoUtils.intsToBytesLE(output, input, 16);
	}
}
