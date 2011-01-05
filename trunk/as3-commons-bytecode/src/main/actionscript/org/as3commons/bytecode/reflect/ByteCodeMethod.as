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
package org.as3commons.bytecode.reflect {
	import flash.system.ApplicationDomain;

	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.lang.HashArray;
	import org.as3commons.reflect.Method;
	import org.as3commons.reflect.as3commons_reflect;

	public class ByteCodeMethod extends Method implements IVisibleMember {

		private var _maxStack:uint;
		private var _localCount:uint;
		private var _initScopeDepth:uint;
		private var _maxScopeDepth:uint;
		private var _bodyLength:uint;
		private var _bodyStartPosition:uint;

		public function ByteCodeMethod(declaringType:String, name:String, isStatic:Boolean, parameters:Array, returnType:String, applicationDomain:ApplicationDomain, metaData:HashArray = null) {
			super(declaringType, name, isStatic, parameters, returnType, applicationDomain, metaData);
		}

		private var _visibility:NamespaceKind = NamespaceKind.PACKAGE_NAMESPACE;

		public function get maxStack():uint {
			return _maxStack;
		}

		public function get localCount():uint {
			return _localCount;
		}

		public function get initScopeDepth():uint {
			return _initScopeDepth;
		}

		public function get maxScopeDepth():uint {
			return _maxScopeDepth;
		}

		public function get bodyLength():uint {
			return _bodyLength;
		}

		public function get bodyStartPosition():uint {
			return _bodyStartPosition;
		}

		public function get visibility():NamespaceKind {
			return _visibility;
		}

		// ----------------------------
		// isOverride
		// ----------------------------

		private var _isOverride:Boolean = false;

		public function get isOverride():Boolean {
			return _isOverride;
		}

		// ----------------------------
		// isFinal
		// ----------------------------

		private var _isFinal:Boolean = false;

		public function get isFinal():Boolean {
			return _isFinal;
		}

		// ----------------------------
		// scopeName
		// ----------------------------

		private var _scopeName:String = "";

		public function get scopeName():String {
			return _scopeName;
		}

		as3commons_reflect function setScopeName(value:String):void {
			_scopeName = value;
		}

		as3commons_reflect function setVisibility(value:NamespaceKind):void {
			_visibility = value;
		}

		as3commons_reflect function setIsFinal(value:Boolean):void {
			_isFinal = value;
		}

		as3commons_reflect function setIsOverride(value:Boolean):void {
			_isOverride = value;
		}

		as3commons_reflect function setMaxStack(value:uint):void {
			_maxStack = value;
		}

		as3commons_reflect function setLocalCount(value:uint):void {
			_localCount = value;
		}

		as3commons_reflect function setInitScopeDepth(value:uint):void {
			_initScopeDepth = value;
		}

		as3commons_reflect function setMaxScopeDepth(value:uint):void {
			_maxScopeDepth = value;
		}

		as3commons_reflect function setBodyLength(value:uint):void {
			_bodyLength = value;
		}

		as3commons_reflect function setBodyStartPosition(value:uint):void {
			_bodyStartPosition = value;
		}
	}
}