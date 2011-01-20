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
	
	import org.as3commons.logging.level.DEBUG;
	import org.as3commons.logging.level.ERROR;
	import org.as3commons.logging.level.FATAL;
	import org.as3commons.logging.level.INFO;
	import org.as3commons.logging.level.WARN;
	import org.as3commons.logging.setup.ILogTarget;
	
	import flash.utils.getTimer;
	
	/**
	 * Proxy for an <code>ILogger</code> implementation. This class is used
	 * by the <code>LoggerFactory</code> in the setup process.
	 *
	 * <p>A <code>Logger</code> instance is created for each logger requested from
	 * the factory. The <code>Logger</code> instances do get augmented by the
	 * Setup.</p>
	 *
	 * @author Martin Heidegger
	 * @author Christophe Herreman
	 * @version 2
	 */
	public final class Logger implements ILogger {
		
		/** Time when class is created by the .swf loader. */
		private static const _startTime: Number = new Date().getTime() - getTimer();
		
		/** The logger for debug level, if not added (<code>== null</code>) debug is not enabled. */
		public var debugTarget:ILogTarget;
		
		/** The logger for debug level, if not added (<code>== null</code>) debug is not enabled. */
		public var infoTarget:ILogTarget;
		
		/** The logger for warn level, if not added (<code>== null</code>) debug is not enabled. */
		public var warnTarget:ILogTarget;
		
		/** The logger for error level, if not added (<code>== null</code>) debug is not enabled. */
		public var errorTarget:ILogTarget;
		
		/** The logger for fatal level, if not added (<code>== null</code>) debug is not enabled. */
		public var fatalTarget:ILogTarget;
		
		/** Full name of the logger. */
		private var _name:String;
		
		/** Short name of the logger. */
		private var _shortName:String;
		
		/**
		 * Creates a new LoggerProxy.
		 */
		public function Logger(name:String) {
			_name = name;
			_shortName = (_shortName=_name.substr( _name.lastIndexOf(".")+1));
		}
		
		/**
		 * @inheritDoc
		 */
		public function debug(message:*, ... params:*):void {
			if(debugTarget) {
				debugTarget.log(_name, _shortName, DEBUG, _startTime+getTimer(), message, params);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function info(message:*, ... params:*):void {
			if(infoTarget) {
				infoTarget.log(_name, _shortName, INFO, _startTime+getTimer(), message, params);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function warn(message:*, ... params:*):void {
			if(warnTarget) {
				warnTarget.log(_name, _shortName, WARN, _startTime+getTimer(), message, params);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function error(message:*, ... params:*):void {
			if(errorTarget) {
				errorTarget.log(_name, _shortName, ERROR, _startTime+getTimer(), message, params);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function fatal(message:*, ... params:*):void {
			if(fatalTarget) {
				fatalTarget.log(_name, _shortName, FATAL, _startTime+getTimer(), message, params);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get debugEnabled():Boolean {
			return debugTarget != null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get infoEnabled():Boolean {
			return infoTarget != null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get warnEnabled():Boolean {
			return warnTarget != null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get errorEnabled():Boolean {
			return errorTarget != null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get fatalEnabled():Boolean {
			return fatalTarget != null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get name():String {
			return _name;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get shortName():String {
			return _shortName;
		}
		
		/**
		 * Sets all loggers to null;
		 */
		public function set allTargets(logTarget: ILogTarget): void {
			debugTarget = infoTarget = warnTarget = errorTarget = fatalTarget = logTarget;
		}
		
		/**
		 * String representation of the Logger.
		 */
		public function toString(): String {
			return "[Logger name='" + _name + "']";
		}
	}
}
