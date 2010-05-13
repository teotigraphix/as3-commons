/*
 * Copyright (c) 2007-2009-2010 the original author or authors
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
package org.as3commons.emit.bytecode {
	import org.as3commons.emit.reflect.EmitMethod;
	import org.as3commons.lang.Assert;

	public class DynamicMethod {

		private var _method:EmitMethod;
		private var _maxStack:uint = 0;
		private var _minScope:uint = 0;
		private var _maxScope:uint = 0;
		private var _maxLocal:uint = 0;
		private var _instructionSet:Array = [];

		public function get instructionSet():Array {
			return _instructionSet;
		}

		public function get method():EmitMethod {
			return _method;
		}

		public function get maxStack():uint {
			return _maxStack;
		}

		public function get minScope():uint {
			return _minScope;
		}

		public function get maxScope():uint {
			return _maxScope;
		}

		public function get maxLocal():uint {
			return _maxLocal;
		}

		public function DynamicMethod(method:EmitMethod, maxStack:uint, maxLocal:uint, minScope:uint, maxScope:uint, instructions:Array) {
			super();
			initDynamicMethod(method, maxStack, maxLocal, minScope, maxScope, instructions);
		}

		protected function initDynamicMethod(method:EmitMethod, maxStack:uint, maxLocal:uint, minScope:uint, maxScope:uint, instructions:Array):void {
			Assert.notNull(method, "method argument must not be null");
			Assert.notNull(instructions, "instructions argument must not be null");
			_method = method;
			_minScope = minScope;
			_maxScope = maxScope;
			_maxLocal = maxLocal;
			_maxStack = maxStack;
			_instructionSet = instructions;
		}
	}
}