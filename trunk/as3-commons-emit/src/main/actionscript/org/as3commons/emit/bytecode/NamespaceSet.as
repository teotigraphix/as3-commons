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

	import org.as3commons.emit.SWFConstant;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.IEquals;

	public class NamespaceSet implements IEquals {
		private var _namespaces:Array;

		public function NamespaceSet(namespaces:Array) {
			super();
			initNamespaceSet(namespaces);
		}

		protected function initNamespaceSet(namespaces:Array):void {
			Assert.notNull(namespaces, "namespaces argument must not be null");
			_namespaces = [].concat(namespaces);
		}


		public function get namespaces():Array {
			return _namespaces;
		}

		public function equals(object:Object):Boolean {
			var namespaceSet:NamespaceSet = object as NamespaceSet;

			if (namespaceSet != null) {
				if (namespaceSet._namespaces.length == _namespaces.length) {
					for (var i:uint = 0; i < _namespaces.length; i++) {
						if (!IEquals(namespaceSet._namespaces[i]).equals(_namespaces[i]))
							return false;
					}

					return true;
				}
			}

			return false;
		}

		public function toString():String {
			return SWFConstant.SQUARE_BRACKET_OPEN + _namespaces.join(SWFConstant.COMMA) + SWFConstant.SQUARE_BRACKET_CLOSE;
		}
	}
}