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

	import org.as3commons.lang.IEquals;

	public class BCNamespace implements IEquals {
		private var _name:String;
		private var _kind:uint;

		public function BCNamespace(name:String, kind:uint) {
			_name = name;
			_kind = kind;
		}

		public function get name():String {
			return _name;
		}

		public function get kind():uint {
			return _kind;
		}

		public function equals(object:Object):Boolean {
			var ns:BCNamespace = object as BCNamespace;

			if (ns != null) {
				return ns.name == _name && ns.kind == _kind;
			}

			return false;
		}

		public function toString():String {
			return _name;
		}

		public static function packageNS(name:String):BCNamespace {
			return new BCNamespace(name, NamespaceKind.PACKAGE_NAMESPACE);
		}
	}
}