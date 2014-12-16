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

package com.fundoware.engine.crypto.util;

import haxe.io.Bytes;
import haxe.io.BytesData;

class CBC
{
	public static function encrypt(dst : Bytes, src : Bytes, blockSize : Int, encrypt : Bytes->Int->Bytes->Int->Void, ivIn : Bytes) : Void
	{
		var ivLength : Int = ivIn.length;
		if (ivLength < blockSize)
		{
			throw "initial vector too small";
		}
		var iv = ivIn.getData();
		var l : Int = src.length;
		var i : Int = 0;
		var ivi : Int = 0;
        var sb = src.getData();
		while (i < l)
		{
			for (j in 0 ... blockSize)
			{
				dst.set(i + j, Bytes.fastGet(sb, i + j) ^ Bytes.fastGet(iv, ivi + j));
			}
			encrypt(dst, i, dst, i);
			iv = dst.getData();
			ivi = i;
			i += blockSize;
		}
	}

	public static function decrypt(dst : Bytes, src : Bytes, blockSize : Int, decrypt : Bytes->Int->Bytes->Int->Void, ivIn : Bytes) : Void
	{
		var ivLength : Int = ivIn.length;
		if (ivLength < blockSize)
		{
			throw "initial vector too small";
		}
		var iv = ivIn.getData();
		var i : Int = src.length;
		var ivi : Int = src.length - blockSize;
		var c : BytesData = src.getData();
		var db : BytesData = dst.getData();
		while (i > 0)
		{
			i -= blockSize;
			decrypt(src, i, dst, i);
			ivi -= blockSize;
			if (ivi < 0)
			{
				ivi = 0;
				c = iv;
			}
			for (j in 0 ... blockSize)
			{
				dst.set(i + j, Bytes.fastGet(db, i + j) ^ Bytes.fastGet(c, ivi + j));
			}
		}
	}
}
