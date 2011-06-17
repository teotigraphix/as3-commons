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
package org.as3commons.logging.util {
	
	import flash.events.ErrorEvent;
	
	/**
	 * Error Holder that is easily transferable via JavaScript or alike
	 * 
	 * @author Martin Heidegger
	 * @since 2.1
	 */
	public class ErrorHolder {
		
		/** Text of the Error */
		public var text: String;
		
		/** Holds the StackTrace */
		public var stackTrace: String;
		
		/** Number of the Error */
		public var errorNo: int;
		
		/**
		 * Takes errors or ErrorEvents that holds Errors
		 * 
		 * @param e Error or ErrorEvent
		 */
		public function ErrorHolder( e: Object ) {
			if( e is ErrorEvent ) {
				errorNo = ErrorEvent( e ).errorID;
			} else {
				errorNo = -1;
			}
			if( e.hasOwnProperty("error") ) {
				e = e["error"];
			}
			
			try {
				text = e.message;
				errorNo = e.errorID;
				stackTrace = e.getStackTrace();
			} catch( error: Error ) {
				text = e.toString();
			}
		}
		
		/**
		 * Stringification of the error
		 */
		public function toString(): String {
			return "Error[" + errorNo + "]: " + text + "\n" + stackTrace;
		}
	}
}
