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

import haxe.io.Bytes;

class FunHashTools
{
	/**
		Hash a string and return the hash value as a string of
		hexadecimal digits.
	**/
	public static function HashString(hash : FunIHash, message : String) : String
	{
		hash.reset();
		AddString(hash, message);
		return FinishAsString(hash);
	}

	/**
		Hash binary data and return the hash value as a string of
		hexadecimal digits.
	**/
	public static function HashBytes(hash : FunIHash, message : Bytes) : String
	{
		hash.reset();
		hash.addBytes(message, 0, message.length);
		return FinishAsString(hash);
	}

	/**
		Add a string to a hash.
	**/
	public static function AddString(hash : FunIHash, value : String) : Void
	{
		var b = Bytes.ofString(value);
		hash.addBytes(b, 0, b.length);
	}

	/**
		Finish a hash and return the hash value as a string of
		hexadecimal digits.
	**/
	public static function FinishAsString(hash : FunIHash) : String
	{
		var b = Bytes.alloc(hash.getDigestSize());
		hash.finish(b, 0);
		return b.toHex();
	}
}
