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

	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import org.as3commons.bytecode.abc.enum.ConstantKind;

	/**
	 *
	 * @author rolandzwaga
	 */
	public class SimpleConstantPool implements IConstantPool {

		private var _dupeCheck:Boolean;
		private var _integerPool:Array;
		private var _uintPool:Array;
		private var _doublePool:Array;
		private var _classInfo:Array;
		private var _stringPool:Array;
		private var _namespacePool:Array;
		private var _namespaceSetPool:Array;
		private var _multinamePool:Vector.<BaseMultiname>;
		private var _lookup:Object;

		/**
		 * Creates a new <code>SimpleConstantPool</code> instance.
		 */
		public function SimpleConstantPool() {
			super();
			reset();
		}

		public function get rawConstantPool():ByteArray {
			return null;
		}

		public function set rawConstantPool(value:ByteArray):void {
		}

		public function reset():void {
			_integerPool = [0];
			_uintPool = [0];
			_doublePool = [0];
			_classInfo = [];
			_stringPool = [LNamespace.ASTERISK.name];

			_namespacePool = [];
			addNamespace(LNamespace.ASTERISK);

			_namespaceSetPool = [];
			addNamespaceSet(new NamespaceSet([LNamespace.ASTERISK]));

			_multinamePool = new Vector.<BaseMultiname>();
			addMultiname(new QualifiedName(LNamespace.ASTERISK.name, LNamespace.ASTERISK));

			_lookup = new Dictionary();
			_lookup[ConstantKind.INT] = [_integerPool, null];
			_lookup[ConstantKind.UINT] = [_uintPool, null];
			_lookup[ConstantKind.DOUBLE] = [_doublePool, null];
			_lookup[ConstantKind.UTF8] = [_stringPool, null];
			_lookup[ConstantKind.NAMESPACE] = [_namespacePool, null];
			_lookup[ConstantKind.PACKAGE_NAMESPACE] = [_namespacePool, null];
			_lookup[ConstantKind.PACKAGE_INTERNAL_NAMESPACE] = [_namespacePool, null];
			_lookup[ConstantKind.PROTECTED_NAMESPACE] = [_namespacePool, null];
			_lookup[ConstantKind.EXPLICIT_NAMESPACE] = [_namespacePool, null];
			_lookup[ConstantKind.STATIC_PROTECTED_NAMESPACE] = [_namespacePool, null];
			_lookup[ConstantKind.PRIVATE_NAMESPACE] = [_namespacePool, null];
			_lookup[ConstantKind.TRUE] = true;
			_lookup[ConstantKind.FALSE] = false;
			_lookup[ConstantKind.NULL] = null;
			_lookup[ConstantKind.UNDEFINED] = undefined;
		}

		public function initializeLookups():void {
		}

		public function getConstantPoolItem(constantKindValue:uint, poolIndex:uint):* {
			const constantKind:ConstantKind = ConstantKind.determineKind(constantKindValue);
			const retVal:* = _lookup[constantKind];
			return (retVal is Array) ? retVal[0][poolIndex] : retVal;
		}

		public function getConstantPoolItemIndex(constantKindValue:ConstantKind, item:*):int {
			return 0;
		}

		public function addItemToPool(constantKindValue:ConstantKind, item:*):int {
			return 0;
		}

		public function get dupeCheck():Boolean {
			return _dupeCheck;
		}

		public function set dupeCheck(value:Boolean):void {
			_dupeCheck = value;
		}

		public function get integerPool():Array {
			return _integerPool;
		}

		public function get uintPool():Array {
			return _uintPool;
		}

		public function get doublePool():Array {
			return _doublePool;
		}

		public function get stringPool():Array {
			return _stringPool;
		}

		public function get namespacePool():Array {
			return _namespacePool;
		}

		public function get namespaceSetPool():Array {
			return _namespaceSetPool;
		}

		public function get multinamePool():Vector.<BaseMultiname> {
			return _multinamePool;
		}

		public function get classInfo():Array {
			return _classInfo;
		}

		public function get locked():Boolean {
			return false;
		}

		public function set locked(value:Boolean):void {
		}

		public function addMultiname(multiname:BaseMultiname):int {
			return _multinamePool.push(multiname) - 1;
		}

		public function getStringPosition(string:String):int {
			return 0;
		}

		public function getIntPosition(intValue:int):int {
			return 0;
		}

		public function getUintPosition(uintValue:uint):int {
			return 0;
		}

		public function getDoublePosition(doubleValue:Number):int {
			return 0;
		}

		public function getNamespacePosition(namespaze:LNamespace):int {
			return 0;
		}

		public function getNamespaceSetPosition(namespaceSet:NamespaceSet):int {
			return 0;
		}

		public function getMultinamePosition(multiname:BaseMultiname):int {
			return 0;
		}

		public function getMultinamePositionByName(multinameName:String):int {
			return 0;
		}

		public function addString(string:String):int {
			return _stringPool.push(string) - 1;
		}

		public function addInt(integer:int):int {
			return _integerPool.push(integer) - 1;
		}

		public function addUint(uinteger:uint):int {
			return _uintPool.push(uinteger) - 1;
		}

		public function addDouble(double:Number):int {
			return _doublePool.push(double) - 1;
		}

		public function addNamespace(namespaceValue:LNamespace):int {
			return _namespacePool.push(namespaceValue) - 1;
		}

		public function addNamespaceSet(namespaceSet:NamespaceSet):int {
			return _namespaceSetPool.push(namespaceSet) - 1;
		}

		public function addToPool(pool:Array, lookup:*, item:Object):int {
			return 0;
		}
	}
}
