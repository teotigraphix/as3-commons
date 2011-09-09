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
	
	import com.demonsters.debugger.MonsterDebugger;
	
	import org.as3commons.logging.setup.ILogTarget;
	import org.as3commons.logging.util.LogMessageFormatter;
	
	/**
	 * <code>MonsterDebugger3LogTarget</code> uses the log statement to address
	 * the Monster Debugger 3 console.
	 * 
	 * <p>This target does not really add value over the MonsterDebuggerTraceTarget, hence its deprecated.</p> 
	 * 
	 * @author Tim Keir
	 * @author Martin Heidegger
	 * @since 2.5
	 * @deprecated
	 * 
	 * @see org.as3commons.logging.setup.target.MonsterDebugger3TraceTarget
	 * @see http://demonsterdebugger.com/asdoc/com/demonsters/debugger/MonsterDebugger.html#log()
	 */
	public final class MonsterDebugger3LogTarget implements ILogTarget {
		
		/** Formatter that renders the log statements via MonsterDebugger.log(). */
		private const _formatter : LogMessageFormatter = new LogMessageFormatter("{logLevel} {shortName}{atPerson} - {message}");
		
		public function MonsterDebugger3LogTarget() {}
		
		/**
		 * @inheritDoc
		 */
		public function log(name:String, shortName:String, level:int,
							timeStamp:Number, message:*, parameters:Array,
							person:String): void {
			
			if( message is String || ( parameters && parameters.length > 0 ) ) {
				message = _formatter.format(name, shortName, level, timeStamp,
											message, parameters, person);
				MonsterDebugger.log( message );
			} else {
				MonsterDebugger.log( message );
			}
		}
	}
}