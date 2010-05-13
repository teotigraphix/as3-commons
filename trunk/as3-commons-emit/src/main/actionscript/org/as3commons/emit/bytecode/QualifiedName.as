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

	public class QualifiedName extends AbstractMultiname {
		private var _name:String;
		private var _ns:BCNamespace;

		public function QualifiedName(ns:BCNamespace, name:String, kind:uint = 0x07) {
			super(kind);

			_ns = ns;
			_name = name;
		}

		public function get ns():BCNamespace {
			return _ns;
		}

		public function get name():String {
			return _name;
		}

		public override function equals(object:Object):Boolean {
			var qname:QualifiedName = object as QualifiedName;

			if (qname != null) {
				return qname.ns.equals(this._ns) && qname.name == this._name;
			}

			return false;
		}

		public function toString():String {
			var nsString:String = ns.toString();
			var sepChar:String = (nsString.indexOf(':') == -1) ? ':' : '/';

			return nsString.concat(sepChar, name);
		}
	}
}