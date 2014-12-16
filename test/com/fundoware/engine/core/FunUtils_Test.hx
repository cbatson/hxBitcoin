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

package com.fundoware.engine.core;

import com.fundoware.engine.exception.FunExceptions;
import com.fundoware.engine.test.FunTestCase;

class FunUtils_Test extends FunTestCase
{
	public function testHexToBytesOfNull() : Void
	{
		assertThrowsString(FunExceptions.FUN_NULL_ARGUMENT, function() : Void
		{
			FunUtils.hexToBytes(null);
		});
	}

	public function testHexToBytesOfOddLength() : Void
	{
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunUtils.hexToBytes("0");
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunUtils.hexToBytes("000");
		});
	}

	public function testHexToBytesOfInvalidChars() : Void
	{
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunUtils.hexToBytes("0/");
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunUtils.hexToBytes("/0");
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunUtils.hexToBytes("0:");
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunUtils.hexToBytes(":0");
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunUtils.hexToBytes("0@");
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunUtils.hexToBytes("@0");
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunUtils.hexToBytes("0G");
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunUtils.hexToBytes("G0");
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunUtils.hexToBytes("0`");
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunUtils.hexToBytes("`0");
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunUtils.hexToBytes("0g");
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			FunUtils.hexToBytes("g0");
		});
	}

	public function testHexToBytes() : Void
	{
		checkHexToBytes("");
		checkHexToBytes("00");
		checkHexToBytes("0123456789abcdef");
		checkHexToBytes("0123456789ABCDEF");
		checkHexToBytes("abcdefABCDEF");
	}
	private function checkHexToBytes(s : String) : Void
	{
		assertEquals(s.toLowerCase(), FunUtils.hexToBytes(s).toHex());
	}
}
