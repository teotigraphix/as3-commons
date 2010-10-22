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
	import org.as3commons.logging.setup.ILogTarget;
	import org.as3commons.logging.util.LogMessageFormatter;

	/**
	 * Default AS3Commons logging implementation of the ILogger interface that writes messages to the console using
	 * the trace() method. If no ILoggerFactory is set on the LoggerFactory, then this is the logger that will be used.
	 *
	 * @author Christophe Herreman
	 * @author Martin Heidegger
	 */
	public final class TraceTarget implements ILogTarget {
		
		public static const DEFAULT_FORMAT: String = "{time} {logLevel} - {shortName} - {message}";
		public static const INSTANCE: TraceTarget = new TraceTarget();
		
		private var _formatter:LogMessageFormatter;
		
		public function TraceTarget( format: String = null ) {
			_formatter = new LogMessageFormatter( format || DEFAULT_FORMAT );
		}
		
		public function log(name:String, shortName:String, level:LogLevel, timeStamp:Number, message:*, parameters:Array):void {
			trace( _formatter.format( name, shortName, level, timeStamp, message, parameters));
		}
	}
}