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
	
	import org.as3commons.logging.LogLevel;
	
	/**
	 * Holder for the content of one log statement.
	 * 
	 * @author Martin Heidegger
	 * @since 2.0
	 * @see org.as3commons.logging.setup.target#BUFFER_TARGET
	 */
	public final class BufferStatement {
		
		/** Name of the logger that triggered the log statement. */
		public var name: String;
		
		/** Shortened form of the name. */
		public var shortName: String;
		
		/** Level of the log statement that got triggered. */
		public var level: LogLevel;
		
		/** Time stamp of when the log statement got triggered. */
		public var timeStamp: Number;
		
		/** Message of the log statement. */
		public var message: *;
		
		/** Parameters for the log statement. */
		public var parameters: Array;
		
		/**
		 * Constructs a new <code>BufferStatement</code> containing the content
		 * of a logging statement.
		 * 
		 * @param name Name of the logger that triggered the log statement.
		 * @param shortName Shortened form of the name.
		 * @param level Level of the log statement that got triggered.
		 * @param timeStamp Time stamp of when the log statement got triggered.
		 * @param message Message of the log statement.
		 * @param parameters Parameters for the log statement.
		 */
		public function BufferStatement(name:String, shortName:String, level:LogLevel,
										timeStamp:Number, message:*, parameters:Array) {
			this.name = name;
			this.shortName = shortName;
			this.level = level;
			this.timeStamp = timeStamp;
			this.message = message;
			this.parameters = parameters;
		}
	}
}
