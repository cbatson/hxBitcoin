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

package com.fundoware.engine.bigint;

import haxe.ds.Vector;
import haxe.io.Bytes;

@:allow(com.fundoware.engine.bigint)
abstract FunBigInt(FunBigInt_)
{
	//-----------------------------------------------------------------------
	// Public constants
	//-----------------------------------------------------------------------

	public static var ZERO(default, null) : FunBigInt = new FunBigInt(FunBigInt_.fromInt(0));
	public static var ONE(default, null) : FunBigInt = new FunBigInt(FunBigInt_.fromInt(1));
	public static var NEGATIVE_ONE(default, null) : FunBigInt = new FunBigInt(FunBigInt_.fromInt(-1));

	//-----------------------------------------------------------------------
	// Public interface
	//-----------------------------------------------------------------------

	public inline function sign() : Int
	{
		return FunBigInt_.sign1(this);
	}

	public inline function isZero() : Bool
	{
		return FunBigInt_.isZero1(this);
	}

	public inline function isNegative() : Bool
	{
		return FunBigInt_.isNegative1(this);
	}

	public inline function toString() : String
	{
		return FunBigInt_.toString1(this);
	}

	public inline function toHex() : String
	{
		return FunBigInt_.toHex1(this);
	}

	public inline function toBytes() : Bytes
	{
		return FunBigInt_.toBytes1(this);
	}

	public inline function toInts(output : Vector<Int>) : Int
	{
		return FunBigInt_.toInts1(this, output);
	}

	public static inline function fromInt(value : Int) : FunBigInt
	{
		return new FunBigInt(FunBigInt_.fromInt(value));
	}

	public static inline function fromString(value : String) : FunBigInt
	{
		return new FunBigInt(FunBigInt_.fromString(value));
	}

	public static inline function fromHex(value : String) : FunBigInt
	{
		return fromHexSigned(value);
	}

	public static inline function fromHexSigned(value : String) : FunBigInt
	{
		return new FunBigInt(FunBigInt_.fromHexSigned(value));
	}

	public static inline function fromHexUnsigned(value : String) : FunBigInt
	{
		return new FunBigInt(FunBigInt_.fromHexUnsigned(value));
	}

	public static inline function fromUnsignedInts(value : Vector<Int>, length : Int = 0) : FunBigInt
	{
		return new FunBigInt(FunBigInt_.fromUnsignedInts(value, length));
	}

	public inline function getBit(index : Int) : Int
	{
		return FunBigIntArithmetic.getBit(this, index);
	}

	//-----------------------------------------------------------------------
	// Operators
	//-----------------------------------------------------------------------

	// The declaration order of the operations is significant in Haxe.
	// Recommended order is:
	//	* FunBigInt <binOp> Int
	//	* FunBigInt <binOp> FunBigInt
	//	* FunBigInt <binOp> FunMutableBigInt

	// Unary negation
	@:op(-A) @:noCompletion public static inline function negate_(a : FunBigInt) : FunBigInt
	{
		return new FunBigInt(FunBigInt_.negate1(a));
	}

	// Binary equality
	@:op(A == B) @:noCompletion public static inline function eqInt_(a : FunBigInt, b : Int) : Bool
	{
		return FunBigInt_.equals2Int(a, b);
	}
	@:op(A == B) @:noCompletion public static inline function eq_(a : FunBigInt, b : FunBigInt) : Bool
	{
		return FunBigInt_.equals2(a, b);
	}
	@:op(A == B) @:noCompletion public static inline function eqMutable_(a : FunBigInt, b : FunMutableBigInt) : Bool
	{
		return FunBigInt_.equals2(a, b);
	}

	// Binary inequality
	@:op(A != B) @:noCompletion public static inline function ineqInt_(a : FunBigInt, b : Int) : Bool
	{
		return !FunBigInt_.equals2Int(a, b);
	}
	@:op(A != B) @:noCompletion public static inline function ineq_(a : FunBigInt, b : FunBigInt) : Bool
	{
		return !FunBigInt_.equals2(a, b);
	}
	@:op(A != B) @:noCompletion public static inline function ineqMutable_(a : FunBigInt, b : FunMutableBigInt) : Bool
	{
		return !FunBigInt_.equals2(a, b);
	}

	// Binary less than
	@:op(A < B) @:noCompletion public static inline function ltInt_(a : FunBigInt, b : Int) : Bool
	{
		return FunBigIntArithmetic.compareInt(a, b) < 0;
	}
	@:op(A < B) @:noCompletion public static inline function lt_(a : FunBigInt, b : FunBigInt) : Bool
	{
		return FunBigIntArithmetic.compare(a, b) < 0;
	}
	@:op(A < B) @:noCompletion public static inline function ltMutable_(a : FunBigInt, b : FunMutableBigInt) : Bool
	{
		return FunBigIntArithmetic.compare(a, b) < 0;
	}

	// Binary less than or equal
	@:op(A <= B) @:noCompletion public static inline function lteInt_(a : FunBigInt, b : Int) : Bool
	{
		return FunBigIntArithmetic.compareInt(a, b) <= 0;
	}
	@:op(A <= B) @:noCompletion public static inline function lte_(a : FunBigInt, b : FunBigInt) : Bool
	{
		return FunBigIntArithmetic.compare(a, b) <= 0;
	}
	@:op(A <= B) @:noCompletion public static inline function lteMutable_(a : FunBigInt, b : FunMutableBigInt) : Bool
	{
		return FunBigIntArithmetic.compare(a, b) <= 0;
	}

	// Binary greater than
	@:op(A > B) @:noCompletion public static inline function gtInt_(a : FunBigInt, b : Int) : Bool
	{
		return FunBigIntArithmetic.compareInt(a, b) > 0;
	}
	@:op(A > B) @:noCompletion public static inline function gt_(a : FunBigInt, b : FunBigInt) : Bool
	{
		return FunBigIntArithmetic.compare(a, b) > 0;
	}
	@:op(A > B) @:noCompletion public static inline function gtMutable_(a : FunBigInt, b : FunMutableBigInt) : Bool
	{
		return FunBigIntArithmetic.compare(a, b) > 0;
	}

	// Binary greater than or equal
	@:op(A >= B) @:noCompletion public static inline function gteInt_(a : FunBigInt, b : Int) : Bool
	{
		return FunBigIntArithmetic.compareInt(a, b) >= 0;
	}
	@:op(A >= B) @:noCompletion public static inline function gte_(a : FunBigInt, b : FunBigInt) : Bool
	{
		return FunBigIntArithmetic.compare(a, b) >= 0;
	}
	@:op(A >= B) @:noCompletion public static inline function gteMutable_(a : FunBigInt, b : FunMutableBigInt) : Bool
	{
		return FunBigIntArithmetic.compare(a, b) >= 0;
	}

	// Binary addition
	@:op(A + B) @:noCompletion public static inline function addInt_(a : FunBigInt, b : Int) : FunBigInt
	{
		return new FunBigInt(FunBigInt_.addInt2(a, b));
	}
	@:op(A + B) @:noCompletion public static inline function add_(a : FunBigInt, b : FunBigInt) : FunBigInt
	{
		return new FunBigInt(FunBigInt_.add2(a, b));
	}
	@:op(A + B) @:noCompletion public static inline function addMutable_(a : FunBigInt, b : FunMutableBigInt) : FunBigInt
	{
		return new FunBigInt(FunBigInt_.add2(a, b));
	}

	// Binary subtraction
	@:op(A - B) @:noCompletion public static inline function subInt_(a : FunBigInt, b : Int) : FunBigInt
	{
		return new FunBigInt(FunBigInt_.subInt2(a, b));
	}
	@:op(A - B) @:noCompletion public static inline function sub_(a : FunBigInt, b : FunBigInt) : FunBigInt
	{
		return new FunBigInt(FunBigInt_.sub2(a, b));
	}
	@:op(A - B) @:noCompletion public static inline function subMutable_(a : FunBigInt, b : FunMutableBigInt) : FunBigInt
	{
		return new FunBigInt(FunBigInt_.sub2(a, b));
	}

	// Binary multiplication
	@:op(A * B) @:noCompletion public static inline function mulInt_(a : FunBigInt, b : Int) : FunBigInt
	{
		return new FunBigInt(FunBigInt_.multiplyInt2(a, b));
	}
	@:op(A * B) @:noCompletion public static inline function mul_(a : FunBigInt, b : FunBigInt) : FunBigInt
	{
		return new FunBigInt(FunBigInt_.multiply2(a, b));
	}
	@:op(A * B) @:noCompletion public static inline function mulMutable_(a : FunBigInt, b : FunMutableBigInt) : FunBigInt
	{
		return new FunBigInt(FunBigInt_.multiply2(a, b));
	}

	// Binary division
	@:op(A / B) @:noCompletion public static inline function divInt_(a : FunBigInt, b : Int) : FunBigInt
	{
		return new FunBigInt(FunBigInt_.divideInt2(a, b));
	}
	@:op(A / B) @:noCompletion public static inline function div_(a : FunBigInt, b : FunBigInt) : FunBigInt
	{
		return new FunBigInt(FunBigInt_.divide2(a, b));
	}
	@:op(A / B) @:noCompletion public static inline function divMutable_(a : FunBigInt, b : FunMutableBigInt) : FunBigInt
	{
		return new FunBigInt(FunBigInt_.divide2(a, b));
	}

	// Binary modulus
	@:op(A % B) @:noCompletion public static inline function modInt_(a : FunBigInt, b : Int) : Int
	{
		return FunBigInt_.modulusInt2(a, b);
	}
	@:op(A % B) @:noCompletion public static inline function mod_(a : FunBigInt, b : FunBigInt) : FunBigInt
	{
		return new FunBigInt(FunBigInt_.modulus2(a, b));
	}
	@:op(A % B) @:noCompletion public static inline function modMutable_(a : FunBigInt, b : FunMutableBigInt) : FunBigInt
	{
		return new FunBigInt(FunBigInt_.modulus2(a, b));
	}

	// Binary AND
	@:op(A & B) @:noCompletion public static inline function andInt_(a : FunBigInt, b : Int) : Int
	{
		return FunBigIntArithmetic.bitwiseAndInt(a, b);
	}

	// Binary shift left
	@:op(A << B) @:noCompletion public static inline function asl_(a : FunBigInt, b : Int) : FunBigInt
	{
		return new FunBigInt(FunBigInt_.arithmeticShiftLeft2(a, b));
	}

	// Binary shift right
	@:op(A >> B) @:noCompletion public static inline function asr_(a : FunBigInt, b : Int) : FunBigInt
	{
		return new FunBigInt(FunBigInt_.arithmeticShiftRight2(a, b));
	}

	//-----------------------------------------------------------------------
	// Automatic conversions
	//-----------------------------------------------------------------------

	@:from @:noCompletion public static inline function fromInt_(a : Int) : FunBigInt
	{
		return new FunBigInt(FunBigInt_.fromInt(a));
	}

	@:to @:noCompletion public inline function toFunBigInt_() : FunBigInt_
	{
		return this;
	}

	@:to @:noCompletion public inline function toFunMutableBigInt() : FunMutableBigInt
	{
		return new FunMutableBigInt(FunMutableBigInt_.fromBigInt(this));
	}

	//-----------------------------------------------------------------------
	// Private implementation
	//-----------------------------------------------------------------------

	@:noCompletion private inline function new(a : FunBigInt_)
	{
		this = a;
	}
}
