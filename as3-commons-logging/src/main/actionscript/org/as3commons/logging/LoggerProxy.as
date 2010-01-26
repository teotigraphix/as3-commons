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
	 * Proxy for an ILogger implementation. This class is used internally by the LoggerFactory and
	 * should not be used directly.
	 *
	 * <p>A LoggerProxy is created for each logger requested from the factory. This allows us to replace
	 * the ILogger implementations in the global logger factory when its internal factory changes.</p>
	 *
	 * @author Martin Heidegger
	 * @author Christophe Herreman
	 */
	public class LoggerProxy implements ILogger {
		
		/** The proxied logger. */
		private var _logger:ILogTarget;
		
		private var _name:String;
		
		/**
		 * Creates a new LoggerProxy.
		 */
		public function LoggerProxy(name:String, logger:ILogTarget = null) {
			_name = name;
			_logger = logger;
		}
		
		/**
		 * Sets the proxied logger.
		 */
		public function set logger(value:ILogTarget):void {
			_logger = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function debug(message:String = null, ... params:*):void {
			if (_logger) {
				_logger.debug( _name, message, params );
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function info(message:String = null, ... params:*):void {
			if (_logger) {
				_logger.info( _name, message, params);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function warn(message:String = null, ... params:*):void {
			if (_logger) {
				_logger.warn( _name, message, params);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function error(message:String = null, ... params:*):void {
			if (_logger) {
				_logger.error( _name, message, params);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function fatal(message:String = null, ... params:*):void {
			if (_logger) {
				_logger.fatal( _name, message, params);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get debugEnabled():Boolean {
			return (_logger ? _logger.debugEnabled : false);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get infoEnabled():Boolean {
			return (_logger ? _logger.infoEnabled : false);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get warnEnabled():Boolean {
			return (_logger ? _logger.warnEnabled : false);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get errorEnabled():Boolean {
			return (_logger ? _logger.errorEnabled : false);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get fatalEnabled():Boolean {
			return (_logger ? _logger.fatalEnabled : false);
		}
		
		public function get name():String {
			return _name;
		}
	}
}
