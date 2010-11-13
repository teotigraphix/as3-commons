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
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	import org.as3commons.bytecode.abc.AbcFile;
	import org.as3commons.bytecode.abc.ClassInfo;
	import org.as3commons.bytecode.abc.InstanceInfo;
	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.MethodInfo;
	import org.as3commons.bytecode.abc.MethodTrait;
	import org.as3commons.bytecode.abc.Multiname;
	import org.as3commons.bytecode.abc.Op;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.SlotOrConstantTrait;
	import org.as3commons.bytecode.abc.enum.BuiltIns;
	import org.as3commons.bytecode.abc.enum.ConstantKind;
	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.bytecode.abc.enum.Opcode;
	import org.as3commons.bytecode.as3commons_bytecode;
	import org.as3commons.bytecode.emit.IAccessorBuilder;
	import org.as3commons.bytecode.emit.IClassBuilder;
	import org.as3commons.bytecode.emit.ICtorBuilder;
	import org.as3commons.bytecode.emit.IMetaDataBuilder;
	import org.as3commons.bytecode.emit.IMethodBodyBuilder;
	import org.as3commons.bytecode.emit.IMethodBuilder;
	import org.as3commons.bytecode.emit.IPropertyBuilder;
	import org.as3commons.bytecode.emit.impl.event.ExtendedClassesNotFoundError;
	import org.as3commons.bytecode.util.AbcDeserializer;
	import org.as3commons.bytecode.util.MultinameUtil;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.reflect.Type;

	[Event(name="extendedClassesNotFound", type="org.as3commons.bytecode.emit.impl.event.ExtendedClassesNotFoundError")]
	/**
	 * @author Roland Zwaga
	 */
	public class ClassBuilder extends BaseTypeBuilder implements IClassBuilder, IEventDispatcher {

		public static const CONSTRUCTOR_NAME:String = "{0}.{1}/{1}";

		private var _ctorBuilder:ICtorBuilder;
		private var _propertyBuilders:Array;
		private var _implementedInterfaceNames:Array;
		private var _superClassName:String;
		private var _isDynamic:Boolean = false;
		private var _isFinal:Boolean;
		private var _eventDispatcher:IEventDispatcher;

		/**
		 * Creates a new <code>ClassBuilder</code> instance.
		 * @param abcFile An optional <code>AbcFile</code> that will be used to generate classes
		 * and interfaces in, when null a new <code>AbcFile</code> instance will be created in
		 * the <code>build()</code> method.
		 */
		public function ClassBuilder() {
			super();
			initClassBuilder();
		}

		as3commons_bytecode function setInstanceInfo(instanceInfo:InstanceInfo):void {
			Assert.notNull(instanceInfo, "instanceInfo argument must not be null");
			this.instanceInfo = instanceInfo;
			_superClassName = QualifiedName(instanceInfo.superclassMultiname).fullName;
			for each (var mn:Multiname in instanceInfo.interfaceMultinames) {
				_implementedInterfaceNames[_implementedInterfaceNames.length] = QualifiedName(mn).fullName;
			}
			_isFinal = this.instanceInfo.isFinal;
			_isDynamic = !this.instanceInfo.isSealed;
		}

		/**
		 * Initializes the current <code>ClassBuilder</code>.
		 */
		protected function initClassBuilder():void {
			_eventDispatcher = new EventDispatcher();
			_propertyBuilders = [];
			_implementedInterfaceNames = [];
			_superClassName = BuiltIns.OBJECT.fullName;
		}

		/**
		 * @inheritDoc
		 */
		public function get superClassName():String {
			return _superClassName;
		}

		/**
		 * @private
		 */
		public function set superClassName(value:String):void {
			if (value != null) {
				_superClassName = value;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get isDynamic():Boolean {
			return _isDynamic;
		}

		/**
		 * @private
		 */
		public function set isDynamic(value:Boolean):void {
			_isDynamic = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get isFinal():Boolean {
			return _isFinal;
		}

		/**
		 * @private
		 */
		public function set isFinal(value:Boolean):void {
			_isFinal = value;
		}

		/**
		 * @inheritDoc
		 */
		public function implementInterface(name:String):void {
			if (_implementedInterfaceNames.indexOf(name) < 0) {
				_implementedInterfaceNames[_implementedInterfaceNames.length] = name;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function implementInterfaces(names:Array):void {
			for each (var name:String in names) {
				implementInterface(name);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function defineConstructor():ICtorBuilder {
			if (_ctorBuilder == null) {
				_ctorBuilder = new CtorBuilder();
				_ctorBuilder.packageName = packageName;
				if (instanceInfo != null) {
					_ctorBuilder.as3commons_bytecode::setMethodInfo(instanceInfo.instanceInitializer);
				}
			}
			return _ctorBuilder;
		}

		/**
		 * @inheritDoc
		 */
		public function defineProperty(name:String = null, type:String = null, initialValue:* = undefined):IPropertyBuilder {
			var vb:PropertyBuilder = new PropertyBuilder();
			vb.packageName = packageName;
			vb.name = name;
			vb.type = type;
			vb.initialValue = initialValue;
			var trait:SlotOrConstantTrait;
			if (instanceInfo != null) {
				trait = instanceInfo.getSlotTraitByName(name);
				if (trait != null) {
					vb.as3commons_bytecode::setTrait(trait);
				} else if (classInfo != null) {
					trait = classInfo.getSlotTraitByName(name);
					if (trait != null) {
						vb.as3commons_bytecode::setTrait(trait);
					}
				}
			}
			_propertyBuilders[_propertyBuilders.length] = vb;
			return vb;
		}

		override protected function createDefaultConstructor():ICtorBuilder {
			var ctorBuilder:ICtorBuilder = defineConstructor();
			ctorBuilder.addOpcode(Opcode.getlocal_0) //
				.addOpcode(Opcode.pushscope) //
				.addOpcode(Opcode.getlocal_0) //
				.addOpcode(Opcode.constructsuper, [0]) //
				.addOpcode(Opcode.returnvoid);
			return ctorBuilder;
		}

		protected function calculateHierarchDepth(superClassName:String, applicationDomain:ApplicationDomain):uint {
			var extendedClasses:Array = [];
			if (applicationDomain.hasDefinition(superClassName)) {
				var type:Type = Type.forName(superClassName, applicationDomain);
				extendedClasses = type.extendsClasses;
			} else {
				var evt:ExtendedClassesNotFoundError = new ExtendedClassesNotFoundError(superClassName, applicationDomain);
				dispatchEvent(evt);
				extendedClasses = evt.extendedClasses;
			}
			return (3 + extendedClasses.length);
		}

		/**
		 * @inheritDoc
		 */
		override public function build(applicationDomain:ApplicationDomain):Array {
			var hierarchyDepth:uint = calculateHierarchDepth(superClassName, applicationDomain);
			var methods:Array = createMethods(metadata, (hierarchyDepth + 1));
			var slotTraits:Array = createSlots();
			methods = methods.concat(createAccessors(slotTraits));
			classInfo = createClassInfo(slotTraits, methods, hierarchyDepth++);
			instanceInfo = createInstanceInfo(slotTraits, methods, hierarchyDepth);
			classInfo.classMultiname = instanceInfo.classMultiname;
			instanceInfo.classInfo = classInfo;
			var metadata:Array = buildMetadata();

			for each (var st:SlotOrConstantTrait in slotTraits) {
				if (st.isStatic) {
					classInfo.addTrait(st);
				} else {
					instanceInfo.addTrait(st);
				}
			}
			return [classInfo, instanceInfo, methods, metadata];
		}

		protected function createSlots():Array {
			var result:Array = [];
			for each (var vb:IPropertyBuilder in _propertyBuilders) {
				result[result.length] = vb.build();
			}
			return result;
		}

		protected function createInstanceInfo(slots:Array, methods:Array, initScopeDepth:uint):InstanceInfo {
			var instanceInfo:InstanceInfo = (instanceInfo != null) ? instanceInfo : new InstanceInfo();
			for each (var mi:MethodInfo in methods) {
				if (MethodTrait(mi.as3commonsByteCodeAssignedMethodTrait).isStatic == false) {
					instanceInfo.addTrait(mi.as3commonsByteCodeAssignedMethodTrait);
					if (mi.as3commonsByteCodeAssignedMethodTrait.traitMultiname.nameSpace.name === NamespaceKind.PROTECTED_NAMESPACE.description) {
						instanceInfo.isProtected = true;
					}
				}
			}
			if (!instanceInfo.isProtected) {
				for each (var slot:SlotOrConstantTrait in slots) {
					if (slot.traitMultiname.nameSpace.name === NamespaceKind.PROTECTED_NAMESPACE.description) {
						instanceInfo.isProtected = true;
						break;
					}
				}
			}
			instanceInfo.isFinal = isFinal;
			instanceInfo.isInterface = false;
			instanceInfo.isSealed = !isDynamic;
			instanceInfo.classMultiname = MultinameUtil.toQualifiedName(packageName + MultinameUtil.DOUBLE_COLON + name);
			instanceInfo.superclassMultiname = MultinameUtil.toQualifiedName((StringUtils.hasText(_superClassName)) ? _superClassName : BuiltIns.OBJECT.fullName);
			if ((instanceInfo.isProtected) && (instanceInfo.protectedNamespace == null)) {
				instanceInfo.protectedNamespace = MultinameUtil.toLNamespace(packageName + MultinameUtil.DOUBLE_COLON + name, NamespaceKind.PROTECTED_NAMESPACE);
			}
			if (_ctorBuilder == null) {
				_ctorBuilder = createDefaultConstructor();
			}
			instanceInfo.instanceInitializer = _ctorBuilder.build();
			instanceInfo.instanceInitializer.methodBody.initScopeDepth = initScopeDepth++;
			instanceInfo.instanceInitializer.methodBody.maxScopeDepth = initScopeDepth;
			instanceInfo.instanceInitializer.methodName = StringUtils.substitute(CONSTRUCTOR_NAME, packageName, name);
			for each (var interfaceName:String in _implementedInterfaceNames) {
				instanceInfo.interfaceMultinames[instanceInfo.interfaceMultinames.length] = MultinameUtil.toMultiName(interfaceName);
			}
			return instanceInfo;
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


	}
}