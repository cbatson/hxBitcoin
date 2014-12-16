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
import haxe.ds.Vector;
import haxe.io.Bytes;

@:allow(com.fundoware.engine.unicode)
class Table2Bit extends PropertyTable
{
	public override function setEntry(cp : Int, val : Int) : Void
	{
		if ((m_min <= cp) && (cp <= m_max))
		{
			cp -= m_min;
			var idx = cp >> 2;
			var v = m_data.get(idx);
			var shift = (cp & 3) << 1;
			var mask = 3 << shift;
			val <<= shift;
			v = (v & ~mask) | val;
			m_data.set(idx, v);
		}
		else
		{
			throw FunExceptions.FUN_INVALID_ARGUMENT;
		}
	}

	public override function lookup(cp : Int) : Int
	{
		if (cp < m_min)
		{
			return m_default;
		}
		if (cp <= m_max)
		{
			cp -= m_min;
			var v = m_data.get(cp >> 2);
			return (v >> ((cp & 3) << 1)) & 3;
		}
		else
		{
			return m_default;
		}
	}

	private function new(min : Int, max : Int, def : Int) : Void
	{
		super(min, max, def);
		var num = (m_max - m_min + 1 + 3) >> 2;	// 4 values per 8-bit byte
		m_data = Bytes.alloc(num);
		def |= def << 2;
		def |= def << 4;
		m_data.fill(0, m_data.length, def);
	}
}
