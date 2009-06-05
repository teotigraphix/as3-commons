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
package org.as3commons.logging.impl {
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.ILoggerFactory;
	
	/**
	 * Logger factory for the Monster Debugger
	 *
	 * @author Christophe Herreman
	 */
	public class MonsterDebuggerLoggerFactory implements ILoggerFactory {
		
		/** the instance of the Monster Debugger */
		private var _debugger:MonsterDebugger;
		
		/**
		 * Creates a new MonsterDebuggerLoggerFactory
		 *
		 * @param target the target object the Monster Debugger monitors
		 */
		public function MonsterDebuggerLoggerFactory(target:Object = null) {
			if (target) {
				_debugger = new MonsterDebugger(target);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function getLogger(name:String):ILogger {
			return new MonsterDebuggerLogger(name);
		}
	}
}