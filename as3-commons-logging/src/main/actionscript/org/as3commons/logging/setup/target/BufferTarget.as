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
package org.as3commons.logging.setup.target {
	
	/**
	 * @author Martin Heidegger
	 */
	public final class BufferTarget implements IAsyncLogTarget {
		
		private var _logStatements:Array /* LogStatement */ = new Array();
		
		/** Holds the length of the log statements */
		private var _length:int = 0;
		
		private var _introspectDepth:uint;
		private var _maxStatements:uint;
		
		public function BufferTarget(maxStatements:uint=uint.MAX_VALUE, introspectDepth:uint=5) {
			_maxStatements=maxStatements;
			_introspectDepth=introspectDepth;
		}
		
		public function get statements():Array {
			return _logStatements;
		}
		
		public function set maxStatements(max:uint):void {
			_maxStatements=max;
		}
		
		public function set introspectDepth(depth:uint): void {
			_introspectDepth=depth;
		}
		
		/**
		 * @inheritDoc
		 */
		public function log(name:String, shortName:String, level:int,
							timeStamp:Number, message:*, params:Array,
							person:String): void {
			_logStatements[++_length] =
				new LogStatement(name, shortName, level, timeStamp,
									message, params, person, _introspectDepth);
			
			while(_maxStatements > _length) {
				_logStatements.shift();
				--_length;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function clear():void {
			_logStatements = [];
			_length = 0;
		}
	}
}
