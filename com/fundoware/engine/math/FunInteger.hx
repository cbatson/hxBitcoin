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

package com.fundoware.engine.math;

class FunInteger
{
	public static inline function min(a : Int, b : Int) : Int
	{
		return (a < b) ? a : b;
	}

	public static inline function max(a : Int, b : Int) : Int
	{
		return (a > b) ? a : b;
	}

	/**
		Rotate the value `value` to the left by `count` bits.
		As bits "fall off" the left they are shifted in from the
		right.

		Requires that 0 < `count` < 31.  Results are undefined if
		this condition is not met.
	**/
	public static inline function rotateLeft(value : Int, count : Int) : Int
	{
		return (value >>> (32 - count)) | (value << count);
	}

	/**
		Rotate the value `value` to the right by `count` bits.
		As bits "fall off" the right they are shifted in from the
		left.

		Requires that 0 < `count` < 31.  Results are undefined if
		this condition is not met.
	**/
	public static inline function rotateRight(value : Int, count : Int) : Int
	{
		return (value << (32 - count)) | (value >>> count);
	}

	/**
		Returns `true` if the input `x` is a power of 2, or the
		value 0; `false` otherwise.
	**/
	public static inline function isPowerOf2(x : Int) : Bool
	{
		return (x & (x - 1)) == 0;
	}

	/**
		"Numbler of leading zeros" - return the number of leading
		0-value bits in the binary representation of `x`.
	**/
	public static function nlz(x : Int) : Int
	{
		// From "Hacker's Delight", Second Edition; Henry S. Warren, Jr.; 2013. Figure 5-15, p. 102.
		var y : Int, m : Int, n : Int;

		y = -(x >>> 16);
		m = (y >> 16) & 16;
		n = 16 - m;
		x = x >>> m;

		y = x - 0x100;
		m = (y >> 16) & 8;
		n = n + m;
		x = x << m;

		y = x - 0x1000;
		m = (y >> 16) & 4;
		n = n + m;
		x = x << m;

		y = x - 0x4000;
		m = (y >> 16) & 2;
		n = n + m;
		x = x << m;

		y = x >> 14;
		m = y & (~y >> 1);
		return n + 2 - m;
	}


	/**
		"Ceiling power of two" -- round up to the least power of two
		greater than or equal to input `x`, which is interpreted as
		unsigned.
	**/
	public static function clp2(x : Int) : Int
	{
		// From "Hacker's Delight", Second Edition; Henry S. Warren, Jr.; 2013. Figure 3-3, p. 62.
		x = x - 1;
		x = x | (x >> 1);
		x = x | (x >> 2);
		x = x | (x >> 4);
		x = x | (x >> 8);
		x = x | (x >> 16);
		return x + 1;
	}


	/**
		"Floor power of two" -- round down to the greatest power of
		two less than or equal to input `x`, which is interpreted as
		unsigned.
	**/
	public static function flp2(x : Int) : Int
	{
		// From "Hacker's Delight", Second Edition; Henry S. Warren, Jr.; 2013. Figure 3-1, p. 61.
		x = x | (x >> 1);
		x = x | (x >> 2);
		x = x | (x >> 4);
		x = x | (x >> 8);
		x = x | (x >> 16);
		return x - (x >>> 1);
	}


	/**
		Unsigned greater than comparison.

		Returns `true` if `a > b` when both `a` and `b` are
		interpreted as unsigned integers; `false` otherwise.
	**/
	public static inline function u32gtu32(a : Int, b : Int) : Bool
	{
		return (a + -2147483648) > (b + -2147483648);		// unsigned comparison, see "Hacker's Delight" p. 25.
	}


	/**
		Unsigned greater than or equal comparison.

		Returns `true` if `a >= b` when both `a` and `b` are
		interpreted as unsigned integers; `false` otherwise.
	**/
	public static inline function u32geu32(a : Int, b : Int) : Bool
	{
		return (a + -2147483648) >= (b + -2147483648);		// unsigned comparison, see "Hacker's Delight" p. 25.
	}


	/**
		Integer division of unsigned 32-bit integer by unsigned 16-bit integer.

		Result is undefined when `divisor` <= 0 or `divisor` >= 2^16.
	**/
	public static function u32divu16(dividend : Int, divisor : Int) : Int
	{
		/*
			Complicated because Haxe's division is always performed as
			floating-point.  Here we rely on the ability to exactly represent
			a 31-bit integer as a Float.  In other words, 64-bit floating
			point is required.

			TODO: Implement a method without this restriction.
			TODO: Consider C++-specific optimization here.
		*/
		// From "Hacker's Delight", Second Edition; Henry S. Warren, Jr.; 2013. Section 9-3, p. 192.
		var t : Int = divisor >> 31;
		var nprime : Int = dividend & ~t;
		var q : Int = Std.int((nprime >>> 1) / divisor) << 1;
		var r : Int = dividend - q * divisor;
		var c : Int = u32geu32(r, divisor) ? 1 : 0;
		return q + c;
	}


	/**
		Integer division of unsigned 32-bit integer by unsigned 16-bit integer,
		returning both quotient and remainder.

		Result is undefined when `divisor` <= 0 or `divisor` >= 2^16.
	**/
	public static function u32divu16r(dividend : Int, divisor : Int, result : DivisionResult) : Void
	{
		/*
			Complicated because Haxe's division is always performed as
			floating-point.  Here we rely on the ability to exactly represent
			a 31-bit integer as a Float.  In other words, 64-bit floating
			point is required.

			TODO: Implement a method without this restriction.
			TODO: Consider C++-specific optimization here.
		*/
		// From "Hacker's Delight", Second Edition; Henry S. Warren, Jr.; 2013. Section 9-3, p. 192.
		var t : Int = divisor >> 31;
		var nprime : Int = dividend & ~t;
		var q : Int = Std.int((nprime >>> 1) / divisor) << 1;
		var r : Int = dividend - q * divisor;
		var c : Int = u32geu32(r, divisor) ? 1 : 0;
		q += c;
		result.quotient = q;
		result.remainder = dividend - q * divisor;
	}


	/**
		Integer division of unsigned 32-bit integer by unsigned 32-bit integer.

		Result is undefined when `divisor` is 0.
	**/
	public static function u32divu32(dividend : Int, divisor : Int, result : DivisionResult) : Void
	{
		/*
			Complicated because Haxe's division is always performed as
			floating-point.  Here we rely on the ability to exactly represent
			a 32-bit integer as a Float.  In other words, 64-bit floating
			point is required.

			TODO: Implement a method without this restriction.
			TODO: Consider C++-specific optimization here.
		*/
		var a = unsignedIntToFloat(dividend);
		var b = unsignedIntToFloat(divisor);
		var q : Float = Math.ffloor(a / b);
		var q1 : Float = q;
		if (q1 >= 2147483648.0)
		{
			q1 -= 4294967296.0;
		}
		result.quotient = Std.int(q1);
		result.remainder = Std.int(a - q * b);
	}
	private static function unsignedIntToFloat(x : Int) : Float
	{
		var y : Float = x;
		if (y < 0)
		{
			y += 4294967296.0;
		}
		return y;
	}
}

class DivisionResult
{
	public var quotient : Int;
	public var remainder : Int;

	public function new() : Void {}
}
