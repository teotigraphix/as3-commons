/**
 * Copyright 2009 Maxim Cassian Porges
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.as3commons.bytecode.typeinfo {
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	import org.as3commons.bytecode.abc.BaseMultiname;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.lang.StringUtils;

	/**
	 * Represents the definition for a <code>Class</code>.
	 */
	//TODO: Test setters/getters
	public class ClassDefinition extends Annotatable {
		private static const WRONG_INITIALIZER_TYPE_ERROR:String = "Instance initializer must be of type Method and not one of its subtypes.";
		private var _constructor:Method;
		private var _scriptInitializer:Method;
		private var _instanceInitializer:Method;

		private var _instanceMethods:Array;
		private var _staticMethods:Array;
		private var _instanceFields:Array;
		private var _staticFields:Array;

		private var _interfaces:Array;

		public var superClass:QualifiedName;
		public var className:QualifiedName;
		public var isFinal:Boolean;
		public var isSealed:Boolean;
		public var isInterface:Boolean;
		public var isProtectedNamespace:Boolean;

		public function ClassDefinition() {
			_instanceMethods = [];
			_staticMethods = [];
			_instanceFields = [];
			_staticFields = [];
			_interfaces = [];
//			properties = [];
		}

		public function get interfaces():Array {
			return _interfaces;
		}

		public function addInterface(interfaceName:BaseMultiname):void {
			_interfaces[_interfaces.length] = interfaceName;
		}

		public function get instanceInitializer():Method {
			return _instanceInitializer;
		}

		public function set instanceInitializer(method:Method):void {
			if (getDefinitionByName(getQualifiedClassName(method)) != Method) {
				throw new Error(WRONG_INITIALIZER_TYPE_ERROR);
			}

			_instanceInitializer = method;
		}

		public function addMethod(methodName:QualifiedName, returnType:BaseMultiname, isStatic:Boolean = false, isOverride:Boolean = false, isFinal:Boolean = false):Method {
			return createMethod(Method, methodName, returnType, isStatic, isOverride, isFinal);
		}

		public function addGetter(methodName:QualifiedName, returnType:BaseMultiname, isStatic:Boolean = false, isOverride:Boolean = false, isFinal:Boolean = false):Getter {
			return createMethod(Getter, methodName, returnType, isStatic, isOverride, isFinal) as Getter;
		}

		public function addSetter(methodName:QualifiedName, returnType:BaseMultiname, isStatic:Boolean = false, isOverride:Boolean = false, isFinal:Boolean = false):Setter {
			return createMethod(Setter, methodName, returnType, isStatic, isOverride, isFinal) as Setter;
		}

		private function createMethod(clazz:Class, methodName:QualifiedName, returnType:BaseMultiname, isStatic:Boolean, isOverride:Boolean, isFinal:Boolean = false):Method {
			var method:Method = new clazz(methodName, returnType, isStatic, isOverride, isFinal);
			var arr:Array = (isStatic) ? _staticMethods : _instanceMethods;
			arr[arr.length] = method;
			return method;
		}

		public function addField(fieldName:QualifiedName, type:QualifiedName, isStatic:Boolean = false):Field {
			var field:Field = new Field(fieldName, type);
			var arr:Array = (isStatic) ? _staticFields : _instanceFields;
			arr[arr.length] = field;
			return field;
		}

		public function get instanceMethods():Array {
			return _instanceMethods;
		}

		public function get staticMethods():Array {
			return _staticMethods;
		}

		public function get instanceFields():Array {
			return _instanceFields;
		}

		public function get staticFields():Array {
			return _staticFields;
		}

		public function toString():String {
			return StringUtils.substitute("{0}{1}{2}{3} {4} extends {5} {6}\n{\n\t// fields\n\t{7}\n\n\t//constructor\n\t{8}\n\n\t// methods\n\t{9}\n}", className.nameSpace.kind.description, (isFinal) ? " final" : "", (isSealed) ? " sealed" : "", (isInterface) ? " interface" : " class", className.nameSpace.name + "::" + className.name, superClass.nameSpace.name + "::" + superClass.name, (_interfaces.length > 0) ? ("implements " + _interfaces.join(", ")) : "", _instanceFields.join("\n\t"), _instanceInitializer, _instanceMethods.join("\n\t"));
		}
	}
}