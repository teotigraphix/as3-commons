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
package org.as3commons.logging.impl 
{
	import org.as3commons.logging.LogTargetLevel;
	import org.as3commons.logging.ILogTarget;
	import org.as3commons.logging.LogLevel;

	import mx.logging.ILogger;
	import mx.logging.Log;

	
	/**
	 * Logger decorator for the logging API in the Flex framework.
	 *
	 * @author Christophe Herreman
	 */
	public class FlexLogTarget implements ILogTarget {
		
		/** The decorated flex framework logger */
		private var _logger:mx.logging.ILogger;
		private var _logLevel:LogTargetLevel;

		/**
		 * Creates a new FlexLogger
		 */
		public function FlexLogTarget(logger:mx.logging.ILogger) {
			_logger = logger;
			_logLevel = LogTargetLevel.NONE;
			if( Log.isDebug() ) {
				_logLevel = _logLevel.or( LogTargetLevel.DEBUG_ONLY );
			}
			if( Log.isError() ) {
				_logLevel = _logLevel.or( LogTargetLevel.DEBUG_ONLY );
			}
			if( Log.isInfo() ) {
				_logLevel = _logLevel.or( LogTargetLevel.DEBUG_ONLY );
			}
			if( Log.isWarn() ) {
				_logLevel = _logLevel.or( LogTargetLevel.DEBUG_ONLY );
			}
			if( Log.isFatal() ) {
				_logLevel = _logLevel.or( LogTargetLevel.DEBUG_ONLY );
			}
		}
		
		public function log( name: String, level:LogLevel, timeMs: Number, message:String, params:Array ):void {
			var args:Array = params.concat();
			args.unshift(message);
			if( level == LogLevel.DEBUG ) {
				_logger.debug.apply(_logger, args );
			} else if( level == LogLevel.INFO ) {
				_logger.info.apply(_logger, args );
			} else if( level == LogLevel.WARN ) {
				_logger.warn.apply(_logger, args );
			} else if( level == LogLevel.ERROR ) {
				_logger.error.apply(_logger, args );
			} else if( level == LogLevel.FATAL ) {
				_logger.fatal.apply(_logger, args );
			}
		}
		
		public function get logTargetLevel(): LogTargetLevel
		{
			return _logLevel;
		}
	}
}