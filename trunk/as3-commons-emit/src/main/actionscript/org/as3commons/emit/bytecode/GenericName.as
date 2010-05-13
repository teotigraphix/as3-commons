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
	import org.as3commons.lang.Assert;

	public class GenericName extends AbstractMultiname {
		private var _typeDefinition:AbstractMultiname;
		private var _genericParameters:Array;

		public function GenericName(typeDefinition:AbstractMultiname, genericParameters:Array, kind:uint = 0x1D) {
			super(kind);
			initGenericName(typeDefinition, genericParameters);
			initGenericName(typeDefinition, genericParameters);
		}

		protected function initGenericName(typeDefinition:AbstractMultiname, genericParameters:Array):void {
			Assert.notNull(typeDefinition, "typeDefinition argument must not be null");
			Assert.notNull(genericParameters, "genericParameters argument must not be null");
			_typeDefinition = typeDefinition;
			_genericParameters = [].concat(genericParameters);
		}

		public function get typeDefinition():AbstractMultiname {
			return _typeDefinition;
		}

		public function get genericParameters():Array {
			return _genericParameters;
		}

		public override function equals(object:Object):Boolean {
			var gn:GenericName = object as GenericName;

			if (gn != null) {
				if (!gn._typeDefinition.equals(_typeDefinition) || gn._genericParameters.length != _genericParameters.length) {
					return false;
				}

				for (var i:int = 0; i < _genericParameters.length; i++) {
					if (!gn._genericParameters[i].equals(_genericParameters[i])) {
						return false;
					}
				}

				return true;
			}

			return false;
		}
	}
}