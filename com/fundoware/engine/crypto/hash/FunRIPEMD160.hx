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

import com.fundoware.engine.crypto.hash.impl.FunBlockHashBase;
import com.fundoware.engine.exception.FunExceptions;
import com.fundoware.engine.math.FunInteger;
import haxe.io.Bytes;

class FunRIPEMD160 extends FunBlockHashBase implements FunIHash
{
	//-----------------------------------------------------------------------
	// Helpers
	//-----------------------------------------------------------------------

	public static inline function HashString(s : String) : String
	{
		return FunHashTools.HashString(new FunRIPEMD160(), s);
	}

	public static inline function HashBytes(data : Bytes) : String
	{
		return FunHashTools.HashBytes(new FunRIPEMD160(), data);
	}

	//-----------------------------------------------------------------------
	// Public interface
	//-----------------------------------------------------------------------

	public static inline var kDigestSize : Int = 20;
	public static inline var kBlockSize : Int = 64;

	public function new()
	{
		super(kBlockSize);
		reset();
	}

	public override function reset() : Void
	{
		super.reset();
		h0 = 0x67452301;
		h1 = 0xEFCDAB89;
		h2 = 0x98BADCFE;
		h3 = 0x10325476;
		h4 = 0xC3D2E1F0;
	}

	public function addByte(byte : Int) : Void
	{
		addByteLE(byte);
	}

	public function addBytes(bytes : Bytes, offset : Int, length : Int) : Void
	{
		addBytesLE(bytes, offset, length);
	}

	public function finish(digest : Bytes, offset : Int) : Void
	{
		if ((offset + kDigestSize) > digest.length)
		{
			throw FunExceptions.FUN_BUFFER_TOO_SMALL;
		}

		var len = m_length;
		addByteLE(0x80);
		while ((m_length & 0x3f) != 56)
		{
			addByteLE(0x00);
		}
		m_block.set(14, len << 3);
		m_block.set(15, len >>> 29);
		processBlock();

		FunBlockHashBase.putLE(digest, offset +  0, h0);
		FunBlockHashBase.putLE(digest, offset +  4, h1);
		FunBlockHashBase.putLE(digest, offset +  8, h2);
		FunBlockHashBase.putLE(digest, offset + 12, h3);
		FunBlockHashBase.putLE(digest, offset + 16, h4);
	}

	public function getDigestSize() : Int
	{
		return kDigestSize;
	}

	public function clear() : Void
	{
		super.doClear();
		reset();
	}

	//-----------------------------------------------------------------------
	// Private implementation
	//-----------------------------------------------------------------------

	private override function processBlock() : Void
	{
		// http://homes.esat.kuleuven.be/~bosselae/ripemd/rmd160.txt

		var A  = h0, B  = h1, C  = h2, D  = h3, E  = h4;
		var Ap = h0, Bp = h1, Cp = h2, Dp = h3, Ep = h4;

		A  = f0 (A , B , C ,                                 D , E ,  0, 11);
		Ap = f0p(Ap, Bp, Cp,                                 Dp, Ep,  5,  8);
		E  = f0 (E , A , B , C  = FunInteger.rotateLeft(C , 10), D ,  1, 14);
		Ep = f0p(Ep, Ap, Bp, Cp = FunInteger.rotateLeft(Cp, 10), Dp, 14,  9);
		D  = f0 (D , E , A , B  = FunInteger.rotateLeft(B , 10), C ,  2, 15);
		Dp = f0p(Dp, Ep, Ap, Bp = FunInteger.rotateLeft(Bp, 10), Cp,  7,  9);
		C  = f0 (C , D , E , A  = FunInteger.rotateLeft(A , 10), B ,  3, 12);
		Cp = f0p(Cp, Dp, Ep, Ap = FunInteger.rotateLeft(Ap, 10), Bp,  0, 11);
		B  = f0 (B , C , D , E  = FunInteger.rotateLeft(E , 10), A ,  4,  5);
		Bp = f0p(Bp, Cp, Dp, Ep = FunInteger.rotateLeft(Ep, 10), Ap,  9, 13);
		A  = f0 (A , B , C , D  = FunInteger.rotateLeft(D , 10), E ,  5,  8);
		Ap = f0p(Ap, Bp, Cp, Dp = FunInteger.rotateLeft(Dp, 10), Ep,  2, 15);
		E  = f0 (E , A , B , C  = FunInteger.rotateLeft(C , 10), D ,  6,  7);
		Ep = f0p(Ep, Ap, Bp, Cp = FunInteger.rotateLeft(Cp, 10), Dp, 11, 15);
		D  = f0 (D , E , A , B  = FunInteger.rotateLeft(B , 10), C ,  7,  9);
		Dp = f0p(Dp, Ep, Ap, Bp = FunInteger.rotateLeft(Bp, 10), Cp,  4,  5);
		C  = f0 (C , D , E , A  = FunInteger.rotateLeft(A , 10), B ,  8, 11);
		Cp = f0p(Cp, Dp, Ep, Ap = FunInteger.rotateLeft(Ap, 10), Bp, 13,  7);
		B  = f0 (B , C , D , E  = FunInteger.rotateLeft(E , 10), A ,  9, 13);
		Bp = f0p(Bp, Cp, Dp, Ep = FunInteger.rotateLeft(Ep, 10), Ap,  6,  7);
		A  = f0 (A , B , C , D  = FunInteger.rotateLeft(D , 10), E , 10, 14);
		Ap = f0p(Ap, Bp, Cp, Dp = FunInteger.rotateLeft(Dp, 10), Ep, 15,  8);
		E  = f0 (E , A , B , C  = FunInteger.rotateLeft(C , 10), D , 11, 15);
		Ep = f0p(Ep, Ap, Bp, Cp = FunInteger.rotateLeft(Cp, 10), Dp,  8, 11);
		D  = f0 (D , E , A , B  = FunInteger.rotateLeft(B , 10), C , 12,  6);
		Dp = f0p(Dp, Ep, Ap, Bp = FunInteger.rotateLeft(Bp, 10), Cp,  1, 14);
		C  = f0 (C , D , E , A  = FunInteger.rotateLeft(A , 10), B , 13,  7);
		Cp = f0p(Cp, Dp, Ep, Ap = FunInteger.rotateLeft(Ap, 10), Bp, 10, 14);
		B  = f0 (B , C , D , E  = FunInteger.rotateLeft(E , 10), A , 14,  9);
		Bp = f0p(Bp, Cp, Dp, Ep = FunInteger.rotateLeft(Ep, 10), Ap,  3, 12);
		A  = f0 (A , B , C , D  = FunInteger.rotateLeft(D , 10), E , 15,  8);
		Ap = f0p(Ap, Bp, Cp, Dp = FunInteger.rotateLeft(Dp, 10), Ep, 12,  6);
		E  = f1 (E , A , B , C  = FunInteger.rotateLeft(C , 10), D ,  7,  7);
		Ep = f1p(Ep, Ap, Bp, Cp = FunInteger.rotateLeft(Cp, 10), Dp,  6,  9);
		D  = f1 (D , E , A , B  = FunInteger.rotateLeft(B , 10), C ,  4,  6);
		Dp = f1p(Dp, Ep, Ap, Bp = FunInteger.rotateLeft(Bp, 10), Cp, 11, 13);
		C  = f1 (C , D , E , A  = FunInteger.rotateLeft(A , 10), B , 13,  8);
		Cp = f1p(Cp, Dp, Ep, Ap = FunInteger.rotateLeft(Ap, 10), Bp,  3, 15);
		B  = f1 (B , C , D , E  = FunInteger.rotateLeft(E , 10), A ,  1, 13);
		Bp = f1p(Bp, Cp, Dp, Ep = FunInteger.rotateLeft(Ep, 10), Ap,  7,  7);
		A  = f1 (A , B , C , D  = FunInteger.rotateLeft(D , 10), E , 10, 11);
		Ap = f1p(Ap, Bp, Cp, Dp = FunInteger.rotateLeft(Dp, 10), Ep,  0, 12);
		E  = f1 (E , A , B , C  = FunInteger.rotateLeft(C , 10), D ,  6,  9);
		Ep = f1p(Ep, Ap, Bp, Cp = FunInteger.rotateLeft(Cp, 10), Dp, 13,  8);
		D  = f1 (D , E , A , B  = FunInteger.rotateLeft(B , 10), C , 15,  7);
		Dp = f1p(Dp, Ep, Ap, Bp = FunInteger.rotateLeft(Bp, 10), Cp,  5,  9);
		C  = f1 (C , D , E , A  = FunInteger.rotateLeft(A , 10), B ,  3, 15);
		Cp = f1p(Cp, Dp, Ep, Ap = FunInteger.rotateLeft(Ap, 10), Bp, 10, 11);
		B  = f1 (B , C , D , E  = FunInteger.rotateLeft(E , 10), A , 12,  7);
		Bp = f1p(Bp, Cp, Dp, Ep = FunInteger.rotateLeft(Ep, 10), Ap, 14,  7);
		A  = f1 (A , B , C , D  = FunInteger.rotateLeft(D , 10), E ,  0, 12);
		Ap = f1p(Ap, Bp, Cp, Dp = FunInteger.rotateLeft(Dp, 10), Ep, 15,  7);
		E  = f1 (E , A , B , C  = FunInteger.rotateLeft(C , 10), D ,  9, 15);
		Ep = f1p(Ep, Ap, Bp, Cp = FunInteger.rotateLeft(Cp, 10), Dp,  8, 12);
		D  = f1 (D , E , A , B  = FunInteger.rotateLeft(B , 10), C ,  5,  9);
		Dp = f1p(Dp, Ep, Ap, Bp = FunInteger.rotateLeft(Bp, 10), Cp, 12,  7);
		C  = f1 (C , D , E , A  = FunInteger.rotateLeft(A , 10), B ,  2, 11);
		Cp = f1p(Cp, Dp, Ep, Ap = FunInteger.rotateLeft(Ap, 10), Bp,  4,  6);
		B  = f1 (B , C , D , E  = FunInteger.rotateLeft(E , 10), A , 14,  7);
		Bp = f1p(Bp, Cp, Dp, Ep = FunInteger.rotateLeft(Ep, 10), Ap,  9, 15);
		A  = f1 (A , B , C , D  = FunInteger.rotateLeft(D , 10), E , 11, 13);
		Ap = f1p(Ap, Bp, Cp, Dp = FunInteger.rotateLeft(Dp, 10), Ep,  1, 13);
		E  = f1 (E , A , B , C  = FunInteger.rotateLeft(C , 10), D ,  8, 12);
		Ep = f1p(Ep, Ap, Bp, Cp = FunInteger.rotateLeft(Cp, 10), Dp,  2, 11);
		D  = f2 (D , E , A , B  = FunInteger.rotateLeft(B , 10), C ,  3, 11);
		Dp = f2p(Dp, Ep, Ap, Bp = FunInteger.rotateLeft(Bp, 10), Cp, 15,  9);
		C  = f2 (C , D , E , A  = FunInteger.rotateLeft(A , 10), B , 10, 13);
		Cp = f2p(Cp, Dp, Ep, Ap = FunInteger.rotateLeft(Ap, 10), Bp,  5,  7);
		B  = f2 (B , C , D , E  = FunInteger.rotateLeft(E , 10), A , 14,  6);
		Bp = f2p(Bp, Cp, Dp, Ep = FunInteger.rotateLeft(Ep, 10), Ap,  1, 15);
		A  = f2 (A , B , C , D  = FunInteger.rotateLeft(D , 10), E ,  4,  7);
		Ap = f2p(Ap, Bp, Cp, Dp = FunInteger.rotateLeft(Dp, 10), Ep,  3, 11);
		E  = f2 (E , A , B , C  = FunInteger.rotateLeft(C , 10), D ,  9, 14);
		Ep = f2p(Ep, Ap, Bp, Cp = FunInteger.rotateLeft(Cp, 10), Dp,  7,  8);
		D  = f2 (D , E , A , B  = FunInteger.rotateLeft(B , 10), C , 15,  9);
		Dp = f2p(Dp, Ep, Ap, Bp = FunInteger.rotateLeft(Bp, 10), Cp, 14,  6);
		C  = f2 (C , D , E , A  = FunInteger.rotateLeft(A , 10), B ,  8, 13);
		Cp = f2p(Cp, Dp, Ep, Ap = FunInteger.rotateLeft(Ap, 10), Bp,  6,  6);
		B  = f2 (B , C , D , E  = FunInteger.rotateLeft(E , 10), A ,  1, 15);
		Bp = f2p(Bp, Cp, Dp, Ep = FunInteger.rotateLeft(Ep, 10), Ap,  9, 14);
		A  = f2 (A , B , C , D  = FunInteger.rotateLeft(D , 10), E ,  2, 14);
		Ap = f2p(Ap, Bp, Cp, Dp = FunInteger.rotateLeft(Dp, 10), Ep, 11, 12);
		E  = f2 (E , A , B , C  = FunInteger.rotateLeft(C , 10), D ,  7,  8);
		Ep = f2p(Ep, Ap, Bp, Cp = FunInteger.rotateLeft(Cp, 10), Dp,  8, 13);
		D  = f2 (D , E , A , B  = FunInteger.rotateLeft(B , 10), C ,  0, 13);
		Dp = f2p(Dp, Ep, Ap, Bp = FunInteger.rotateLeft(Bp, 10), Cp, 12,  5);
		C  = f2 (C , D , E , A  = FunInteger.rotateLeft(A , 10), B ,  6,  6);
		Cp = f2p(Cp, Dp, Ep, Ap = FunInteger.rotateLeft(Ap, 10), Bp,  2, 14);
		B  = f2 (B , C , D , E  = FunInteger.rotateLeft(E , 10), A , 13,  5);
		Bp = f2p(Bp, Cp, Dp, Ep = FunInteger.rotateLeft(Ep, 10), Ap, 10, 13);
		A  = f2 (A , B , C , D  = FunInteger.rotateLeft(D , 10), E , 11, 12);
		Ap = f2p(Ap, Bp, Cp, Dp = FunInteger.rotateLeft(Dp, 10), Ep,  0, 13);
		E  = f2 (E , A , B , C  = FunInteger.rotateLeft(C , 10), D ,  5,  7);
		Ep = f2p(Ep, Ap, Bp, Cp = FunInteger.rotateLeft(Cp, 10), Dp,  4,  7);
		D  = f2 (D , E , A , B  = FunInteger.rotateLeft(B , 10), C , 12,  5);
		Dp = f2p(Dp, Ep, Ap, Bp = FunInteger.rotateLeft(Bp, 10), Cp, 13,  5);
		C  = f3 (C , D , E , A  = FunInteger.rotateLeft(A , 10), B ,  1, 11);
		Cp = f3p(Cp, Dp, Ep, Ap = FunInteger.rotateLeft(Ap, 10), Bp,  8, 15);
		B  = f3 (B , C , D , E  = FunInteger.rotateLeft(E , 10), A ,  9, 12);
		Bp = f3p(Bp, Cp, Dp, Ep = FunInteger.rotateLeft(Ep, 10), Ap,  6,  5);
		A  = f3 (A , B , C , D  = FunInteger.rotateLeft(D , 10), E , 11, 14);
		Ap = f3p(Ap, Bp, Cp, Dp = FunInteger.rotateLeft(Dp, 10), Ep,  4,  8);
		E  = f3 (E , A , B , C  = FunInteger.rotateLeft(C , 10), D , 10, 15);
		Ep = f3p(Ep, Ap, Bp, Cp = FunInteger.rotateLeft(Cp, 10), Dp,  1, 11);
		D  = f3 (D , E , A , B  = FunInteger.rotateLeft(B , 10), C ,  0, 14);
		Dp = f3p(Dp, Ep, Ap, Bp = FunInteger.rotateLeft(Bp, 10), Cp,  3, 14);
		C  = f3 (C , D , E , A  = FunInteger.rotateLeft(A , 10), B ,  8, 15);
		Cp = f3p(Cp, Dp, Ep, Ap = FunInteger.rotateLeft(Ap, 10), Bp, 11, 14);
		B  = f3 (B , C , D , E  = FunInteger.rotateLeft(E , 10), A , 12,  9);
		Bp = f3p(Bp, Cp, Dp, Ep = FunInteger.rotateLeft(Ep, 10), Ap, 15,  6);
		A  = f3 (A , B , C , D  = FunInteger.rotateLeft(D , 10), E ,  4,  8);
		Ap = f3p(Ap, Bp, Cp, Dp = FunInteger.rotateLeft(Dp, 10), Ep,  0, 14);
		E  = f3 (E , A , B , C  = FunInteger.rotateLeft(C , 10), D , 13,  9);
		Ep = f3p(Ep, Ap, Bp, Cp = FunInteger.rotateLeft(Cp, 10), Dp,  5,  6);
		D  = f3 (D , E , A , B  = FunInteger.rotateLeft(B , 10), C ,  3, 14);
		Dp = f3p(Dp, Ep, Ap, Bp = FunInteger.rotateLeft(Bp, 10), Cp, 12,  9);
		C  = f3 (C , D , E , A  = FunInteger.rotateLeft(A , 10), B ,  7,  5);
		Cp = f3p(Cp, Dp, Ep, Ap = FunInteger.rotateLeft(Ap, 10), Bp,  2, 12);
		B  = f3 (B , C , D , E  = FunInteger.rotateLeft(E , 10), A , 15,  6);
		Bp = f3p(Bp, Cp, Dp, Ep = FunInteger.rotateLeft(Ep, 10), Ap, 13,  9);
		A  = f3 (A , B , C , D  = FunInteger.rotateLeft(D , 10), E , 14,  8);
		Ap = f3p(Ap, Bp, Cp, Dp = FunInteger.rotateLeft(Dp, 10), Ep,  9, 12);
		E  = f3 (E , A , B , C  = FunInteger.rotateLeft(C , 10), D ,  5,  6);
		Ep = f3p(Ep, Ap, Bp, Cp = FunInteger.rotateLeft(Cp, 10), Dp,  7,  5);
		D  = f3 (D , E , A , B  = FunInteger.rotateLeft(B , 10), C ,  6,  5);
		Dp = f3p(Dp, Ep, Ap, Bp = FunInteger.rotateLeft(Bp, 10), Cp, 10, 15);
		C  = f3 (C , D , E , A  = FunInteger.rotateLeft(A , 10), B ,  2, 12);
		Cp = f3p(Cp, Dp, Ep, Ap = FunInteger.rotateLeft(Ap, 10), Bp, 14,  8);
		B  = f4 (B , C , D , E  = FunInteger.rotateLeft(E , 10), A ,  4,  9);
		Bp = f4p(Bp, Cp, Dp, Ep = FunInteger.rotateLeft(Ep, 10), Ap, 12,  8);
		A  = f4 (A , B , C , D  = FunInteger.rotateLeft(D , 10), E ,  0, 15);
		Ap = f4p(Ap, Bp, Cp, Dp = FunInteger.rotateLeft(Dp, 10), Ep, 15,  5);
		E  = f4 (E , A , B , C  = FunInteger.rotateLeft(C , 10), D ,  5,  5);
		Ep = f4p(Ep, Ap, Bp, Cp = FunInteger.rotateLeft(Cp, 10), Dp, 10, 12);
		D  = f4 (D , E , A , B  = FunInteger.rotateLeft(B , 10), C ,  9, 11);
		Dp = f4p(Dp, Ep, Ap, Bp = FunInteger.rotateLeft(Bp, 10), Cp,  4,  9);
		C  = f4 (C , D , E , A  = FunInteger.rotateLeft(A , 10), B ,  7,  6);
		Cp = f4p(Cp, Dp, Ep, Ap = FunInteger.rotateLeft(Ap, 10), Bp,  1, 12);
		B  = f4 (B , C , D , E  = FunInteger.rotateLeft(E , 10), A , 12,  8);
		Bp = f4p(Bp, Cp, Dp, Ep = FunInteger.rotateLeft(Ep, 10), Ap,  5,  5);
		A  = f4 (A , B , C , D  = FunInteger.rotateLeft(D , 10), E ,  2, 13);
		Ap = f4p(Ap, Bp, Cp, Dp = FunInteger.rotateLeft(Dp, 10), Ep,  8, 14);
		E  = f4 (E , A , B , C  = FunInteger.rotateLeft(C , 10), D , 10, 12);
		Ep = f4p(Ep, Ap, Bp, Cp = FunInteger.rotateLeft(Cp, 10), Dp,  7,  6);
		D  = f4 (D , E , A , B  = FunInteger.rotateLeft(B , 10), C , 14,  5);
		Dp = f4p(Dp, Ep, Ap, Bp = FunInteger.rotateLeft(Bp, 10), Cp,  6,  8);
		C  = f4 (C , D , E , A  = FunInteger.rotateLeft(A , 10), B ,  1, 12);
		Cp = f4p(Cp, Dp, Ep, Ap = FunInteger.rotateLeft(Ap, 10), Bp,  2, 13);
		B  = f4 (B , C , D , E  = FunInteger.rotateLeft(E , 10), A ,  3, 13);
		Bp = f4p(Bp, Cp, Dp, Ep = FunInteger.rotateLeft(Ep, 10), Ap, 13,  6);
		A  = f4 (A , B , C , D  = FunInteger.rotateLeft(D , 10), E ,  8, 14);
		Ap = f4p(Ap, Bp, Cp, Dp = FunInteger.rotateLeft(Dp, 10), Ep, 14,  5);
		E  = f4 (E , A , B , C  = FunInteger.rotateLeft(C , 10), D , 11, 11);
		Ep = f4p(Ep, Ap, Bp, Cp = FunInteger.rotateLeft(Cp, 10), Dp,  0, 15);
		D  = f4 (D , E , A , B  = FunInteger.rotateLeft(B , 10), C ,  6,  8);
		Dp = f4p(Dp, Ep, Ap, Bp = FunInteger.rotateLeft(Bp, 10), Cp,  3, 13);
		C  = f4 (C , D , E , A  = FunInteger.rotateLeft(A , 10), B , 15,  5);
		Cp = f4p(Cp, Dp, Ep, Ap = FunInteger.rotateLeft(Ap, 10), Bp,  9, 11);
		B  = f4 (B , C , D , E  = FunInteger.rotateLeft(E , 10), A , 13,  6);
		Bp = f4p(Bp, Cp, Dp, Ep = FunInteger.rotateLeft(Ep, 10), Ap, 11, 11);
		D  = FunInteger.rotateLeft(D , 10);
		Dp = FunInteger.rotateLeft(Dp, 10);

		var T = h1 + C + Dp;
		h1 = h2 + D + Ep;
		h2 = h3 + E + Ap;
		h3 = h4 + A + Bp;
		h4 = h0 + B + Cp;
		h0 = T;
	}

	private inline function f0(A : Int, B : Int, C : Int, D : Int, E : Int, r : Int, s : Int) : Int
	{
		return FunInteger.rotateLeft(A + (B ^ C ^ D) + m_block.get(r), s) + E;
	}
	private inline function f0p(A : Int, B : Int, C : Int, D : Int, E : Int, r : Int, s : Int) : Int
	{
		return FunInteger.rotateLeft(A + (B ^ (C | ~D)) + m_block.get(r) + 0x50A28BE6, s) + E;
	}
	private inline function f1(A : Int, B : Int, C : Int, D : Int, E : Int, r : Int, s : Int) : Int
	{
		return FunInteger.rotateLeft(A + ((B & C) | (~B & D)) + m_block.get(r) + 0x5A827999, s) + E;
	}
	private inline function f1p(A : Int, B : Int, C : Int, D : Int, E : Int, r : Int, s : Int) : Int
	{
		return FunInteger.rotateLeft(A + ((B & D) | (C & ~D)) + m_block.get(r) + 0x5C4DD124, s) + E;
	}
	private inline function f2(A : Int, B : Int, C : Int, D : Int, E : Int, r : Int, s : Int) : Int
	{
		return FunInteger.rotateLeft(A + ((B | ~C) ^ D) + m_block.get(r) + 0x6ED9EBA1, s) + E;
	}
	private inline function f2p(A : Int, B : Int, C : Int, D : Int, E : Int, r : Int, s : Int) : Int
	{
		return FunInteger.rotateLeft(A + ((B | ~C) ^ D) + m_block.get(r) + 0x6D703EF3, s) + E;
	}
	private inline function f3(A : Int, B : Int, C : Int, D : Int, E : Int, r : Int, s : Int) : Int
	{
		return FunInteger.rotateLeft(A + ((B & D) | (C & ~D)) + m_block.get(r) + 0x8F1BBCDC, s) + E;
	}
	private inline function f3p(A : Int, B : Int, C : Int, D : Int, E : Int, r : Int, s : Int) : Int
	{
		return FunInteger.rotateLeft(A + ((B & C) | (~B & D)) + m_block.get(r) + 0x7A6D76E9, s) + E;
	}
	private inline function f4(A : Int, B : Int, C : Int, D : Int, E : Int, r : Int, s : Int) : Int
	{
		return FunInteger.rotateLeft(A + (B ^ (C | ~D)) + m_block.get(r) + 0xA953FD4E, s) + E;
	}
	private inline function f4p(A : Int, B : Int, C : Int, D : Int, E : Int, r : Int, s : Int) : Int
	{
		return FunInteger.rotateLeft(A + (B ^ C ^ D) + m_block.get(r), s) + E;
	}
	
	private var h0 : Int;
	private var h1 : Int;
	private var h2 : Int;
	private var h3 : Int;
	private var h4 : Int;
}
