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
	
	import org.as3commons.logging.ILogger;
	
	/**
	 * Default AS3Commons logging implementation of the ILogger interface that writes messages to the console using
	 * the trace() method. If no ILoggerFactory is set on the LoggerFactory, then this is the logger that will be used.
	 * 
	 * @author Christophe Herreman
	 */
	public class DefaultLogger implements ILogger {
		
		public static const LOG_LEVEL_DEBUG:int	= 1;
		public static const LOG_LEVEL_INFO:int	= 2;
		public static const LOG_LEVEL_WARN:int	= 3;
		public static const LOG_LEVEL_ERROR:int	= 4;
		public static const LOG_LEVEL_FATAL:int	= 5;
		
		public static const LOG_LEVEL_ALL:int	= (LOG_LEVEL_DEBUG - 1);
		
		public static const LOG_LEVEL_OFF:int	= (LOG_LEVEL_FATAL + 1);
		
		private var _name:String;
		private var _level:int;
		
		/**
		 * Creates a new DefaultLogger.
		 */
		public function DefaultLogger(name:String) {
			_name = name;
		}
		
		public function get name():String {
			return _name;
		}
		
		public function set level(value:int):void {
			_level = value;
		}
		
		public function log(level:int, message:String, params:Array):void {
			if (level >= this._level) {
				//var message:String = "";
				
				var msg:String = "";
				
				// add datetime
				msg += (new Date()).toString() + " ";
				
				// add level
				switch (level) {
					case LOG_LEVEL_DEBUG:
						msg += "[DEBUG] ";
						break;
					case LOG_LEVEL_INFO:
						msg += "[INFO]  ";
						break;
					case LOG_LEVEL_WARN:
						msg += "[WARN]  ";
						break;
					case LOG_LEVEL_ERROR:
						msg += "[ERROR] ";
						break;
					case LOG_LEVEL_FATAL:
						msg += "[FATAL] ";
						break;
				}
				
				// add name
				msg += _name + " - ";
				
				// replace placeholders in message
				var numParams:int = params.length;
				for (var i:int = 0; i < numParams; i++) {
					message = message.replace(new RegExp("\\{" + i + "\\}", "g"), params[i]);
				}
				msg += message;
				
				// trace the message
				trace(msg);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function debug(message:String, ...params):void {
			log(LOG_LEVEL_DEBUG, message, params);
		}
		
		/**
		 * @inheritDoc
		 */
		public function info(message:String, ...params):void {
			log(LOG_LEVEL_INFO, message, params);
		}
		
		/**
		 * @inheritDoc
		 */
		public function warn(message:String, ...params):void {
			log(LOG_LEVEL_WARN, message, params);
		}
		
		/**
		 * @inheritDoc
		 */
		public function error(message:String, ...params):void {
			log(LOG_LEVEL_ERROR, message, params);
		}
		
		/**
		 * @inheritDoc
		 */
		public function fatal(message:String, ...params):void {
			log(LOG_LEVEL_FATAL, message, params);
		}
	}
}