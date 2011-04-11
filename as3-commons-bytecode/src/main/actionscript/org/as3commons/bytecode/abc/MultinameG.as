/*
 * Copyright 2007-2011 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.as3commons.bytecode.abc {
	import org.as3commons.bytecode.abc.enum.MultinameKind;
	import org.as3commons.lang.IEquals;

	public final class MultinameG extends BaseMultiname {

		private var _qualifiedName:QualifiedName;
		private var _paramCount:uint;
		private var _parameters:Array;

		public function MultinameG(qName:QualifiedName, pCount:uint, params:Array, kindValue:MultinameKind = null) {
			kindValue ||= MultinameKind.GENERIC;
			super(kindValue);
			initMultinameG(kindValue, qName, pCount, params);
		}

		private function initMultinameG(kindValue:MultinameKind, qName:QualifiedName, pCount:uint, params:Array):void {
			assertAppropriateMultinameKind([MultinameKind.GENERIC], kindValue);
			_qualifiedName = qName;
			_paramCount = pCount;
			_parameters = params;
		}

		override public function clone():* {
			return new MultinameG(_qualifiedName.clone(), _paramCount, _parameters, kind);
		}

		public function get paramCount():uint {
			return _paramCount;
		}

		public function set paramCount(value:uint):void {
			_paramCount = value;
		}

		public function get parameters():Array {
			return _parameters;
		}

		public function set parameters(value:Array):void {
			_parameters = value;
		}

		public function get qualifiedName():QualifiedName {
			return _qualifiedName;
		}

		public function set qualifiedName(value:QualifiedName):void {
			_qualifiedName = value;
		}

		override public function equals(other:Object):Boolean {
			var mg:MultinameG = (other as MultinameG);
			if (mg != null) {
				if (_qualifiedName.equals(mg.qualifiedName)) {
					if (_paramCount == mg._paramCount) {
						for (var i:int = 0; i < paramCount; ++i) {
							if (IEquals(_parameters[i]).equals(mg.parameters[i])) {
								return false;
							}
						}
						return super.equals(other);
					}
				}
			}
			return false;
		}

	}
}