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

package com.fundoware.engine.random;

import com.fundoware.engine.exception.FunExceptions;
import com.fundoware.engine.math.FunInteger;

class FunRandomTools
{
	/**
	 * Return a random value uniformly distributed in the range of [0.0, 1.0);
	 * that is, from 0.0 (inclusive) to 1.0 (exclusive).
	 *
	 * @param	rng		the random number generator
	 */
	public static function nextUniformDeviate(rng : FunIRandom32) : Float
	{
		var val = rng.next();
		var k31 : Float = 2147483648.0;
		var k32 : Float = 1.0 / 4294967296.0;
		var fval : Float = val + k31;
		fval *= k32;
//trace(val + "," + fval);
		return fval;
	}

	/**
		Return a random integer value uniformly distributed in the
		range of [`min`, `max`); that is, from `min` (inclusive)
		to `max` (exclusive).

		@param	rng		the random number generator
		@param	min		the minimum value to return, inclusive
		@param	max		the maximum value to return, exclusive
	**/
	public static function nextInt(rng : FunIRandom32, min : Int, max : Int)
	{
		// See http://docs.oracle.com/javase/7/docs/api/java/util/Random.html#nextInt%28int%29

		var range : Int = max - min;
		if (range <= 0)
		{
			throw FunExceptions.FUN_INVALID_ARGUMENT;
		}

		// Special case for power of two
		var val : Int;
		if (FunInteger.isPowerOf2(range))
		{
			// prefer high bits, as some prng (like linear congruential)
			// exhibit poor properties in the lower bits
			val = rng.next() >>> (FunInteger.nlz(range) + 1);
		}
		else
		{
			var bits : Int;
			do
			{
				bits = rng.next() >>> 1;
				val = Std.int(bits % range);
			} while (bits - val + (range - 1) < 0);
		}
		return val + min;
	}
}
