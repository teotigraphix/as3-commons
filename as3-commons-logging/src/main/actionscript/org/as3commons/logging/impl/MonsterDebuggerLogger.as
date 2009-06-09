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
package org.as3commons.logging.impl {
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LogLevel;
	import org.as3commons.logging.util.MessageUtil;
	
	/**
	 * Logger adapter for the Monster Debugger.
	 *
	 * @author Christophe Herreman
	 */
	public class MonsterDebuggerLogger implements ILogger {
		
		/** The default color used for debug messages */
		public static const COLOR_DEBUG:uint = MonsterDebugger.COLOR_NORMAL;
		
		/** The default color used for info messages */
		public static const COLOR_INFO:uint = 0x0000FF;
		
		/** The default color used for warning messages */
		public static const COLOR_WARN:uint = MonsterDebugger.COLOR_WARNING;
		
		/** The default color used for error messages */
		public static const COLOR_ERROR:uint = MonsterDebugger.COLOR_ERROR;
		
		/** The default color used for fatal messages */
		public static const COLOR_FATAL:uint = 0xFF3300;
		
		/** The color used for debug messages */
		public static var colorDebug:uint = COLOR_DEBUG;
		
		/** The color used for info messages */
		public static var colorInfo:uint = COLOR_INFO;
		
		/** The color used for warning messages */
		public static var colorWarn:uint = COLOR_WARN;
		
		/** The color used for error messages */
		public static var colorError:uint = COLOR_ERROR;
		
		/** The color used for fatal messages */
		public static var colorFatal:uint = COLOR_FATAL;
		
		private var _name:String;
		
		/**
		 * Creates a new MonsterDebuggerLogger
		 */
		public function MonsterDebuggerLogger(name:String) {
			_name = name;
		}
		
		/**
		 * @inheritDoc
		 */
		public function debug(message:String, ... params):void {
			MonsterDebugger.trace(_name, createMessage(LogLevel.DEBUG, message, params), colorDebug);
		}
		
		/**
		 * @inheritDoc
		 */
		public function info(message:String, ... params):void {
			MonsterDebugger.trace(_name, createMessage(LogLevel.INFO, message, params), colorInfo);
		}
		
		/**
		 * @inheritDoc
		 */
		public function warn(message:String, ... params):void {
			MonsterDebugger.trace(_name, createMessage(LogLevel.WARN, message, params), colorWarn);
		}
		
		/**
		 * @inheritDoc
		 */
		public function error(message:String, ... params):void {
			MonsterDebugger.trace(_name, createMessage(LogLevel.ERROR, message, params), colorError);
		}
		
		/**
		 * @inheritDoc
		 */
		public function fatal(message:String, ... params):void {
			MonsterDebugger.trace(_name, createMessage(LogLevel.FATAL, message, params), colorFatal);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get debugEnabled():Boolean {
			return MonsterDebugger.enabled;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get infoEnabled():Boolean {
			return MonsterDebugger.enabled;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get warnEnabled():Boolean {
			return MonsterDebugger.enabled;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get errorEnabled():Boolean {
			return MonsterDebugger.enabled;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get fatalEnabled():Boolean {
			return MonsterDebugger.enabled;
		}
		
		/**
		 * Creates a log message.
		 */
		private function createMessage(level:uint, message:String, params:Array):String {
			return "[" + LogLevel.toString(level) + "] - " + MessageUtil.toString(message, params);
		}
	}
}