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

package;

import com.fundoware.engine.test.FunTestRunner;

class TestMain
{
	public static function main() : Void
	{
		var tr = new FunTestRunner(false);
		com.fundoware.engine.bigint.FunBigInt_Tests.AddTests(tr);
		com.fundoware.engine.bitcoin.FunBitcoin_Tests.AddTests(tr);
		com.fundoware.engine.core.FunCore_Tests.AddTests(tr);
		com.fundoware.engine.crypto.FunCrypto_Tests.AddTests(tr);
		tr.add(new com.fundoware.engine.math.FunInteger_Test());
		com.fundoware.engine.modular.FunModular_Tests.AddTests(tr);
		com.fundoware.engine.random.FunRandom_Tests.AddTests(tr);
		com.fundoware.engine.unicode.FunUnicode_Tests.AddTests(tr);
		var success = tr.run();
	}
}
