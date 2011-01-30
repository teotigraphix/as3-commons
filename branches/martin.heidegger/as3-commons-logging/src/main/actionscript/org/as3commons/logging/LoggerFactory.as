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
	 * Use the <code>LoggerFactory</code> to obtain a logger. This is the main class used when
	 * working with the as3commons-logging library.
	 *
	 * <p>You can either request a logger via the long <code>LoggerFactory.getLogger()</code>
	 * or <code>LoggerFactory.getNamedLogger()</code> methods or use the short methods
	 * <code>getLogger()</code>, <code>getNamedLogger()</code>, <code>getClassLogger()</code>.</p>
	 *
	 * <listing>
	 * package {
	 *   import org.as3commons.logging.ILogger;
	 *   import org.as3commons.logging.getLogger;
	 *
	 *   public class MyClass {
	 *   
	 *    private static const logger: ILogger = getLogger( MyClass );
	 *      
	 *    public function doSomething(): void {
	 *      logger.info("hi");
	 *    }
	 *   }
	 * } 
	 * </listing>
	 * 
	 * <p>By default the <code>Logger</code> instances will redirect to the 
	 * <code>TRACE_TARGET</code> (using <code>trace</code> for the output). To
	 * change that to your preferred logging mechanism change the <code>setup</code>
	 * of the logger factory.</p>
	 * 
	 * <listing>
	 *    org.as3commons.logging.LOGGER_FACTORY.setup = new FlexSetup();
	 *    // will redirect all output to the flex logging mechanism 
	 
	 *    org.as3commons.logging.LOGGER_FACTORY.setup = null;
	 *    // will clear all output
	 * </listing>
	 * 
	 * <p>Performance information: <code>getLogger</code> is slightly slower than
	 * <code>getClassLogger</code> and both are a bit slower than
	 * <code>getNamedLogger()</code>. Nevertheless, it has advantages to use
	 * <code>getClassLogger()</code>: In a development environment that updates 
	 * class references on rename its safer (in terms of: less exposed to bugs)
	 * and faster to use the <code>getLogger()</code>. If you create libraries with
	 * a lot of classes its recommended to use <code>getNamedLogger()</code>.</p>
	 * 
	 * @author Christophe Herreman
	 * @author Martin Heidegger
	 * @version 2
	 * @see ILogSetup
	 * @see org.as3commons.logging#getLogger()
	 * @see org.as3commons.logging#getNamedLogger()
	 * @see org.as3commons.logging#getClassLogger()
	 * @see org.as3commons.logging.setup.ILogTarget
	 */
	public class LoggerFactory {
		
		/**
		 * Generates a name for the passed-in <code>input</code> with <code>
		 * toLogName()</code> and generates the <code>ILogger</code> for that name.
		 * 
		 * <p>Deprecated: Use org.as3commons.logging.getClassLogger</p>
		 *
		 * @param name Any Object can be used to generate the name
		 * @return <code>ILogger</code> for the generated name.
		 * @deprecated
		 * @see org.as3commons.logging.util#toLogName()
		 */
		[Deprecated(replacement="org.as3commons.logging.getClassLogger()", since="2.0")]
		public static function getClassLogger(input:*): ILogger {
			return LOGGER_FACTORY.getNamedLogger(toLogName(input));
		}
		
		/**
		 * Generates and returns a <code>ILogger</code> for the passed-in name.
		 *
		 * <p>Deprecated: Use org.as3commons.logging.getNamedLogger</p> 
		 *
		 * @param name Any String can be used as name
		 * @return <code>ILogger</code> for that name.
		 * @deprecated
		 */
		[Deprecated(replacement="org.as3commons.logging.getNamedLogger()", since="2.0")]
		public static function getLogger(name:String):ILogger {
			return LOGGER_FACTORY.getNamedLogger(name);
		}
		
		private const _loggers:Object/* <String, ILogger> */={};
		
		private var _setup:ILogSetup;
		private var _nullLogger:Logger;
		private var _undefinedLogger:Logger;
		
		/**
		 * 
		 * 
		 * 
		 * @param setup Default setup to be used for configuring the <code>Logger</code>
		 *        instances.
		 */
		public function LoggerFactory(setup:ILogSetup) {
			this.setup = setup;
		}
		
		public function get setup():ILogSetup {
			return _setup;
		}
		
		public function set setup(setup:ILogSetup):void {
			_setup = setup;
			var name: String;
			
			for(name in _loggers) {
				Logger(_loggers[name]).allTargets = null;
			}
			if(setup) {
				for(name in _loggers) {
					setup.applyTo( _loggers[name] );
				}
			}
		}
		
		/**
		 * Returns a <code>ILogger</code> instance for the passed-in name.
		 * 
		 * @param name Name of the logger to be received, null and undefined are allowed
		 * @return Logger for the passed-in name
		 */
		public function getNamedLogger(name:String):ILogger {
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