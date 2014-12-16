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

package com.fundoware.engine.unicode.impl;

class FullCompositionExclusionTable extends Table1Bit
{
	private function new() : Void
	{
		super(0x0340, 0x2FA1D, 0);
		// Data from http://www.unicode.org/Public/UCD/latest/ucd/DerivedNormalizationProps.txt
		// Retrieved 2014.12.05
		applyTable(1,
"0340-0341|0343-0344|0374|037E|0387|0958-095F|09DC-09DD|09DF|0A33|0A36|0A59-0A5B|0A5E|0B5C-0B5D|0F43|0F4D|0F52|0F57|0F5C|0F69|0F73|0F75-0F76|0F78|0F81|0F93|
0F9D|0FA2|0FA7|0FAC|0FB9|1F71|1F73|1F75|1F77|1F79|1F7B|1F7D|1FBB|1FBE|1FC9|1FCB|1FD3|1FDB|1FE3|1FEB|1FEE-1FEF|1FF9|1FFB|1FFD|2000-2001|2126|212A-212B|2329|
232A|2ADC|F900-FA0D|FA10|FA12|FA15-FA1E|FA20|FA22|FA25-FA26|FA2A-FA6D|FA70-FAD9|FB1D|FB1F|FB2A-FB36|FB38-FB3C|FB3E|FB40-FB41|FB43-FB44|FB46-FB4E|1D15E-1D164|
1D1BB-1D1C0|2F800-2FA1D");
	}
}
