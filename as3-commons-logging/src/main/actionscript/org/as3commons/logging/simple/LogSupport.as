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
package org.as3commons.logging.simple {
	
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.getLogger;
	
	/**
	 * @author mh
	 */
	public class LogSupport {
		
		private var _logger:ILogger;
		
		public function LogSupport(person:String=null ) {
			_logger = getLogger(this,person);
		}
		
		protected function debug( message: *, ...parameters:Array ): void {
			_logger.debug.apply( [message].concat( parameters ) );
		}
		
		protected function get debugEnabled(): Boolean {
			return _logger.debugEnabled;
		}
		
		protected function info( message: *, ...parameters:Array ): void {
			_logger.info.apply( [message].concat( parameters ) );
		}
		
		protected function get infoEnabled(): Boolean {
			return _logger.infoEnabled;
		}
		
		protected function warn( message: *, ...parameters:Array ): void {
			_logger.warn.apply( [message].concat( parameters ) );
		}
		
		protected function get warnEnabled(): Boolean {
			return _logger.warnEnabled;
		}
		
		protected function error( message: *, ...parameters:Array ): void {
			_logger.error.apply( [message].concat( parameters ) );
		}
		
		protected function get errorEnabled(): Boolean {
			return _logger.errorEnabled;
		}
		
		protected function fatal( message: *, ...parameters:Array ): void {
			_logger.fatal.apply( [message].concat( parameters ) );
		}
		
		protected function get fatalEnabled(): Boolean {
			return _logger.fatalEnabled;
		}
	}
}
