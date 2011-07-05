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
	 * <p><b>Performance Note:</b> <code>getLogger</code> is slightly slower than
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
		
		private const _allLoggers:Array/* <ILogger> */=[];
		private const _loggers:Object/* <String, <String, ILogger> > */={};
		private const _nullLogger:Object/* <String, ILogger> */={};
		
		private var _setup:ILogSetup;
		
		/**
		 * Constructs a new <code>LoggerFactory</code> instance.
		 * 
		 * <p>Usually you don't need to create your own instance. The commonly
		 * used instance of this class would be available in the global constant:
		 * <code>LOGGER_FACTORY</code>.</p>
		 
		 * @param setup Default setup to be used for configuring the <code>Logger</code>
		 *        instances.
		 * @see LOGGER_FACTORY;
		 */
		public function LoggerFactory(setup:ILogSetup=null) {
			this.setup = setup;
		}
		
		/**
		 * The currently applied setup.
		 * 
		 * <p>By changing this setup, all loggers handled by this <code>LoggerFactory</code>
		 * will be cleared and handed to this setup for augmentation.</p>
		 * 
		 * @see ILogSetup#applyTo()
		 */
		public function get setup():ILogSetup {
			return _setup;
		}
		
		public function set setup(setup:ILogSetup):void {
			_setup = setup;
			const l:int = _allLoggers.length;
			var i: int;
			for( i=0; i<l; ++i ) {
				Logger(_allLoggers[i]).allTargets = null;
			}
			if(setup) {
				for( i=0; i<l; ++i ) {
					setup.applyTo( Logger(_allLoggers[i]) );
				}
			}
		}
		
		/**
		 * Returns a <code>ILogger</code> instance for the passed-in name.
		 * 
		 * @param name Name of the logger to be received, null and undefined are allowed
		 * @param person Information about the person that requested this logger.
		 * @return Logger for the passed-in name
		 */
		public function getNamedLogger(name:String,person:String=null):ILogger {
			var unpersonalized:Object;
			var compileSafeName:* = name;
			if( compileSafeName === null ) {
				unpersonalized = _nullLogger;
				name = "null";
			} else {
				unpersonalized = _loggers[name] || (_loggers[name]={});
			}
			var result:Logger = unpersonalized[person];
			if(!result) {
				result = new Logger(name,person);
				
				// Store it the array to find later on
				unpersonalized[person] = result;
				
				// Store it in the list of all loggers to later iterate over them
				_allLoggers[_allLoggers.length] = result;
				
				if(_setup) {
					_setup.applyTo(result);
				}
			}
			
			return result;
		}
	}
}