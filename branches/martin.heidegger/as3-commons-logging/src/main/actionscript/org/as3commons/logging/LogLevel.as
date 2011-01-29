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
	 * <code>LogLevel</code> is used to inform <code>ILogTarget</code> on which
	 * method the log statement happened.
	 * 
	 * @author Martin Heidegger
	 * @version 1.0
	 */
	public final class LogLevel {
		
		/** Value of the log level */
		private var _value:int;
		
		/** Name of the log level */
		private var _name:String;
		
		/**
		 * Creates a new <code>LogLevel</code>.
		 * 
		 * @param name Name of this level.
		 * @param value Value of this level. Binary unique.
		 */
		public function LogLevel(name:String, value:int) {
			_name = name;
			_value = value;
		}
		
		/**
		 * Name of the <code>LogLevel</code>
		 */
		public function get name():String {
			return _name;
		}
		
		/**
		 * Value of the <code>LogLevel</code>.
		 * 
		 * @return Value of this level. Binary unique.
		 */
		public function valueOf():int {
			return _value;
		}
		
		/**
		 * 
		 */
		public function toString():String {
			return "[LogLevel." + _name + "]";
		}
	}
}
