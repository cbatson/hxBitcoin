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

import com.fundoware.engine.exception.FunExceptions;
import haxe.io.Bytes;

class PropertyTable
{
	public function lookup(ch : Int) : Int
	{
		throw FunExceptions.FUN_ABSTRACT_METHOD;
	}

	private function setEntry(ch : Int, val : Int) : Void
	{
		throw FunExceptions.FUN_ABSTRACT_METHOD;
	}

	public function applyTable(val : Int, tableStr : String) : Void
	{
		var table = tableStr.split("|");
		for (i in 0 ... table.length)
		{
			var e = StringTools.trim(table[i]);
			var idx = e.indexOf("-");
			if (idx >= 0)
			{
				var n1 = toInt(e.substr(0, idx));
				var n2 = toInt(e.substr(idx + 1));
				for (j in n1 ... n2 + 1)
				{
					setEntry(j, val);
				}
			}
			else
			{
				var n = toInt(e);
				setEntry(n, val);
			}
		}
	}

	private function new(min : Int, max : Int, def : Int) : Void
	{
		m_min = min;
		m_max = max;
		m_default = def;
	}

	private static function toInt(s : String) : Int
	{
		return Std.parseInt("0x" + s);
	}

	private var m_min : Int;
	private var m_max : Int;
	private var m_default : Int;
	private var m_data : Bytes;
}
