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

package com.fundoware.engine.exception;

class FunExceptions
{
	public static inline var FUN_NULL_ARGUMENT = "null argument";
	public static inline var FUN_INVALID_ARGUMENT = "invalid argument";
	public static inline var FUN_BUFFER_TOO_SMALL = "buffer too small";
	public static inline var FUN_OVERFLOW = "overflow";
	public static inline var FUN_ABSTRACT_METHOD = "abstract method";
	public static inline var FUN_ILLEGAL_STATE = "illegal state";
	public static inline var FUN_NOT_IMPLEMENTED = "not implemented";
	public static inline var FUN_DIVISION_BY_ZERO = "division by zero";
	public static inline var FUN_INVALID_OPERATION = "invalid operation";
	public static inline var FUN_CHECKSUM_MISMATCH = "checksum mismatch";

	public static inline function rethrow(e : Dynamic) : Dynamic
	{
		#if neko
			return neko.Lib.rethrow(e);
		#else
			throw e;
		#end
	}
}
