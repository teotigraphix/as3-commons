/*
 * Copyright 2007-2010 the original author or authors.
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
package org.as3commons.bytecode.tags.serialization {
	import flash.utils.Dictionary;

	import org.as3commons.bytecode.tags.struct.FillStyle;
	import org.as3commons.bytecode.tags.struct.RGB;
	import org.as3commons.bytecode.tags.struct.RGBA;
	import org.as3commons.bytecode.tags.struct.Symbol;

	public class StructSerializerFactory implements IStructSerializerFactory {

		private var _createdFactories:Dictionary;
		private var _factoryClasses:Dictionary;

		public function StructSerializerFactory() {
			super();
			initFactory();
		}

		protected function initFactory():void {
			_createdFactories = new Dictionary();
			_factoryClasses = new Dictionary();
			_factoryClasses[FillStyle] = FillStyleSerializer;
			_factoryClasses[RGB] = RGBSerializer;
			_factoryClasses[RGBA] = RGBASerializer;
			_factoryClasses[Symbol] = SymbolSerializer;
		}

		public function createSerializer(structClass:Class):IStructSerializer {
			if (_createdFactories[structClass] == null) {
				if (_factoryClasses[structClass] != null) {
					_createdFactories[structClass] = new _factoryClasses[structClass]();
				} else {
					throw new Error("Unable to create serializer for struct class " + structClass);
				}
			}
			return _createdFactories[structClass];
		}
	}
}