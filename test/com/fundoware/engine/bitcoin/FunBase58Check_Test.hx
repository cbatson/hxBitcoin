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

package com.fundoware.engine.bitcoin;

import com.fundoware.engine.core.FunUtils;
import com.fundoware.engine.crypto.hash.FunSHA2_256;
import com.fundoware.engine.exception.FunExceptions;
import com.fundoware.engine.test.FunTestCase;
import haxe.io.Bytes;

class FunBase58Check_Test extends FunTestCase
{
	public function testReusedEncode() : Void
	{
		// Long encode followed by short encode to exercise correct length of internal work buffer
		assertEquals("5Kd3NBUAdUnhyzenEwVLy9pBKxSwXvE9FMPyR4UKZvpe6E3AgLr", m_base58.encode(FunUtils.hexToBytes("80eddbdc1168f1daeadbd3e44c1e3f8f5a284c2029f78ad26af98583a499de5b19")));
		assertEquals("1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i", m_base58.encode(FunUtils.hexToBytes("0065a16059864a2fdbc7c99a4723a8395bc6f188eb")));
	}

	public function testReusedDecode() : Void
	{
		// Long decode followed by short decode to exercise correct length of internal work buffer
		assertEquals("80eddbdc1168f1daeadbd3e44c1e3f8f5a284c2029f78ad26af98583a499de5b19", m_base58.decode("5Kd3NBUAdUnhyzenEwVLy9pBKxSwXvE9FMPyR4UKZvpe6E3AgLr").toHex());
		assertEquals("0065a16059864a2fdbc7c99a4723a8395bc6f188eb", m_base58.decode("1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i").toHex());
	}

	public function testDecodeBad() : Void
	{
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			decodeNoChecksum("0");
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			decodeNoChecksum("I");
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			decodeNoChecksum("O");
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			decodeNoChecksum("l");
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			decodeNoChecksum("+");
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			decodeNoChecksum("/");
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			decodeNoChecksum("=");
		});
		assertThrowsString(FunExceptions.FUN_INVALID_ARGUMENT, function() : Void
		{
			decodeNoChecksum(" ");
		});
	}

	public function testEncode() : Void
	{
		// Test vectors from https://gitorious.org/bitcoin/bitcoind-stable/commit/d6b13283d19b3229ec1aee62bf7b4747c581ddab
		// Retrieved 2014.11.20
		checkEncode("", "");
		checkEncode("61", "2g");
		checkEncode("626262", "a3gV");
		checkEncode("636363", "aPEr");
		checkEncode("73696d706c792061206c6f6e6720737472696e67", "2cFupjhnEsSn59qHXstmK2ffpLv2");
		checkEncode("00eb15231dfceb60925886b67d065299925915aeb172c06647", "1NS17iag9jJgTHD1VXjvLCEnZuQ3rJDE9L");
		checkEncode("516b6fcd0f", "ABnLTmg");
		checkEncode("bf4f89001e670274dd", "3SEo3LWLoPntC");
		checkEncode("572e4794", "3EFU7m");
		checkEncode("ecac89cad93923c02321", "EJDM8drfXA6uyA");
		checkEncode("10c8511e", "Rt5zm");
		checkEncode("00000000000000000000", "1111111111");
	}
	private function checkEncode(hex : String, expected : String) : Void
	{
		var b = FunUtils.hexToBytes(hex);
		assertEquals(expected, m_base58.encodeNoChecksum(b, b.length));
		assertEquals(hex, decodeNoChecksum(expected).toHex());
	}

	private function decodeNoChecksum(s : String) : Bytes
	{
		var b = Bytes.alloc(s.length);
		var l = m_base58.decodeNoChecksum(s, b);
		var c = Bytes.alloc(l);
		c.blit(0, b, 0, l);
		return c;
	}

	public override function setup() : Void
	{
		m_base58 = new FunBase58Check(new FunBitcoinHash256(new FunSHA2_256()));
	}

	private var m_base58 : FunBase58Check;
}
