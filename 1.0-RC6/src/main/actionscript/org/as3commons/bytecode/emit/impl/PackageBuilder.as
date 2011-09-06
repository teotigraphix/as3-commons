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
package org.as3commons.bytecode.emit.impl {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	import org.as3commons.bytecode.abc.AbcFile;
	import org.as3commons.bytecode.abc.ClassInfo;
	import org.as3commons.bytecode.abc.IConstantPool;
	import org.as3commons.bytecode.abc.InstanceInfo;
	import org.as3commons.bytecode.abc.MethodBody;
	import org.as3commons.bytecode.as3commons_bytecode;
	import org.as3commons.bytecode.emit.IClassBuilder;
	import org.as3commons.bytecode.emit.IInterfaceBuilder;
	import org.as3commons.bytecode.emit.IMethodBodyBuilder;
	import org.as3commons.bytecode.emit.IMethodBuilder;
	import org.as3commons.bytecode.emit.INamespaceBuilder;
	import org.as3commons.bytecode.emit.IPackageBuilder;
	import org.as3commons.bytecode.emit.IPropertyBuilder;
	import org.as3commons.bytecode.emit.impl.event.ExtendedClassesNotFoundError;
	import org.as3commons.bytecode.util.AbcFileUtil;
	import org.as3commons.bytecode.util.MultinameUtil;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.reflect.Type;

	[Event(name = "extendedClassesNotFound", type = "org.as3commons.bytecode.emit.impl.event.ExtendedClassesNotFoundError")]
	/**
	 * @author Roland Zwaga
	 */
	public class PackageBuilder implements IPackageBuilder {

		private var _classBuilders:Array;
		private var _namespaceBuilders:Array;
		private var _interfaceBuilders:Array;
		private var _abcFile:AbcFile;
		private var _eventDispatcher:IEventDispatcher;
		private var _classBuilderLookup:Dictionary;
		private var _namespaceBuilderLookup:Dictionary;
		private var _constantPool:IConstantPool;
		private var _isDefaultPackage:Boolean;

		/**
		 * Creates a new <code>PackageBuilder</code> instance.
		 * @param name The fully qualified name of the package. I.e. <code>com.myclasses.generated</code>
		 */
		public function PackageBuilder(name:String, abcFile:AbcFile = null) {
			super();
			init(name, abcFile);
		}

		private function init(name:String, abcFile:AbcFile):void {
			_isDefaultPackage = !StringUtils.hasText(name);
			_eventDispatcher = new EventDispatcher();
			_packageName = removeTrailingPeriod(name);
			_classBuilders = [];
			_namespaceBuilders = [];
			_interfaceBuilders = [];
			_classBuilderLookup = new Dictionary();
			_namespaceBuilderLookup = new Dictionary();
			_abcFile = abcFile;
		}

		public function get constantPool():IConstantPool {
			return _constantPool;
		}

		public function set constantPool(value:IConstantPool):void {
			_constantPool = value;
		}

		private var _packageName:String;

		/**
		 * @inheritDoc
		 */
		public function get packageName():String {
			return _packageName;
		}


		public function defineNamespace(scopeName:String, URI:String):INamespaceBuilder {
			var nsb:NamespaceBuilder = _namespaceBuilderLookup[scopeName];
			if (nsb == null) {
				nsb = new NamespaceBuilder();
				nsb.packageName = packageName;
				nsb.scopeName = scopeName;
				nsb.URI = URI;
				_namespaceBuilderLookup[scopeName] = nsb;
				_namespaceBuilders[_namespaceBuilders.length] = nsb;
			}
			return nsb;
		}

		/**
		 * @inheritDoc
		 */
		public function defineClass(name:String, superClassName:String = null):IClassBuilder {
			var fullName:String = packageName + MultinameUtil.PERIOD + name;
			var cb:ClassBuilder = _classBuilderLookup[fullName];
			if (cb == null) {
				cb = new ClassBuilder();
				_classBuilderLookup[fullName] = cb;
				cb.addEventListener(ExtendedClassesNotFoundError.EXTENDED_CLASSES_NOT_FOUND, classNotFoundHandler);
				cb.name = name;
				cb.packageName = packageName;
				cb.superClassName = superClassName;
				if (_abcFile != null) {
					var classInfo:ClassInfo = AbcFileUtil.getClassinfoByFullyQualifiedName(_abcFile, fullName);
					if (classInfo != null) {
						cb.as3commons_bytecode::setClassInfo(classInfo);
					}
					var instanceInfo:InstanceInfo = AbcFileUtil.getInstanceinfoByFullyQualifiedName(_abcFile, fullName);
					if (instanceInfo != null) {
						cb.as3commons_bytecode::setInstanceInfo(instanceInfo);
					}
				}
				cb.constantPool = _constantPool;
				_classBuilders[_classBuilders.length] = cb;
			}
			return cb;
		}

		/**
		 * @inheritDoc
		 */
		public function defineInterface(name:String, superInterfaceNames:Array = null):IInterfaceBuilder {
			var ib:InterfaceBuilder = new InterfaceBuilder();
			ib.name = name;
			if (superInterfaceNames != null) {
				ib.extendingInterfacesNames = superInterfaceNames;
			}
			ib.packageName = packageName;
			_interfaceBuilders[_interfaceBuilders.length] = ib;
			return ib;
		}

		/**
		 * @inheritDoc
		 */
		public function build(applicationDomain:ApplicationDomain):Array {
			var result:Array = [];
			for each (var cb:IClassBuilder in _classBuilders) {
				result = result.concat(cb.build(applicationDomain));
			}
			for each (var ib:IInterfaceBuilder in _interfaceBuilders) {
				result[result.length] = ib.build(applicationDomain);
			}
			for each (var nsb:INamespaceBuilder in _namespaceBuilders) {
				result[result.length] = nsb.build();
			}
			return result;
		}


		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			_eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		public function dispatchEvent(event:Event):Boolean {
			return _eventDispatcher.dispatchEvent(event);
		}

		public function hasEventListener(type:String):Boolean {
			return _eventDispatcher.hasEventListener(type);
		}

		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			_eventDispatcher.removeEventListener(type, listener, useCapture);
		}

		public function willTrigger(type:String):Boolean {
			return _eventDispatcher.willTrigger(type);
		}

		protected function classNotFoundHandler(event:ExtendedClassesNotFoundError):void {
			var extendedClasses:Array = [];
			if (!extractExtendeClasses(extendedClasses, event.className, event.applicationDomain)) {
				event.extendedClasses = event.extendedClasses.concat(extendedClasses);
				dispatchEvent(event);
			}
		}

		public function extractExtendeClasses(extendedClasses:Array, className:String, applicationDomain:ApplicationDomain):Boolean {
			var classBuilder:IClassBuilder = _classBuilderLookup[className];
			if (classBuilder != null) {
				extendedClasses[extendedClasses.length] = classBuilder.superClassName;
				if (applicationDomain.hasDefinition(classBuilder.superClassName)) {
					var type:Type = Type.forName(classBuilder.superClassName, applicationDomain);
					for each (var name:String in type.extendsClasses) {
						extendedClasses[extendedClasses.length] = name;
					}
					return true;
				} else {
					return extractExtendeClasses(extendedClasses, classBuilder.superClassName, applicationDomain);
				}
			}
			return false;
		}

		/**
		 * If the specified input has a trailing period ('.') it will be removed from the string
		 * and the result will be returned. Otherwise the original string is returned.
		 * @param input The specified input string.
		 * @return The input without a trailing period.
		 */
		public static function removeTrailingPeriod(input:String):String {
			if (input.charAt(input.length - 1) == '.') {
				return input.substring(0, input.length - 1);
			}
			return input;
		}
	}
}
