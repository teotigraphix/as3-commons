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
	
	import org.as3commons.logging.util.clone;
	
	/**
	 * <code>LogStatement</code> is a data holder for the content of one log statement.
	 * 
	 * @author Martin Heidegger
	 * @since 2
	 * @see org.as3commons.logging.setup.target.BufferTarget
	 */
	public final class LogStatement {
		
		/** Name of the logger that triggered the log statement. */
		public var name: String;
		
		/** Shortened form of the name. */
		public var shortName: String;
		
		/** Level of the log statement that got triggered. */
		public var level: int;
		
		/** Time stamp of when the log statement got triggered. */
		public var timeStamp: Number;
		
		/** Information about the person that logged this. */
		public var person: String;
		
		/** Message of the log statement. */
		public var message: *;
		
		/** Parameters for the log statement. */
		public var parameters: Array;
		
		/**
		 * Constructs a new <code>LogStatement</code> containing the content
		 * of a logging statement.
		 * 
		 * @param name Name of the logger that triggered the log statement.
		 * @param shortName Shortened form of the name.
		 * @param level Level of the log statement that got triggered.
		 * @param timeStamp Time stamp of when the log statement got triggered.
		 * @param message Message of the log statement.
		 * @param parameters Parameters for the log statement.
		 * @param person Information about the person that filed this log statement.
		 */
		public function LogStatement(name:String, shortName:String, level:int,
										timeStamp:Number, message:*, parameters:Array,
										person:String) {
			this.name = name;
			this.shortName = shortName;
			this.level = level;
			this.timeStamp = timeStamp;
			
			this.message = ( message is String || message is Number || message is Boolean || message == null ) ? message : clone(message);
			var l: int = parameters.length;
			var foundNonPrimitive: Boolean = false;
			for( var i: int = 0; i<l; ++i) {
				var m: * = parameters[i]; 
				if( !(m is String || m is Number || m is Boolean) ) {
					foundNonPrimitive = true;
					break;
				}
			}
			this.parameters = foundNonPrimitive ? clone(parameters) : parameters;
			this.person = person;
		}
	}
} 