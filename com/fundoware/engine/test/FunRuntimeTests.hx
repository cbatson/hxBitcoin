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

package com.fundoware.engine.test;

import com.fundoware.engine.exception.FunExceptions;
import com.fundoware.engine.math.FunInteger;

class FunRuntimeTests
{
	public static function run() : Void
	{
		testUnsignedComparison();
	}

	public static function assertTrue(condition : Bool) : Void
	{
		if (!condition)
		{
			throw FunExceptions.FUN_RUNTIME_TEST_FAILED;
		}
	}

	// This test detects a compiler optimization issue discovered
	// using GCC. See https://chuckbatson.wordpress.com/2014/12/20/gcc-compiler-bug-broke-my-haxe-code/
	private static function testUnsignedComparison() : Void
	{
		assertTrue(unsignedComparison(-2147483648, 2147483647));
	}

	private static function unsignedComparison(a : Int, b : Int) : Bool
	{
		return FunInteger.u32gtu32(a, b);
	}
}
