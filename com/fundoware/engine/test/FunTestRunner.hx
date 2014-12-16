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

package com.fundoware.engine.test;

import haxe.Log;
import haxe.PosInfos;
import haxe.unit.TestCase;
import haxe.unit.TestResult;
import haxe.unit.TestRunner;
import haxe.unit.TestStatus;

class FunTestRunner extends TestRunner
{
	public function new(quick : Bool = false)
	{
		super();
		m_quick = quick;
		s_oldPrint = TestRunner.print;
		TestRunner.print = __print;
	}

	public override function run() : Bool
	{
		m_result = new TestResult();
		m_case = null;
		m_caseIter = cases.iterator();
		m_fields = null;
		#if flash
			flash.Lib.current.addEventListener(flash.events.Event.ENTER_FRAME, onEnterFrame);
			return true;
		#else
			while (nextTest())
			{
			}
			return concludeTests();
		#end
	}

	private function nextTest() : Bool
	{
		var run = true;
		while (run)
		{
			if (m_case == null)
			{
				if (!m_caseIter.hasNext())
				{
					return false;
				}
				m_case = m_caseIter.next();
			}

			var cl = Type.getClass(m_case);
			if (m_fields == null)
			{
				_print("Class: " + Type.getClassName(cl) + " ");
				m_fields = Type.getInstanceFields(cl);
				m_fieldIndex = 0;
				m_x = 0;
			}

			if (m_fields.length > 0)
			{
				var f = m_fields[m_fieldIndex];
				var field = Reflect.field(m_case, f);
				if (Reflect.isFunction(field))
				{
					if (StringTools.startsWith(f, "testX_"))
					{
						var r = runTestX(m_case, cl, field, f, m_result, m_x++);
						run = false;
						if ((m_x < r) && (!m_quick))
						{
							continue;
						}
					}
					else if (StringTools.startsWith(f, "test"))
					{
						runTest(m_case, cl, field, f, m_result);
						run = false;
					}
				}
			}

			m_x = 0;
			if (++m_fieldIndex >= m_fields.length)
			{
				m_fields = null;
				m_case = null;
				_print("\n");
			}
		}
		return true;
	}

	private static function runTest(tcase : TestCase, cl : Class<TestCase>, field : Dynamic, fname : String, result : TestResult) : Void
	{
		runTestX(tcase, cl, field, fname, result, -1);
	}

	private static function runTestX(m_case : TestCase, cl : Class<TestCase>, field : Dynamic, fname : String, result : TestResult, x : Int) : Int
	{
		m_case.currentTest = new TestStatus();
		m_case.currentTest.classname = Type.getClassName(cl);
		if (x >= 0)
		{
			m_case.currentTest.method = fname + "(index = " + x + ")";
		}
		else
		{
			m_case.currentTest.method = fname;
		}
		m_case.setup();

		var ret = 0;

		try
		{
			var args = new Array();
			if (x >= 0)
			{
				args.push(x);
			}
			var r = Reflect.callMethod(m_case, field, args);
			if (Std.is(r, Int))
			{
				ret = cast r;
			}

			if (m_case.currentTest.done)
			{
				m_case.currentTest.success = true;
				_print(".");
			}
			else
			{
				m_case.currentTest.success = false;
				m_case.currentTest.error = "(warning) no assert";
				_print("W");
			}
		}
		catch (e : TestStatus)
		{
			_print("F");
			m_case.currentTest.backtrace = haxe.CallStack.toString(haxe.CallStack.exceptionStack());
		}
		catch (e : Dynamic)
		{
			_print("E");
			#if js
				if (e.message != null)
				{
					m_case.currentTest.error = "exception thrown : " + e + " [" + e.message + "]";
				}
				else
				{
					m_case.currentTest.error = "exception thrown : " + e;
				}
			#else
				m_case.currentTest.error = "exception thrown : " + e;
			#end
			m_case.currentTest.backtrace = haxe.CallStack.toString(haxe.CallStack.exceptionStack());
		}
		result.add(m_case.currentTest);
		m_case.tearDown();
		return ret;
	}

	private function concludeTests() : Bool
	{
		_print(m_result.toString());
		var success = m_result.success;
		m_result = null;
		return success;
	}

	#if flash
		private function onEnterFrame(event : flash.events.Event) : Void
		{
			if (!nextTest())
			{
				flash.Lib.current.removeEventListener(flash.events.Event.ENTER_FRAME, onEnterFrame);
				concludeTests();
			}
		}
	#end

	private static inline function _print(v : Dynamic) : Void
	{
		TestRunner.print(v);
	}

	private static function __print(v : Dynamic) untyped
	{
		#if flash
			var str = flash.Boot.__string_rec(v, "");
			untyped __global__["trace"](str);	// prints a newline :-(
//		#elseif cpp
//			untyped __trace(v, null);
		#end
		s_oldPrint(v);
	}

	private var m_result : TestResult;
	private var m_case : TestCase;
	private var m_caseIter : Iterator<TestCase>;
	private var m_fields : Array<String>;
	private var m_fieldIndex : Int;
	private var m_x : Int;
	private var m_quick : Bool;

	private static var s_oldPrint : Dynamic->Void;
}
