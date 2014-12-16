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

import haxe.CallStack;
import haxe.PosInfos;
import haxe.unit.TestCase;

class FunTestCase extends TestCase
{
	public function new()
	{
		super();
	}

	public function assertEqualsFloat(expected : Float, actual : Float, tolerance : Float, ?c : PosInfos) : Void
	{
		this.assertTrue(Math.abs(actual - expected) <= tolerance, c);
	}

	public function assertReferenceEquals(a : Dynamic, b : Dynamic, ?c : PosInfos) : Void
	{
		this.assertTrue(a == b, c);
	}

	public function assertThrows<T>(expected : Class<T>, what : Void->Void, ?c : PosInfos) : T
	{
		var success = false;
		var actual : Class<Dynamic> = null;
		var actualException : Dynamic = null;
		try
		{
			what();
		}
		catch (e : Dynamic)
		{
			actualException = e;
			actual = Type.getClass(e);
		}
		currentTest.done = true;
		if (actual != expected)
		{
			var expectedName = Type.getClassName(expected);
			var actualName = (actual != null) ? Type.getClassName(actual) : null;
			currentTest.success = false;
			currentTest.error   = "expected exception '" + expectedName + "' but was '" + actualName + "':\n" + Std.string(actualException) + "\n" + CallStack.toString(CallStack.exceptionStack());
			currentTest.posInfos = c;
			throw currentTest;
		}
		return actualException;
	}

	public function assertThrowsString(expected : String, what : Void->Void, ?c : PosInfos) : Void
	{
		var s = assertThrows(String, what, c);
		assertEquals(expected, s);
	}

	public function suppressNoAssertionWarning() : Void
	{
		assertTrue(true);
	}
}
