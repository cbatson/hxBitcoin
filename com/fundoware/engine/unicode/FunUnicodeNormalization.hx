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

package com.fundoware.engine.unicode;

import com.fundoware.engine.crypto.FunCryptoUtils;
import com.fundoware.engine.exception.FunExceptions;
import com.fundoware.engine.unicode.impl.CanonicalCombiningClassTable;
import com.fundoware.engine.unicode.impl.CanonicalDecompositionMappingTable;
import com.fundoware.engine.unicode.impl.FullCompositionExclusionTable;
import com.fundoware.engine.unicode.impl.Hangul;
import com.fundoware.engine.unicode.impl.PropertyTable;
import com.fundoware.engine.unicode.impl.Table1Bit;
import com.fundoware.engine.unicode.impl.Table2Bit;

// http://www.unicode.org/reports/tr15/
// http://www.unicode.org/versions/Unicode7.0.0/ch03.pdf
class FunUnicodeNormalization
{
	//-----------------------------------------------------------------------
	// Public interface
	//-----------------------------------------------------------------------

	public inline function isNFC(input : String) : Int
	{
		return isNFx(getQCNFC(), input);
	}

	public function toNFC(input : String) : String
	{
		if (isNFC(input) == kQuickCheckYes)
		{
			return input;
		}

		var ccc = getCCC();
		var fce = getFCE();
		var codePoints = new Array<Int>();

		// Decompose (as needed)
		var lastStarter = 0;
		var needsWork = false;
		var i = 0;
		while (i < input.length)
		{
			var ch = FunUnicode.getCodePoint(input, i);
			i += FunUnicode.getCodePointSize(ch);
			codePoints.push(ch);
			var cl = ccc.lookup(ch);
			if (cl == 0)
			{
				if (needsWork)
				{
					decomposeCanonical(codePoints, lastStarter);
				}
				lastStarter = codePoints.length - 1;
				needsWork = false;
			}
			if ((cl > 0) || (fce.lookup(ch) != 0))
			{
				needsWork = true;
			}
		}
		if (needsWork && (lastStarter >= 0))
		{
			decomposeCanonical(codePoints, lastStarter);
		}

		// Compose
		lastStarter = -1;
		var starter = -1;
		var index = 0;
		var lastCl = -1;
		while (index < codePoints.length)
		{
			var ch = codePoints[index];
			var cl = ccc.lookup(ch);
			if ((lastStarter >= 0) && (lastCl < cl))
			{
				// not blocked
				var pc = getPrimaryComposite(starter, ch);
				if (pc >= 0)
				{
					// composition
					codePoints[lastStarter] = pc;
					codePoints.splice(index, 1);
					starter = pc;
					continue;
				}
			}
			lastCl = cl;
			if (cl == 0)
			{
				lastStarter = index;
				starter = ch;
				lastCl = -1;
			}
			++index;
		}

		var result = FunUnicode.stringFromCodePoints(codePoints);
//trace(FunTestUtils.unicodeToCodePointsString(input) + " => " + FunTestUtils.unicodeToCodePointsString(result));
		FunCryptoUtils.clearArrayInt(codePoints);
		return result;
	}

	public inline function isNFD(input : String) : Int
	{
		return isNFx(getQCNFD(), input);
	}

	public function toNFD(input : String) : String
	{
		if (isNFD(input) == kQuickCheckYes)
		{
			return input;
		}

		var ccc = getCCC();
		var codePoints = new Array<Int>();

		// Decompose
		var lastStarter = 0;
		var i = 0;
		while (i < input.length)
		{
			var ch = FunUnicode.getCodePoint(input, i);
			codePoints.push(ch);
			var cl = ccc.lookup(ch);
			if ((cl == 0) && (i > 0))
			{
				decomposeCanonical(codePoints, lastStarter);
				lastStarter = codePoints.length - 1;
			}
			i += FunUnicode.getCodePointSize(ch);
		}
		decomposeCanonical(codePoints, lastStarter);

		var result = FunUnicode.stringFromCodePoints(codePoints);
//trace(FunTestUtils.unicodeToCodePointsString(input) + " => " + FunTestUtils.unicodeToCodePointsString(result));
		FunCryptoUtils.clearArrayInt(codePoints);
		return result;
	}

	public function new() : Void
	{
	}

	//-----------------------------------------------------------------------
	// Private implementation
	//-----------------------------------------------------------------------

	private function isNFx(table : PropertyTable, input : String) : Int
	{
		var ccc = getCCC();
		var lastCanonicalClass = 0;
		var result = kQuickCheckYes;
		var i = 0;
		while (i < input.length)
		{
			var ch = FunUnicode.getCodePoint(input, i);
			i += FunUnicode.getCodePointSize(ch);
			var canonicalClass = ccc.lookup(ch);
			if ((lastCanonicalClass > canonicalClass) && (canonicalClass != 0))
			{
				return kQuickCheckNo;
			}
			var check = table.lookup(ch);
			if (check == kQuickCheckNo)
			{
				return kQuickCheckNo;
			}
			if (check == kQuickCheckMaybe)
			{
				result = kQuickCheckMaybe;
			}
			lastCanonicalClass = canonicalClass;
		}
		return result;
	}

	private inline function getPrimaryComposite(a : Int, b : Int) : Int
	{
		var r = getCDM().getPrimaryComposite(a, b);
		if (r < 0)
		{
			r = Hangul.composeHangulPair(a, b);
		}
		return r;
	}

	private function decomposeCanonical(codePoints : Array<Int>, start : Int) : Void
	{
		// Decompose (recursively)
		var index = start;
		while (index < codePoints.length)
		{
			var ct = Hangul.decomposeHangul(codePoints, index);
			if (ct > 0)
			{
				index += ct;
				continue;
			}
			var ch = codePoints[index];
			var decompCh1 = getCDM().getDecompositionCodePoint1(ch);
			if (decompCh1 == ch)
			{
				// no decomp
				index++;
				continue;
			}
			codePoints[index] = decompCh1;
			var decompCh2 = getCDM().getDecompositionCodePoint2(ch);
			if (decompCh2 >= 0)
			{
				codePoints.insert(index + 1, decompCh2);
			}
		}

		// Canonical ordering
		var ccc = getCCC();
		var run = true;
		while (run)
		{
			run = false;
			var A = codePoints[start];
			var cccA = ccc.lookup(A);
			for (i in start ... codePoints.length - 1)
			{
				var B = codePoints[i + 1];
				var cccB = ccc.lookup(B);
				// reorderable pair?
				if ((cccB > 0) && (cccA > cccB))
				{
					// swap
					codePoints[i] = B;
					codePoints[i + 1] = A;
					run = true;
				}
				else
				{
					A = B;
					cccA = cccB;
				}
			}
		}
	}

	private function getCDM() : CanonicalDecompositionMappingTable
	{
		if (m_cdm == null)
		{
			m_cdm = new CanonicalDecompositionMappingTable(getFCE());
		}
		return m_cdm;
	}

	private function getFCE() : FullCompositionExclusionTable
	{
		if (m_fce == null)
		{
			m_fce = new FullCompositionExclusionTable();
		}
		return m_fce;
	}

	private function getCCC() : CanonicalCombiningClassTable
	{
		if (m_ccc == null)
		{
			m_ccc = new CanonicalCombiningClassTable();
		}
		return m_ccc;
	}

	private function getQCNFC() : Table2Bit
	{
		if (m_qcNFC == null)
		{
			// Data from http://www.unicode.org/Public/UCD/latest/ucd/DerivedNormalizationProps.txt
			// Retrieved 2014.12.05
			m_qcNFC = new Table2Bit(0x0300, 0x2FA1D, kQuickCheckYes);
			m_qcNFC.applyTable(kQuickCheckNo,
"0340-0341|0343-0344|0374|037E|0387|0958-095F|09DC-09DD|09DF|0A33|0A36|0A59-0A5B|0A5E|0B5C-0B5D|0F43|0F4D|0F52|0F57|0F5C|0F69|0F73|0F75-0F76|0F78|0F81|
0F93|0F9D|0FA2|0FA7|0FAC|0FB9|1F71|1F73|1F75|1F77|1F79|1F7B|1F7D|1FBB|1FBE|1FC9|1FCB|1FD3|1FDB|1FE3|1FEB|1FEE-1FEF|1FF9|1FFB|1FFD|2000-2001|2126|212A-212B|
2329|232A|2ADC|F900-FA0D|FA10|FA12|FA15-FA1E|FA20|FA22|FA25-FA26|FA2A-FA6D|FA70-FAD9|FB1D|FB1F|FB2A-FB36|FB38-FB3C|FB3E|FB40-FB41|FB43-FB44|FB46-FB4E|
1D15E-1D164|1D1BB-1D1C0|2F800-2FA1D");
			m_qcNFC.applyTable(kQuickCheckMaybe,
"0300-0304|0306-030C|030F|0311|0313-0314|031B|0323-0328|032D-032E|0330-0331|0338|0342|0345|0653-0655|093C|09BE|09D7|0B3E|0B56|0B57|0BBE|0BD7|0C56|0CC2|
0CD5-0CD6|0D3E|0D57|0DCA|0DCF|0DDF|102E|1161-1175|11A8-11C2|1B35|3099-309A|110BA|11127|1133E|11357|114B0|114BA|114BD|115AF");
		}
		return m_qcNFC;
	}

	private function getQCNFD() : Table1Bit
	{
		if (m_qcNFD == null)
		{
			// Data from http://www.unicode.org/Public/UCD/latest/ucd/DerivedNormalizationProps.txt
			// Retrieved 2014.12.05
			m_qcNFD = new Table1Bit(0x00C0, 0x2FA1D, kQuickCheckYes);
			m_qcNFD.applyTable(kQuickCheckNo,
"00C0-00C5|00C7-00CF|00D1-00D6|00D9-00DD|00E0-00E5|00E7-00EF|00F1-00F6|00F9-00FD|00FF-010F|0112-0125|0128-0130|0134-0137|0139-013E|0143-0148|014C-0151|
0154-0165|0168-017E|01A0-01A1|01AF-01B0|01CD-01DC|01DE-01E3|01E6-01F0|01F4-01F5|01F8-021B|021E-021F|0226-0233|0340-0341|0343-0344|0374|037E|0385|0386|0387|
0388-038A|038C|038E-0390|03AA-03B0|03CA-03CE|03D3-03D4|0400-0401|0403|0407|040C-040E|0419|0439|0450-0451|0453|0457|045C-045E|0476-0477|04C1-04C2|04D0-04D3|
04D6-04D7|04DA-04DF|04E2-04E7|04EA-04F5|04F8-04F9|0622-0626|06C0|06C2|06D3|0929|0931|0934|0958-095F|09CB-09CC|09DC-09DD|09DF|0A33|0A36|0A59-0A5B|0A5E|0B48|
0B4B-0B4C|0B5C-0B5D|0B94|0BCA-0BCC|0C48|0CC0|0CC7-0CC8|0CCA-0CCB|0D4A-0D4C|0DDA|0DDC-0DDE|0F43|0F4D|0F52|0F57|0F5C|0F69|0F73|0F75-0F76|0F78|0F81|0F93|0F9D|
0FA2|0FA7|0FAC|0FB9|1026|1B06|1B08|1B0A|1B0C|1B0E|1B12|1B3B|1B3D|1B40-1B41|1B43|1E00-1E99|1E9B|1EA0-1EF9|1F00-1F15|1F18-1F1D|1F20-1F45|1F48-1F4D|1F50-1F57|
1F59|1F5B|1F5D|1F5F-1F7D|1F80-1FB4|1FB6-1FBC|1FBE|1FC1|1FC2-1FC4|1FC6-1FCC|1FCD-1FCF|1FD0-1FD3|1FD6-1FDB|1FDD-1FDF|1FE0-1FEC|1FED-1FEF|1FF2-1FF4|1FF6-1FFC|
1FFD|2000-2001|2126|212A-212B|219A-219B|21AE|21CD|21CE-21CF|2204|2209|220C|2224|2226|2241|2244|2247|2249|2260|2262|226D-2271|2274-2275|2278-2279|2280-2281|
2284-2285|2288-2289|22AC-22AF|22E0-22E3|22EA-22ED|2329|232A|2ADC|304C|304E|3050|3052|3054|3056|3058|305A|305C|305E|3060|3062|3065|3067|3069|3070-3071|
3073-3074|3076-3077|3079-307A|307C-307D|3094|309E|30AC|30AE|30B0|30B2|30B4|30B6|30B8|30BA|30BC|30BE|30C0|30C2|30C5|30C7|30C9|30D0-30D1|30D3-30D4|30D6-30D7|
30D9-30DA|30DC-30DD|30F4|30F7-30FA|30FE|AC00-D7A3|F900-FA0D|FA10|FA12|FA15-FA1E|FA20|FA22|FA25-FA26|FA2A-FA6D|FA70-FAD9|FB1D|FB1F|FB2A-FB36|FB38-FB3C|FB3E|
FB40-FB41|FB43-FB44|FB46-FB4E|1109A|1109C|110AB|1112E-1112F|1134B-1134C|114BB-114BC|114BE|115BA-115BB|1D15E-1D164|1D1BB-1D1C0|2F800-2FA1D");
		}
		return m_qcNFD;
	}

	private var m_ccc : CanonicalCombiningClassTable;
	private var m_cdm : CanonicalDecompositionMappingTable;
	private var m_fce : FullCompositionExclusionTable;
	private var m_qcNFC : Table2Bit;
	private var m_qcNFD : Table1Bit;

	private static inline var kQuickCheckNo = 0;
	private static inline var kQuickCheckYes = 1;
	private static inline var kQuickCheckMaybe = 2;
}
