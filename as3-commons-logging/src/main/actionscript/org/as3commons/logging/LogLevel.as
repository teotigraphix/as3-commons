/*
 * Copyright (c) 2008-2009 the original author or authors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package org.as3commons.logging {

	/**
	 * LogLevel enumeration
	 *
	 * @author Martin Heidegger
	 * @version 1.0
	 */
	public class LogLevel {
		
		public static const FATAL:LogLevel = new LogLevel("FATAL", LogTargetLevel.FATAL_ONLY.value );
		public static const ERROR:LogLevel = new LogLevel("ERROR", LogTargetLevel.ERROR_ONLY.value);
		public static const WARN:LogLevel = new LogLevel("WARN", LogTargetLevel.WARN_ONLY.value);
		public static const INFO:LogLevel = new LogLevel("INFO", LogTargetLevel.INFO_ONLY.value);
		public static const DEBUG:LogLevel = new LogLevel("DEBUG", LogTargetLevel.DEBUG_ONLY.value);
		
		private var _value:int;
		private var _name:String;
		
		public function LogLevel(name:String,value:int) {
			_name = name;
			_value = value;
		}
		
		public function get name():String {
			return _name;
		}
		
		internal function get value(): int
		{
			return _value;
		}
	}
}
