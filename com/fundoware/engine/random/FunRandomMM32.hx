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

import haxe.ds.Vector;
import haxe.io.Bytes;

/*
	Additive generator of Mitchell and Moore (unpublished, see Knuth,
	"The Art of Computer Programming: Seminumerical Algorithms",
	Third Edition, section 3.2.2, pp. 26-28.
*/
class FunRandomMM32 implements FunIRandom32
{
	public var length(get, never) : Int;

	public function new()
	{
	}

	/**
		Note: The behavior of this function is target-dependent.
		The same seed string is not guaranteed to result in the
		same initial state on one target versus another.
	**/
	public function seedString(s : String) : Void
	{
		var j : Int = 0;
		for (i in 0 ... s_k)
		{
			h[i] = s.charCodeAt(j);
			if (++j >= s.length)
			{
				j = 0;
			}
		}
		h[0] |= 1;
	}

	public function seedByteArray(ba : Bytes, offset : Int, length : Int) : Void
	{
		var end : Int = offset + length;
		var j : Int = offset;
		for (i in 0 ... s_k)
		{
			h[i] = ba.get(j);
			if (++j >= end)
			{
				j = offset;
			}
		}
	}

	public function churn(n : Int) : Void
	{
		for (i in 0 ... n)
		{
			next();
		}
	}

	public inline function next() : Int
	{
		// Compute the next random integer and copy it back into the table.
		var n = h[b55] = h[b55] + h[b24];

		// Update the table indices
		if (++b24 >= s_k)
		{
			b24 = 0;
		}
		if (++b55 >= s_k)
		{
			b55 = 0;
		}

		// Return the value we computed.
		return n;
	}

	public function copyFrom(other : FunRandomMM32) : Void
	{
		for (i in 0 ... s_k)
		{
			this.h[i] = other.h[i];
		}
		this.b55 = other.b55;
		this.b24 = other.b24;
	}

	@:noCompletion
	private inline function get_length() : Int
	{
		return s_k;
	}

	private static inline var s_k : Int = 55;
	private var h = new Vector<Int>(s_k);
	private var b55 : Int = 0;
	private var b24 : Int = s_k - 24;
}
