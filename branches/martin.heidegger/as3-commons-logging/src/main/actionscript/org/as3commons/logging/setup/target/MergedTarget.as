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
	
	/**
	 * <code>MergedTarget</code> routes a log statement to two <code>ILogTarget</code>s.
	 * 
	 * <p>The logging process assumes that just one logging target will receive
	 * log statements. To have two targets to receive the log statements you can
	 * use this class.</p>
	 * 
	 * @example <listing>
	 *    LOGGER_FACTORY.setup = new SimpleTargetSetup( new MergedTarget( TRACE_TARGET, new SOSTarget ) );
	 *    // Will output the content to trace and to SOS
	 * </listing>
	 * 
	 * @author Martin Heidegger
	 * @since 2
	 */
	public final class MergedTarget implements ILogTarget {
		
		private var _logTargetA:ILogTarget;
		private var _logTargetB:ILogTarget;
		
		/**
		 * Constructs a new <code>MergedTarget</code> out of two <code>ILogTarget</code>s.
		 * 
		 * @param logTargetA First <code>ILogTarget</code> to log to.
		 * @param logTargetB Second <code>ILogTarget</code> to log to.
		 */
		public function MergedTarget(logTargetA:ILogTarget, logTargetB:ILogTarget) {
			_logTargetA = logTargetA;
			_logTargetB = logTargetB;
		}
		
		/**
		 * @inheritDoc
		 */
		public function log(name:String, shortName:String, level:LogLevel, timeStamp:Number,
							message:*, parameters:Array): void {
			_logTargetA.log(name, shortName, level, timeStamp, message, parameters);
			_logTargetB.log(name, shortName, level, timeStamp, message, parameters);
		}
	}
}
