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

package com.fundoware.engine.crypto.hash;

import com.fundoware.engine.core.FunUtils;
import com.fundoware.engine.exception.FunExceptions;
import com.fundoware.engine.test.FunTestCase;
import com.fundoware.engine.test.FunTestUtils;
import haxe.io.Bytes;

class FunHashTestCase extends FunTestCase
{
	public function testClear() : Void
	{
		var hash = newHash();
		var bytes = Bytes.alloc(100);
		bytes.fill(0, bytes.length, 0x55);
		var digest = Bytes.alloc(hash.getDigestSize());
		hash.addBytes(bytes, 0, bytes.length);
		hash.finish(digest, 0);
		hash.clear();
		hash.finish(digest, 0);
		assertEquals(FunHashTools.HashString(hash, ""), digest.toHex());
	}

	public function testX_Chunking(i : Int) : Int
	{
		var hash = newHash();
		var sb = new StringBuf();
		var a = "a".code;
		for (j in 0 ... i)
		{
			sb.addChar(a);
		}
		var message = sb.toString();
		var expected = FunHashTools.HashString(hash, message);

		// Test chunking optimization to ensure that splits of varying lengths are handled correctly.
		for (j in 0 ... i + 1)
		{
			hash.reset();
			FunHashTools.AddString(hash, message.substr(0, j));
			FunHashTools.AddString(hash, message.substr(j));
			var digest = FunHashTools.FinishAsString(hash);
			assertEquals(expected, digest);
		}

		return 256;
	}

	public function testFinishWithNonZeroOffset() : Void
	{
		var emptyHash = FunHashTools.HashString(newHash(), "");
		var hash = newHash();
		var buff = Bytes.alloc(hash.getDigestSize() + 1);
		buff.set(0, 0xcb);
		hash.finish(buff, 1);
		assertEquals("cb" + emptyHash, buff.toHex());
	}

	public function checkHexX(testVectors : String, index : Int) : Int
	{
		var vs = FunTestUtils.getNthVector(testVectors, index);
		var idx = vs.indexOf(":");
		var hash = vs.substr(0, idx);
		var message = vs.substr(idx + 1);
		checkHex(message, hash);
		return FunTestUtils.countVectors(testVectors);
	}

	public function checkHex(message : String, expectedDigest : String) : Void
	{
		assertEquals(0, message.length & 1);
		checkBinary(FunUtils.hexToBytes(message), expectedDigest);
	}

	public function checkBinary(message : Bytes, digest : String) : Void
	{
		var checksum = FunHashTools.HashBytes(newHash(), message);
		assertEquals(digest, checksum);

		var hash = newHash();
		hash.addBytes(message, 0, message.length);
		var result = Bytes.alloc(hash.getDigestSize());
		hash.finish(result, 0);
		this.assertEquals(digest, result.toHex());
	}

	public function checkString(message : String, digest : String) : Void
	{
		var checksum = FunHashTools.HashString(newHash(), message);
		assertEquals(digest, checksum);
		checkBinary(Bytes.ofString(message), digest);
	}

	@:deprecated
	public function check(message : String, digest : String) : Void
	{
		checkString(message, digest);
	}

	private function newHash() : FunIHash
	{
		throw FunExceptions.FUN_ABSTRACT_METHOD;
	}

	public function new()
	{
		super();
	}
}
