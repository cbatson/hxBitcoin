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

package com.fundoware.engine.crypto.ec.secp;

import com.fundoware.engine.crypto.ec.FunIEllipticCurvePoint;
import com.fundoware.engine.crypto.ec.impl.FunGeneralAffinePrimeCurve;
import com.fundoware.engine.modular.FunIModularInt;
import com.fundoware.engine.modular.impl.FunPrimeField;

class FunSecp256k1Curve extends FunGeneralAffinePrimeCurve
{
	/*
		The elliptic curve domain parameters over Fp associated with a Koblitz curve secp256k1 are
		specified by the sextuple T = (p, a, b, G, n, h) where the finite field Fp is defined by:

			p = FFFFFFFF FFFFFFFF FFFFFFFF FFFFFFFF FFFFFFFF FFFFFFFF FFFFFFFE FFFFFC2F
			  = 2^256 − 2^32 − 2^9 − 2^8 − 2^7 − 2^6 − 2^4 − 1

		The curve E: y^2 = x^3 + ax + b over Fp is defined by:

			a = 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
			b = 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000007

		The base point G in compressed form is:

			G = 02 79BE667E F9DCBBAC 55A06295 CE870B07 029BFCDB 2DCE28D9 59F2815B 16F81798

		and in uncompressed form is:

			G = 04 79BE667E F9DCBBAC 55A06295 CE870B07 029BFCDB 2DCE28D9 59F2815B 16F81798 483ADA77 26A3C465 5DA4FBFC 0E1108A8 FD17B448 A6855419 9C47D08F FB10D4B8

		Finally the order n of G and the cofactor are:

			n = FFFFFFFF FFFFFFFF FFFFFFFF FFFFFFFE BAAEDCE6 AF48A03B BFD25E8C D0364141

			h = 01

		(Parameters from http://www.secg.org/sec2-v2.pdf retrieved 2014.11.08)
	*/
	public function new()
	{
		super(
			new FunPrimeField("0x FFFFFFFF FFFFFFFF FFFFFFFF FFFFFFFF FFFFFFFF FFFFFFFF FFFFFFFE FFFFFC2F"),
			0,	// a
			7,	// b
			"0x 79BE667E F9DCBBAC 55A06295 CE870B07 029BFCDB 2DCE28D9 59F2815B 16F81798",	// Gx
			"0x 483ADA77 26A3C465 5DA4FBFC 0E1108A8 FD17B448 A6855419 9C47D08F FB10D4B8",	// Gy
			"0x FFFFFFFF FFFFFFFF FFFFFFFF FFFFFFFE BAAEDCE6 AF48A03B BFD25E8C D0364141"	// order
		);
	}
}
