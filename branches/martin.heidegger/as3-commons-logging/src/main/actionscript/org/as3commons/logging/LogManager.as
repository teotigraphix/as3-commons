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
package org.as3commons.logging 
{
	import org.as3commons.logging.impl.TraceLogTarget;

	import flash.display.Stage;
	import flash.utils.getQualifiedClassName;

	
	/**
	 * Use the LoggerFactory to obtain a logger. This is the main class used when working with the as3commons-logging
	 * library.
	 *
	 * <p>You can either request a logger via the LoggerFactory.getClassLogger() or LoggerFactory.getLogger() methods.</p>
	 *
	 * <p>When configuring a custom logger factory, make sure the logger factory is set before a logger is created.
	 * Here is an example (for your main application file):</p>
	 *
	 * <listing version="3.0">// force the FlexLoggerFactory to be set before any loggers are created
	 * private static var loggerSetup:&#42; = (LoggerFactory.loggerFactory = new FlexLoggerFactory());
	 * private static var logger:ILogger = LoggerFactory.getLogger("com.domain.MyClass");</listing>
	 *
	 * <p>By default, the DefaultLoggerFactory will be used that will write all log statements to the console using
	 * trace(). If you don't want any logging, set the logger factory to <code>null</code>.</p>
	 *
	 * <listing version="3.0">// set the logger factory to null because we don't want to see any logging
	 * private static var loggerSetup:&#42; = (LoggerFactory.loggerFactory = null);
	 * private static var logger:ILogger = LoggerFactory.getLogger("com.domain.MyClass");</listing>
	 *
	 * @author Christophe Herreman
	 * @author Martin Heidegger
	 */
	public class LogManager {
		
		public static const SWF_URL_ERROR: String = "<SWF url not initialized. Please call 'LogManager.initSWFURLs(stage)'.>";
		public static var SWF_URL: String = SWF_URL_ERROR;
		public static var SWF_SHORT_URL: String = SWF_URL;
		
		/** The singleton instance, eagerly instantiated. */
		private static var _instance:LogManager = LogManager.getInstance( );
		
		/** The logger factory that creates loggers */
		private var _loggerFactory:ILogTargetFactory = TraceLogTarget.INSTANCE;

		/** A cache of loggers */
		private var _loggers:Object /* <String, ILogger> */  = {};
		private var _nullLogger:ILogger;
		private var _undefinedLogger:ILogger;

		/**
		 * Constructs a new LoggerFactory.
		 */
		public function LogManager() {}

		/**
		 * Returns a logger for the given name.
		 */
		public static function getLogger(name:String):ILogger {
			return _instance.getLogger(name);
		}

		/**
		 * Returns a logger for the given class, using the fully qualified name of the class as the name of the
		 * logger.
		 */
		public static function getClassLogger(clazz:Class):ILogger {
			// replace the colons (::) in the name since this is not allowed in the Flex logging API
			var name:String = getQualifiedClassName(clazz);
			name = name.replace("::", ".");
			return _instance.getLogger(name);
		}

		/**
		 * Sets the logger factory for the logging system.
		 */
		public static function set loggerFactory(value:ILogTargetFactory):void {
			_instance.loggerFactory = value;
		}
		
		public static function initSWFURLs(stage:Stage):void {
			var url:String=stage.loaderInfo.loaderURL;
			SWF_URL=url;
			SWF_SHORT_URL=url.substring( url.lastIndexOf("/") + 1 );
		}

		/**
		 * Returns the singleton instance of the logger factory.
		 */
		private static function getInstance():LogManager {
			if (!_instance) {
				_instance = new LogManager();
			}
			return _instance;
		}

		/**
		 * Returns a logger for the given name.
		 *
		 * @param name the name of the logger
		 * @return a logger with the given name
		 */
		public function getLogger(name:String):ILogger {
			var result:ILogger;
			var compileSafeName:* = name;
			if( compileSafeName === null ) {
				result = _nullLogger;
			} else if( compileSafeName === undefined ) {
				result = _undefinedLogger;
			} else {
				result = _loggers[name];
			}
			
			if (!result) {
				var shortName: String = name.substring( name.lastIndexOf(".")+1 );
				if (_loggerFactory) {
					result = new Logger(name, shortName, _loggerFactory.getLogTarget(name));
				} else {
					result = new Logger(name, shortName);
				}
				
				if ( compileSafeName === null) {
					_nullLogger = result;
				} else if ( compileSafeName === undefined ) {
					_undefinedLogger = result;
				} else {
					// cache the logger
					_loggers[name] = result;
				}
			}
			
			return result;
		}

		/**
		 * Sets the factory used to generate loggers. A new logger, created by the given factory, will
		 * be set on each LoggerProxy in the cache.
		 *
		 * @param value the new logger factory or null
		 */
		private function set loggerFactory(value:ILogTargetFactory):void {
			_loggerFactory = value;
			
			if ( _loggerFactory ) {
				for (var name1:String in _loggers) {
					Logger(_loggers[name1]).logTarget = _loggerFactory.getLogTarget(name1);
				}
			} else {
				for (var name2:String in _loggers) {
					Logger(_loggers[name2]).logTarget = null;
				}
			}
		}
	}
}