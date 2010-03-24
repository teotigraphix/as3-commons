/*
 * Copyright (c) 2008-2009-2010 the original author or authors
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
	
	import mx.logging.ILogger;
	import mx.logging.Log;

	import mx.logging.LogEvent;
	import mx.logging.LogEventLevel;
	import mx.logging.LogLogger;

	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.util.MessageUtil;

	/**
	 * Logger decorator for the logging API in the Flex framework.
	 *
	 * @author Christophe Herreman
	 */
	public class FlexLogger implements org.as3commons.logging.ILogger {

		/** The decorated flex framework logger */
		private var _logger:mx.logging.ILogger;

		private var _logLogger:LogLogger;

		// --------------------------------------------------------------------
		//
		// Private Static Methods
		//
		// --------------------------------------------------------------------

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new FlexLogger
		 */
		public function FlexLogger(logger:mx.logging.ILogger) {
			_logger = logger;

			// if the logger is a LogLogger (it is in most cases), save a reference so we can directly use it for
			// logging instead of delegating to the mx.log.ILogger with apply(), which is slower
			if (_logger is LogLogger) {
				_logLogger = LogLogger(_logger);
			}
		}

		// --------------------------------------------------------------------
		//
		// Implementation: ILogger
		//
		// --------------------------------------------------------------------

		/**
		 * @inheritDoc
		 */
		public function debug(message:String, ... params):void {
			if (Log.isDebug()) {
				if (_logLogger) {
					log(_logLogger, message, params, LogEventLevel.DEBUG);
				} else {
					var args:Array = params.concat();
					args.unshift(message);
					_logger.debug.apply(_logger, args);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function info(message:String, ... params):void {
			if (Log.isInfo()) {
				if (_logLogger) {
					log(_logLogger, message, params, LogEventLevel.INFO);
				} else {
					var args:Array = params.concat();
					args.unshift(message);
					_logger.info.apply(_logger, args);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function warn(message:String, ... params):void {
			if (Log.isWarn()) {
				if (_logLogger) {
					log(_logLogger, message, params, LogEventLevel.WARN);
				} else {
					var args:Array = params.concat();
					args.unshift(message);
					_logger.warn.apply(_logger, args);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function error(message:String, ... params):void {
			if (Log.isError()) {
				if (_logLogger) {
					log(_logLogger, message, params, LogEventLevel.ERROR);
				} else {
					var args:Array = params.concat();
					args.unshift(message);
					_logger.error.apply(_logger, args);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function fatal(message:String, ... params):void {
			if (Log.isFatal()) {
				if (_logLogger) {
					log(_logLogger, message, params, LogEventLevel.FATAL);
				} else {
					var args:Array = params.concat();
					args.unshift(message);
					_logger.fatal.apply(_logger, args);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get debugEnabled():Boolean {
			return Log.isDebug();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get infoEnabled():Boolean {
			return Log.isInfo();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get warnEnabled():Boolean {
			return Log.isWarn();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get errorEnabled():Boolean {
			return Log.isError();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get fatalEnabled():Boolean {
			return Log.isFatal();
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Logs a message on the logLogger directly.
		 *
		 * @param logLogger
		 * @param message
		 * @param parameters
		 * @param logEventLevel
		 */
		private function log(logLogger:LogLogger, message:String, parameters:Array, logEventLevel:int):void {
			if (logLogger.hasEventListener(LogEvent.LOG)) {
				message = MessageUtil.toString(message, parameters);
				logLogger.dispatchEvent(new LogEvent(message, logEventLevel));
			}
		}

	}
}