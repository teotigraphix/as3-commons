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
	
	import org.as3commons.logging.util.toLogName;
	
	/**
	 * Use the LoggerFactory to obtain a logger. This is the main class used when working with the as3commons-logging
	 * library.
	 *
	 * <p>You can either request a logger via the long LoggerFactory.getLogger() or LoggerFactory.getNamedLogger() methods or
	 * use the short hand methods 
	 * </p>
	 *
	 * <p>When configuring a custom logger factory, make sure the logger factory is set before a logger is created.
	 * Here is an example (for your main application file):</p>
	 *
	 * <listing version="3.0">// force the FlexLoggerFactory to be set before any loggers are created
	 * private static var loggerSetup:&#42; = (LoggerFactory.loggerFactory = new FlexLoggerFactory());
	 * private static var logger:ILogger = LoggerFactory.getLogger("com.domain.MyClass");</listing>
	 *
	 * <p>By default, the DefaultLoggerFactory will be used that will write all log statements to the console using
	 * trace(). If you don't want any logging, set the logger setup to <code>null</code>.</p>
	 *
	 * @author Christophe Herreman
	 * @author Martin Heidegger 
	 */
	public class LoggerFactory {
		
		/*
		 * @example We have the following 
		 * <listing version="3.0">
		 * implements org.as3commons.logging.*;
		 * 
		 * class MyClass {
		 *   private static var log:ILogger = getLogger(MyClass);
		 *   
		 *   public function foo(user:String, host:String): void {
		 *     // Sending a log statement of level "debug"
		 *     log.debug( "message" );
		 *   }
		 * }
		 * </listing>
		 *
		 * @param name the name of the logger
		 * @return a logger with the given name
		 * @deprecated
		 */
		public static function getClassLogger(input:*): ILogger {
			return LOGGER_FACTORY.getLogger(toLogName(input));
		}
		
		/**
		 * Returns a logger for the given name.
		 */
		public static function getLogger(name:String):ILogger {
			return LOGGER_FACTORY.getLogger(name);
		}
		
		private const _loggers:Object/* <String, ILogger> */={};
		
		private var _setup:ILogSetup;
		private var _nullLogger:Logger;
		private var _undefinedLogger:Logger;
		
		public function LoggerFactory(setup:ILogSetup) {
			this.setup = setup;
		}
		
		public function set setup(setup:ILogSetup):void {
			_setup = setup;
			var name: String;
			
			if(setup) {
				for(name in _loggers) {
					setup.applyTo( _loggers[name] );
				}
			} else {
				for(name in _loggers) {
					Logger(_loggers[name]).allTargets = null;
				}
			}
		}
		
		public function getLogger(name:String):ILogger {
			var result:Logger;
			var compileSafeName:* = name;
			if( compileSafeName === null ) {
				result = _nullLogger;
			} else if( compileSafeName === undefined ) {
				result = _undefinedLogger;
			} else {
				result = _loggers[name];
			}
			if(!result) {
				result = new Logger(name);
				
				if(_setup) {
					_setup.applyTo(result);
				}
				
				if(compileSafeName === null) {
					_nullLogger = result;
				} else if( compileSafeName === undefined ) {
					_undefinedLogger = result;
				} else {
					// cache the logger
					_loggers[name] = result;
				}
			}
			
			return result;
		}
	}
}