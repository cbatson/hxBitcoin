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

package com.fundoware.engine.crypto.ec.nist;

import com.fundoware.engine.crypto.ec.FunIEllipticCurvePoint;
import com.fundoware.engine.crypto.ec.impl.FunGeneralAffinePrimeCurve;
import com.fundoware.engine.modular.FunIModularInt;
import com.fundoware.engine.modular.impl.FunPrimeField;

class FunNistP384Curve extends FunGeneralAffinePrimeCurve
{
	public function new()
	{
		// Parameters from http://csrc.nist.gov/groups/ST/toolkit/documents/dss/NISTReCur.pdf
		// Retrieved 17 Nov 2014
		super(
			new FunPrimeField("39402006196394479212279040100143613805079739270465446667948293404245721771496870329047266088258938001861606973112319"),
			-3,																														// a
			"0x b3312fa7 e23ee7e4 988e056b e3f82d19 181d9c6e fe814112 0314088f 5013875a c656398d 8a2ed19d 2a85c8ed d3ec2aef",		// b
			"0x aa87ca22 be8b0537 8eb1c71e f320ad74 6e1d3b62 8ba79b98 59f741e0 82542a38 5502f25d bf55296c 3a545e38 72760ab7",		// Gx
			"0x 3617de4a 96262c6f 5d9e98bf 9292dc29 f8f41dbd 289a147c e9da3113 b5f0b8c0 0a60b1ce 1d7e819d 7a431d7c 90ea0e5f",		// Gy
			"39402006196394479212279040100143613805079739270465446667946905279627659399113263569398956308152294913554433653942643"	// order
		);
	}
}
