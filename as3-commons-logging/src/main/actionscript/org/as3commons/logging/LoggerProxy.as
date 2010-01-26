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
	import flash.utils.getTimer;

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
		private var _debugEnabled:Boolean = false;
		private var _infoEnabled:Boolean = false;
		private var _warnEnabled:Boolean = false;
		private var _errorEnabled:Boolean = false;
		private var _fatalEnabled:Boolean = false;
		
		private static const _startTime: Number = new Date().getTime() - getTimer();
		
		/**
		 * Creates a new LoggerProxy.
		 */
		public function LoggerProxy(name:String, logger:ILogTarget = null) {
			_name = name;
			this.logger = logger;
		}
		
		/**
		 * Sets the proxied logger.
		 */
		public function set logger(value:ILogTarget):void {
			_logger = value;
			_debugEnabled = _logger && _logger.debugEnabled;
			_infoEnabled = _logger && _logger.infoEnabled;
			_warnEnabled = _logger && _logger.warnEnabled;
			_errorEnabled = _logger && _logger.errorEnabled;
			_fatalEnabled = _logger && _logger.fatalEnabled;
		}
		
		/**
		 * @inheritDoc
		 */
		public function debug(message:String = null, ... params:*):void {
			if (_debugEnabled) {
				_logger.debug( _name, _startTime+getTimer(), message, params );
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function info(message:String = null, ... params:*):void {
			if (_infoEnabled) {
				_logger.info( _name, _startTime+getTimer(), message, params);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function warn(message:String = null, ... params:*):void {
			if (_warnEnabled) {
				_logger.warn( _name, _startTime+getTimer(), message, params);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function error(message:String = null, ... params:*):void {
			if (_errorEnabled) {
				_logger.error( _name, _startTime+getTimer(), message, params);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function fatal(message:String = null, ... params:*):void {
			if (_fatalEnabled) {
				_logger.fatal( _name, _startTime+getTimer(), message, params);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get debugEnabled():Boolean {
			return _debugEnabled;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get infoEnabled():Boolean {
			return _infoEnabled;
		}

		/**
		 * @inheritDoc
		 */
		public function get warnEnabled():Boolean {
			return _warnEnabled;
		}

		/**
		 * @inheritDoc
		 */
		public function get errorEnabled():Boolean {
			return _errorEnabled;
		}

		/**
		 * @inheritDoc
		 */
		public function get fatalEnabled():Boolean {
			return _fatalEnabled;
		}

		public function get name():String {
			return _name;
		}
		
		public function set errorEnabled(errorEnabled:Boolean):void {
			_errorEnabled = errorEnabled;
		}
	}
}
