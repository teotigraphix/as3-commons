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

	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.SlotOrConstantTrait;
	import org.as3commons.bytecode.abc.TraitInfo;
	import org.as3commons.bytecode.abc.enum.ConstantKind;
	import org.as3commons.bytecode.abc.enum.TraitKind;
	import org.as3commons.bytecode.as3commons_bytecode;
	import org.as3commons.bytecode.emit.IPropertyBuilder;
	import org.as3commons.bytecode.typeinfo.Metadata;
	import org.as3commons.bytecode.util.EmitUtil;
	import org.as3commons.bytecode.util.MultinameUtil;
	import org.as3commons.lang.Assert;

	public class PropertyBuilder extends EmitMember implements IPropertyBuilder {

		private var _eventDispatcher:IEventDispatcher;

		private var _trait:SlotOrConstantTrait;

		public function PropertyBuilder() {
			super();
			_eventDispatcher = new EventDispatcher();
		}

		private var _type:String;

		private var _initialValue:*;

		private var _isConstant:Boolean;

		private var _memberInitialization:MemberInitialization;

		public function get type():String {
			return _type;
		}

		public function set type(value:String):void {
			_type = value;
		}

		public function build():Object {
			return buildTrait();
		}

		public function get initialValue():* {
			return _initialValue;
		}

		public function set initialValue(value:*):void {
			_initialValue = value;
		}

		public function get isConstant():Boolean {
			return _isConstant;
		}

		public function set isConstant(value:Boolean):void {
			_isConstant = value;
		}

		as3commons_bytecode function setTrait(trait:SlotOrConstantTrait):void {
			Assert.notNull(trait, "trait argument must not be null");
			_trait = trait;
			isFinal = trait.isFinal;
			isOverride = trait.isOverride;
			isStatic = trait.isStatic;
			isConstant = (trait.traitKind == TraitKind.CONST);
			_type = QualifiedName(trait.typeMultiname).fullName;
			visibility = EmitUtil.getMemberVisibilityFromQualifiedName(trait.traitMultiname);
			for each (var metadata:Metadata in trait.metadata) {
				var mdb:MetadataBuilder = defineMetadata() as MetadataBuilder;
				mdb.as3commons_bytecode::setMetadata(metadata);
			}
		}

		override protected function buildTrait():TraitInfo {
			var trait:SlotOrConstantTrait = (_trait != null) ? _trait : new SlotOrConstantTrait();
			trait.addMetadataList(buildMetadata());
			trait.isFinal = isFinal;
			trait.isOverride = isOverride;
			trait.traitKind = (isConstant) ? TraitKind.CONST : TraitKind.SLOT;
			trait.isStatic = isStatic;
			trait.typeMultiname = MultinameUtil.toQualifiedName(_type);
			var ns:LNamespace = createTraitNamespace();
			trait.traitMultiname = new QualifiedName(name, ns);
			if (_initialValue === undefined) {
				trait.vindex = 0;
			} else {
				trait.vkind = ConstantKind.determineKindFromInstance(_initialValue);
				trait.defaultValue = _initialValue;
			}
			return trait;
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

		public function get memberInitialization():MemberInitialization {
			return _memberInitialization;
		}

		public function set memberInitialization(value:MemberInitialization):void {
			_memberInitialization = value;
		}

	}
}