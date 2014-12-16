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

package com.fundoware.engine.crypto.salsa20;

import com.fundoware.engine.core.FunUtils;
import com.fundoware.engine.crypto.FunCryptoUtils;
import com.fundoware.engine.test.FunTestCase;
import haxe.ds.Vector;

class FunSalsa20_Test extends FunTestCase
{
	public function testX_Vectors(x : Int) : Int
	{
		var testVectors : Array<Array<Dynamic>> = [
			// Test vectors https://tools.ietf.org/html/draft-josefsson-scrypt-kdf-01
			// Retrieved 2014.11.24
			["7e879a214f3ec9867ca940e641718f26baee555b8c61c1b50df846116dcd3b1dee24f319df9b3d8514121e4b5ac5aa3276021d2909c74829edebc68db8b8c25e", "a41f859c6608cc993b81cacb020cef05044b2181a2fd337dfd7b1c6396682f29b4393168e3c9e6bcfe6bc5b7a06d96bae424cc102c91745c24ad673dc7618f81", 8],
			// Test vectors from http://cr.yp.to/snuffle/spec.pdf
			// Retrieved 2014.11.24
			["00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000", "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"],
			["d39f0d734c3752b70375de25bfbbea8831edb330016ab2dbafc7a6305610b3cf1ff0203f0f535da174933071ee37cc244fc9eb4f03519c2fcb1af4f358766836", "6d2ab2a89cf0f8eea8c4becb1a6eaa9a1d1d961a961eebf9bea3fb30459033397628989db4391b5e6b2aec231b6f7272dbece8876f9b6e1218e85f9eb31330ca"],
			["587668364fc9eb4f03519c2fcb1af4f3bfbbea88d39f0d734c3752b70375de255610b3cf31edb330016ab2dbafc7a630ee37cc241ff0203f0f535da174933071", "b31330cadbece8876f9b6e1218e85f9e1a6eaa9a6d2ab2a89cf0f8eea8c4becb459033391d1d961a961eebf9bea3fb301b6f72727628989db4391b5e6b2aec23"],
			["067c539226bf093204a12fde7ab6dfb94b1b00d8107a0759a2686593d515365fe1fd8bb0698417744c29b0cfdd229d6c5e5e63345a755bdc92beef8fc4b082ba", "081226c7774cd743ad7f90a267d4b0d9c013e9219fc59aa080f3db41ab8887e17b0b4456ed52149b85bd0953a774c24e7a7fc3b9b9ccbc5af509b7f8e255f568", 20, 1000000],
		];
		return checkS20X(testVectors, x);
	}

	private function checkS20X(testVectors : Array<Array<Dynamic>>, x : Int) : Int
	{
		var v = testVectors[x];
		var input = cast(v[0], String);
		var expected = cast(v[1], String);
		var rounds = (v.length > 2) ? cast(v[2], Int) : 20;
		var reps = (v.length > 3) ? cast(v[3], Int) : 1;
		checkS20(input, expected, rounds, reps);
		return testVectors.length;
	}

	private function checkS20(input : String, expected : String, rounds : Int = 20, reps : Int = 1) : Void
	{
		var bytes = FunUtils.hexToBytes(input);
		var ints = new Vector<Int>(16);
		FunSalsa20.bytesToInts(ints, bytes);
		for (i in 0 ... reps)
		{
			FunSalsa20.core(ints, 0, ints, rounds);
		}
		FunSalsa20.intsToBytes(bytes, ints);
		assertEquals(expected, bytes.toHex());
	}
}
