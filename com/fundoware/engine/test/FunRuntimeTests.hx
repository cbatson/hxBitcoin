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
