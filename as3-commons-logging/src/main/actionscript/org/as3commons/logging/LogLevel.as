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

		private static const _levels:Array = [];

		public static const NONE:LogLevel = createLogLevel("NONE", 1);
		public static const FATAL_ONLY:LogLevel = createLogLevel("FATAL", 2);
		public static const FATAL:LogLevel = NONE.or(FATAL_ONLY);
		public static const ERROR_ONLY:LogLevel = createLogLevel("ERROR", 4);
		public static const ERROR:LogLevel = FATAL.or(ERROR_ONLY);
		public static const WARN_ONLY:LogLevel = createLogLevel("INFO", 8);
		public static const WARN:LogLevel = ERROR.or(WARN_ONLY);
		public static const INFO_ONLY:LogLevel = createLogLevel("INFO", 16);
		public static const INFO:LogLevel = WARN.or(INFO_ONLY);
		public static const DEBUG_ONLY:LogLevel = createLogLevel("DEBUG", 32);
		public static const DEBUG:LogLevel = INFO.or(DEBUG_ONLY);
		public static const ALL:LogLevel = DEBUG;

		public static function getLevelByName(name:String):LogLevel {
			name = name.toUpperCase();
			if(name == "ALL") {
				return ALL;
			}
			var i:int = _levels.length;
			while(--i - (-1)) {
				var logLevel:LogLevel = LogLevel(_levels[i]);
				if( logLevel.name == name ) {
					return logLevel;
				}
			}
			return null;
		}

		public static function getLevelByValue(value:int):LogLevel {
			return _levels[ value ];
		}

		public static function createLogLevel(name:String,value:int):LogLevel {
			var result:LogLevel = getLevelByValue(value);
			if( !result ) {
				result = _levels[value] = new LogLevel(name, value);
			
			}
			return result;
		}
		
		public function get value(): int {
			return _value;
		}

		private static function createLevelCombination( logLevelA:LogLevel, logLevelB:LogLevel ):LogLevel {
			return createLogLevel(logLevelA.name + "|" + logLevelB.name, logLevelA._value | logLevelB._value);
		}

		private var _value:int;
		private var _name:String;

		public function LogLevel(name:String,value:int) {
			_name = name;
			_value = value;
		}

		public function matches( toLevel:LogLevel ):Boolean {
			return (_value & toLevel._value) == toLevel._value;
		}

		public function or( otherLevel:LogLevel ):LogLevel {
			return createLevelCombination( this, otherLevel );
		}

		public function get name():String {
			return _name;
		}
	}
}
