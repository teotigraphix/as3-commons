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
package org.as3commons.bytecode.emit.impl {
	import flash.errors.IllegalOperationError;
	import flash.system.ApplicationDomain;

	import org.as3commons.bytecode.abc.AbcFile;
	import org.as3commons.bytecode.abc.ClassInfo;
	import org.as3commons.bytecode.abc.InstanceInfo;
	import org.as3commons.bytecode.abc.MethodInfo;
	import org.as3commons.bytecode.abc.MethodTrait;
	import org.as3commons.bytecode.abc.enum.BuiltIns;
	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.bytecode.emit.IAccessorBuilder;
	import org.as3commons.bytecode.emit.ICtorBuilder;
	import org.as3commons.bytecode.emit.IInterfaceBuilder;
	import org.as3commons.bytecode.emit.IPropertyBuilder;
	import org.as3commons.bytecode.util.MultinameUtil;
	import org.as3commons.lang.StringUtils;

	public class InterfaceBuilder extends BaseTypeBuilder implements IInterfaceBuilder {

		private static const INTERFACE_STATIC_METHOD_ERROR:String = "Interfaces cannot have static methods";
		private static const DOUBLE_COLON:String = ':';

		private var _extendingInterfacesNames:Array;

		public function InterfaceBuilder() {
			super();
		}

		override protected function createAccessorBuilder(name:String, type:String, initialValue:* = undefined):IAccessorBuilder {
			var ab:InterfaceAccessorBuilder = new InterfaceAccessorBuilder();
			ab.packageName = packageName;
			ab.interfaceName = this.name;
			ab.name = name;
			ab.type = type;
			ab.initialValue = initialValue;
			return ab;
		}

		public function get extendingInterfacesNames():Array {
			return _extendingInterfacesNames;
		}

		public function set extendingInterfacesNames(value:Array):void {
			_extendingInterfacesNames = value;
		}

		override public function build(applicationDomain:ApplicationDomain):Array {
			var methods:Array = createMethods(metadata, 4);
			methods = methods.concat(createAccessors());
			var classInfo:ClassInfo = createClassInfo(null, methods, 4);
			var instanceInfo:InstanceInfo = new InstanceInfo();
			var ctorBuilder:ICtorBuilder = createStaticConstructor([], true);
			instanceInfo.instanceInitializer = ctorBuilder.build();
			instanceInfo.instanceInitializer.methodBody = null;
			instanceInfo.instanceInitializer.methodName = StringUtils.substitute(ClassBuilder.CONSTRUCTOR_NAME, packageName, name);
			instanceInfo.classInfo = classInfo;
			instanceInfo.classMultiname = MultinameUtil.toQualifiedName(packageName + MultinameUtil.DOUBLE_COLON + name);
			instanceInfo.superclassMultiname = BuiltIns.ANY;
			instanceInfo.isInterface = true;
			for each (var intfName:String in _extendingInterfacesNames) {
				instanceInfo.interfaceMultinames[instanceInfo.interfaceMultinames.length] = MultinameUtil.toMultiName(intfName, NamespaceKind.PACKAGE_NAMESPACE);
			}
			var metadata:Array = buildMetadata();
			return [classInfo, instanceInfo, methods, metadata];
		}

	}
}