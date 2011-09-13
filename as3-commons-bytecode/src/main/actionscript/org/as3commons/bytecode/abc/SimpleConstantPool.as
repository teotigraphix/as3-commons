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

	import org.as3commons.bytecode.abc.enum.ConstantKind;

	/**
	 *
	 * @author rolandzwaga
	 */
	public class SimpleConstantPool implements IConstantPool {

		private static const ZERO_VALUE:String = "zero";

		private var _dupeCheck:Boolean;
		private var _integerPool:Array;
		private var _uintPool:Array;
		private var _doublePool:Array;
		private var _classInfo:Array;
		private var _stringPool:Array;
		private var _namespacePool:Array;
		private var _namespaceSetPool:Array;
		private var _multinamePool:Array;

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
			_integerPool = [ZERO_VALUE];
			_uintPool = [ZERO_VALUE];
			_doublePool = [NaN];
			_classInfo = [];
			_stringPool = [LNamespace.ASTERISK.name];

			_namespacePool = [];
			addNamespace(LNamespace.ASTERISK);

			_namespaceSetPool = [];
			addNamespaceSet(new NamespaceSet([LNamespace.ASTERISK]));

			_multinamePool = [];
			addMultiname(new QualifiedName(LNamespace.ASTERISK.name, LNamespace.ASTERISK));
		}

		public function initializeLookups():void {
		}

		public function getConstantPoolItem(constantKindValue:uint, poolIndex:uint):* {
			return null;
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

		public function get multinamePool():Array {
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
