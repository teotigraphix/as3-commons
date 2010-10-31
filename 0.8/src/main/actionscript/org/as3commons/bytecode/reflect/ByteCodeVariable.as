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
	import org.as3commons.reflect.Variable;
	import org.as3commons.reflect.as3commons_reflect;

	public class ByteCodeVariable extends Variable implements IVisibleMember {

		public function ByteCodeVariable(name:String, type:String, declaringType:String, isStatic:Boolean, applicationDomain:ApplicationDomain) {
			super(name, type, declaringType, isStatic, applicationDomain);
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
		// initializedValue
		// ----------------------------

		private var _initializedValue:* = null;

		public function get initializedValue():* {
			return _initializedValue;
		}

		// ----------------------------
		// visibility
		// ----------------------------

		private var _visibility:NamespaceKind = NamespaceKind.PACKAGE_NAMESPACE;

		public function get visibility():NamespaceKind {
			return _visibility;
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

		as3commons_reflect function setInitializedValue(value:*):void {
			_initializedValue = value;
		}

	}
}