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
		private var _parameters:Array;

		public function MultinameG(qName:QualifiedName, params:Array, kindValue:MultinameKind=null) {
			kindValue ||= MultinameKind.GENERIC;
			super(kindValue);
			assertAppropriateMultinameKind([MultinameKind.GENERIC], kindValue);
			_qualifiedName = qName;
			_parameters = params;
		}
		
		public function get fullName():String {
			return _qualifiedName.fullName + ".<" + _parameters[0].fullName + ">";
		}

		override public function clone():* {
			return new MultinameG(_qualifiedName.clone(), _parameters, kind);
		}

		public function get paramCount():uint {
			return _parameters.length;
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
					if (paramCount == mg.paramCount) {
						for (var i:int = 0; i < paramCount; ++i) {
							if (!IEquals(_parameters[i]).equals(mg.parameters[i])) {
								return false;
							}
						}
						return super.equals(other);
					}
				}
			}
			return false;
		}

		public override function toString():String {
			return "MultinameG{qualifiedName:" + _qualifiedName + ", parameters:[" + paramatersToString(_parameters) + "]}";
		}

		private function paramatersToString(params:Array):String {
			var result:Vector.<String> = new Vector.<String>();
			for each (var mn:BaseMultiname in params) {
				result[result.length] = mn.toString();
			}
			return result.join(",");
		}

	}
}
