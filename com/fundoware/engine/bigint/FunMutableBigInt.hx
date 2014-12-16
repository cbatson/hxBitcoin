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
abstract FunMutableBigInt(FunMutableBigInt_)
{
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

	public inline function setFromInt(value : Int) : Void
	{
		var a : FunMutableBigInt_ = this;
		a.setFromInt(value);
	}

	public inline function setFromUnsignedInts(value : Vector<Int>, length : Int = 0) : Void
	{
		var a : FunMutableBigInt_ = this;
		a.setFromUnsignedInts(value, length);
	}

	public inline function setFromBigEndianBytesUnsigned(value : Bytes, offset : Int = 0, length : Int = 0) : Void
	{
		var a : FunMutableBigInt_ = this;
		a.setFromBigEndianBytesUnsigned(value, offset, length);
	}

	public inline function setFromLittleEndianBytesUnsigned(value : Bytes, offset : Int = 0, length : Int = 0) : Void
	{
		var a : FunMutableBigInt_ = this;
		a.setFromLittleEndianBytesUnsigned(value, offset, length);
	}

	public inline function clear() : Void
	{
		var a : FunMutableBigInt_ = this;
		a.clear();
	}

	public inline function copyFrom(other : FunBigInt) : Void
	{
		var a : FunMutableBigInt_ = this;
		a.copyFrom(other);
	}

	public inline function getBit(index : Int) : Int
	{
		return FunBigIntArithmetic.getBit(this, index);
	}

	public static function fromBigEndianBytesUnsigned(value : Bytes) : FunMutableBigInt
	{
		var r = new FunMutableBigInt_();
		r.setFromBigEndianBytesUnsigned(value);
		return new FunMutableBigInt(r);
	}

	public static function fromLittleEndianBytesUnsigned(value : Bytes) : FunMutableBigInt
	{
		var r = new FunMutableBigInt_();
		r.setFromLittleEndianBytesUnsigned(value);
		return new FunMutableBigInt(r);
	}

	//-----------------------------------------------------------------------
	// Operators
	//-----------------------------------------------------------------------

	// The declaration order of the operations is significant in Haxe.
	// Recommended order is:
	//	* FunMutableBigInt <binOp=> Int
	//	* FunMutableBigInt <binOp=> FunBigInt
	//	* FunMutableBigInt <binOp=> FunMutableBigInt
	//	* FunMutableBigInt <binOp> Int
	//	* FunMutableBigInt <binOp> FunBigInt
	//	* FunMutableBigInt <binOp> FunMutableBigInt

	// Unary negation
	@:op(-A) @:noCompletion public static inline function negate_(a : FunMutableBigInt) : FunBigInt
	{
		return new FunBigInt(FunBigInt_.negate1(a));
	}

	// Binary equality
	@:op(A == B) @:noCompletion public static inline function eqInt_(a : FunMutableBigInt, b : Int) : Bool
	{
		return FunBigInt_.equals2Int(a, b);
	}
	@:op(A == B) @:noCompletion public static inline function eq_(a : FunMutableBigInt, b : FunBigInt) : Bool
	{
		return FunBigInt_.equals2(a, b);
	}
	@:op(A == B) @:noCompletion public static inline function eqMutable_(a : FunMutableBigInt, b : FunMutableBigInt) : Bool
	{
		return FunBigInt_.equals2(a, b);
	}

	// Binary inequality
	@:op(A != B) @:noCompletion public static inline function ineqInt_(a : FunMutableBigInt, b : Int) : Bool
	{
		return !FunBigInt_.equals2Int(a, b);
	}
	@:op(A != B) @:noCompletion public static inline function ineq_(a : FunMutableBigInt, b : FunBigInt) : Bool
	{
		return !FunBigInt_.equals2(a, b);
	}
	@:op(A != B) @:noCompletion public static inline function ineqMutable_(a : FunMutableBigInt, b : FunMutableBigInt) : Bool
	{
		return !FunBigInt_.equals2(a, b);
	}

	// Binary less than
	@:op(A < B) @:noCompletion public static inline function ltInt_(a : FunMutableBigInt, b : Int) : Bool
	{
		return FunBigIntArithmetic.compareInt(a, b) < 0;
	}
	@:op(A < B) @:noCompletion public static inline function lt_(a : FunMutableBigInt, b : FunBigInt) : Bool
	{
		return FunBigIntArithmetic.compare(a, b) < 0;
	}
	@:op(A < B) @:noCompletion public static inline function ltMutable_(a : FunMutableBigInt, b : FunMutableBigInt) : Bool
	{
		return FunBigIntArithmetic.compare(a, b) < 0;
	}

	// Binary less than or equal
	@:op(A <= B) @:noCompletion public static inline function lteInt_(a : FunMutableBigInt, b : Int) : Bool
	{
		return FunBigIntArithmetic.compareInt(a, b) <= 0;
	}
	@:op(A <= B) @:noCompletion public static inline function lte_(a : FunMutableBigInt, b : FunBigInt) : Bool
	{
		return FunBigIntArithmetic.compare(a, b) <= 0;
	}
	@:op(A <= B) @:noCompletion public static inline function lteMutable_(a : FunMutableBigInt, b : FunMutableBigInt) : Bool
	{
		return FunBigIntArithmetic.compare(a, b) <= 0;
	}

	// Binary greater than
	@:op(A > B) @:noCompletion public static inline function gtInt_(a : FunMutableBigInt, b : Int) : Bool
	{
		return FunBigIntArithmetic.compareInt(a, b) > 0;
	}
	@:op(A > B) @:noCompletion public static inline function gt_(a : FunMutableBigInt, b : FunBigInt) : Bool
	{
		return FunBigIntArithmetic.compare(a, b) > 0;
	}
	@:op(A > B) @:noCompletion public static inline function gtMutable_(a : FunMutableBigInt, b : FunMutableBigInt) : Bool
	{
		return FunBigIntArithmetic.compare(a, b) > 0;
	}

	// Binary greater than or equal
	@:op(A >= B) @:noCompletion public static inline function gteInt_(a : FunMutableBigInt, b : Int) : Bool
	{
		return FunBigIntArithmetic.compareInt(a, b) >= 0;
	}
	@:op(A >= B) @:noCompletion public static inline function gte_(a : FunMutableBigInt, b : FunBigInt) : Bool
	{
		return FunBigIntArithmetic.compare(a, b) >= 0;
	}
	@:op(A >= B) @:noCompletion public static inline function gteMutable_(a : FunMutableBigInt, b : FunMutableBigInt) : Bool
	{
		return FunBigIntArithmetic.compare(a, b) >= 0;
	}

	// Binary addition
	@:op(A += B) @:noCompletion public static inline function addAssignInt_(a : FunMutableBigInt, b : Int) : FunMutableBigInt
	{
		FunBigIntArithmetic.addInt(a, a, b);
		return a;
	}
	@:op(A += B) @:noCompletion public static inline function addAssign_(a : FunMutableBigInt, b : FunBigInt) : FunMutableBigInt
	{
		FunBigIntArithmetic.add(a, a, b);
		return a;
	}
	@:op(A += B) @:noCompletion public static inline function addAssignMutable_(a : FunMutableBigInt, b : FunMutableBigInt) : FunMutableBigInt
	{
		FunBigIntArithmetic.add(a, a, b);
		return a;
	}
	@:op(A + B) @:noCompletion public static inline function addInt_(a : FunMutableBigInt, b : Int) : FunBigInt
	{
		return new FunBigInt(FunBigInt_.addInt2(a, b));
	}
	@:op(A + B) @:noCompletion public static inline function add_(a : FunMutableBigInt, b : FunBigInt) : FunBigInt
	{
		return new FunBigInt(FunBigInt_.add2(a, b));
	}
	@:op(A + B) @:noCompletion public static inline function addMutable_(a : FunMutableBigInt, b : FunMutableBigInt) : FunBigInt
	{
		return new FunBigInt(FunBigInt_.add2(a, b));
	}

	// Binary subtraction
	@:op(A -= B) @:noCompletion public static inline function subAssignInt_(a : FunMutableBigInt, b : Int) : FunMutableBigInt
	{
		FunBigIntArithmetic.subtractInt(a, a, b);
		return a;
	}
	@:op(A -= B) @:noCompletion public static inline function subAssign_(a : FunMutableBigInt, b : FunBigInt) : FunMutableBigInt
	{
		FunBigIntArithmetic.subtract(a, a, b);
		return a;
	}
	@:op(A -= B) @:noCompletion public static inline function subAssignMutable_(a : FunMutableBigInt, b : FunMutableBigInt) : FunMutableBigInt
	{
		FunBigIntArithmetic.subtract(a, a, b);
		return a;
	}
	@:op(A - B) @:noCompletion public static inline function subInt_(a : FunMutableBigInt, b : Int) : FunBigInt
	{
		return new FunBigInt(FunBigInt_.subInt2(a, b));
	}
	@:op(A - B) @:noCompletion public static inline function sub_(a : FunMutableBigInt, b : FunBigInt) : FunBigInt
	{
		return new FunBigInt(FunBigInt_.sub2(a, b));
	}
	@:op(A - B) @:noCompletion public static inline function subMutable_(a : FunMutableBigInt, b : FunMutableBigInt) : FunBigInt
	{
		return new FunBigInt(FunBigInt_.sub2(a, b));
	}

	// Binary multiplication
	@:op(A *= B) @:noCompletion public static inline function mulAssignInt_(a : FunMutableBigInt, b : Int) : FunMutableBigInt
	{
		FunMutableBigInt_.multiplyAssignInt2(a, b);
		return a;
	}
	@:op(A *= B) @:noCompletion public static inline function mulAssign_(a : FunMutableBigInt, b : FunBigInt) : FunMutableBigInt
	{
		FunMutableBigInt_.multiplyAssign2(a, b);
		return a;
	}
	@:op(A *= B) @:noCompletion public static inline function mulAssignMutable_(a : FunMutableBigInt, b : FunMutableBigInt) : FunMutableBigInt
	{
		FunMutableBigInt_.multiplyAssign2(a, b);
		return a;
	}
	@:op(A * B) @:noCompletion public static inline function mulInt_(a : FunMutableBigInt, b : Int) : FunBigInt
	{
		return new FunBigInt(FunBigInt_.multiplyInt2(a, b));
	}
	@:op(A * B) @:noCompletion public static inline function mul_(a : FunMutableBigInt, b : FunBigInt) : FunBigInt
	{
		return new FunBigInt(FunBigInt_.multiply2(a, b));
	}
	@:op(A * B) @:noCompletion public static inline function mulMutable_(a : FunMutableBigInt, b : FunMutableBigInt) : FunBigInt
	{
		return new FunBigInt(FunBigInt_.multiply2(a, b));
	}

	// Binary division
	@:op(A /= B) @:noCompletion public static inline function divAssignInt_(a : FunMutableBigInt, b : Int) : FunMutableBigInt
	{
		FunMutableBigInt_.divideAssignInt2(a, b);
		return a;
	}
	@:op(A /= B) @:noCompletion public static inline function divAssign_(a : FunMutableBigInt, b : FunBigInt) : FunMutableBigInt
	{
		FunMutableBigInt_.divideAssign2(a, b);
		return a;
	}
	@:op(A /= B) @:noCompletion public static inline function divAssignMutable_(a : FunMutableBigInt, b : FunMutableBigInt) : FunMutableBigInt
	{
		FunMutableBigInt_.divideAssign2(a, b);
		return a;
	}
	@:op(A / B) @:noCompletion public static inline function divInt_(a : FunMutableBigInt, b : Int) : FunBigInt
	{
		return new FunBigInt(FunBigInt_.divideInt2(a, b));
	}
	@:op(A / B) @:noCompletion public static inline function div_(a : FunMutableBigInt, b : FunBigInt) : FunBigInt
	{
		return new FunBigInt(FunBigInt_.divide2(a, b));
	}
	@:op(A / B) @:noCompletion public static inline function divMutable_(a : FunMutableBigInt, b : FunMutableBigInt) : FunBigInt
	{
		return new FunBigInt(FunBigInt_.divide2(a, b));
	}

	// Binary modulus
	@:op(A %= B) @:noCompletion public static inline function modAssignInt_(a : FunMutableBigInt, b : Int) : FunMutableBigInt
	{
		FunMutableBigInt_.modulusAssignInt2(a, b);
		return a;
	}
	@:op(A %= B) @:noCompletion public static inline function modAssign_(a : FunMutableBigInt, b : FunBigInt) : FunMutableBigInt
	{
		FunMutableBigInt_.modulusAssign2(a, b);
		return a;
	}
	@:op(A %= B) @:noCompletion public static inline function modAssignMutable_(a : FunMutableBigInt, b : FunMutableBigInt) : FunMutableBigInt
	{
		FunMutableBigInt_.modulusAssign2(a, b);
		return a;
	}
	@:op(A % B) @:noCompletion public static inline function modInt_(a : FunMutableBigInt, b : Int) : Int
	{
		return FunBigInt_.modulusInt2(a, b);
	}
	@:op(A % B) @:noCompletion public static inline function mod_(a : FunMutableBigInt, b : FunBigInt) : FunBigInt
	{
		return new FunBigInt(FunBigInt_.modulus2(a, b));
	}
	@:op(A % B) @:noCompletion public static inline function modMutable_(a : FunMutableBigInt, b : FunMutableBigInt) : FunBigInt
	{
		return new FunBigInt(FunBigInt_.modulus2(a, b));
	}

	// Binary AND
	@:op(A & B) @:noCompletion public static inline function andInt_(a : FunMutableBigInt, b : Int) : Int
	{
		return FunBigIntArithmetic.bitwiseAndInt(a, b);
	}

	// Binary shift left
	@:op(A <<= B) @:noCompletion public static inline function arithmeticShiftLeftAssign_(a : FunMutableBigInt, b : Int) : FunMutableBigInt
	{
		FunMutableBigInt_.arithmeticShiftLeftAssign2(a, b);
		return a;
	}
	@:op(A << B) @:noCompletion public static inline function asl_(a : FunMutableBigInt, b : Int) : FunBigInt
	{
		return new FunBigInt(FunBigInt_.arithmeticShiftLeft2(a, b));
	}

	// Binary shift right
	@:op(A >>= B) @:noCompletion public static inline function arithmeticShiftRightAssign_(a : FunMutableBigInt, b : Int) : FunMutableBigInt
	{
		FunMutableBigInt_.arithmeticShiftRightAssign2(a, b);
		return a;
	}
	@:op(A >> B) @:noCompletion public static inline function asr_(a : FunMutableBigInt, b : Int) : FunBigInt
	{
		return new FunBigInt(FunBigInt_.arithmeticShiftRight2(a, b));
	}

	//-----------------------------------------------------------------------
	// Automatic conversions
	//-----------------------------------------------------------------------

	@:from @:noCompletion public static inline function fromInt_(a : Int) : FunMutableBigInt
	{
		return new FunMutableBigInt(FunMutableBigInt_.fromInt(a));
	}

	@:from @:noCompletion public static inline function fromFunBigInt_(a : FunBigInt_) : FunMutableBigInt
	{
		return new FunMutableBigInt(FunMutableBigInt_.fromBigInt(a));
	}

	@:from @:noCompletion public static inline function fromFunMutableBigInt_(a : FunMutableBigInt_) : FunMutableBigInt
	{
		return new FunMutableBigInt(FunMutableBigInt_.fromBigInt(a));
	}

	@:to @:noCompletion public inline function toFunMutableBigInt_() : FunMutableBigInt_
	{
		return this;
	}

	@:to @:noCompletion public inline function toFunBigInt() : FunBigInt
	{
		return new FunBigInt(this);
	}

	//-----------------------------------------------------------------------
	// Private implementation
	//-----------------------------------------------------------------------

	private inline function new(a : FunMutableBigInt_)
	{
		this = a;
	}
}
