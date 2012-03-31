/*
* Copyright 2009-2010 the original author or authors.
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

	public interface IConstantPool {
		function get rawConstantPool():ByteArray;
		function set rawConstantPool(value:ByteArray):void;
		function reset():void;
		function initializeLookups():void;
		function getConstantPoolItem(constantKindValue:uint, poolIndex:uint):*;
		function getConstantPoolItemIndex(constantKindValue:ConstantKind, item:*):int;
		function addItemToPool(constantKindValue:ConstantKind, item:*):int;
		function get dupeCheck():Boolean;
		function set dupeCheck(value:Boolean):void;
		function get integerPool():Vector.<int>;
		function get uintPool():Vector.<uint>;
		function get doublePool():Vector.<Number>;
		function get stringPool():Vector.<String>;
		function get namespacePool():Vector.<LNamespace>;
		function get namespaceSetPool():Vector.<NamespaceSet>;
		function get multinamePool():Vector.<BaseMultiname>;
		function get classInfo():Vector.<ClassInfo>;
		function get locked():Boolean;
		function set locked(value:Boolean):void;
		function addMultiname(multiname:BaseMultiname):int;
		function getStringPosition(string:String):int;
		function getIntPosition(intValue:int):int;
		function getUintPosition(uintValue:uint):int;
		function getDoublePosition(doubleValue:Number):int;
		function getNamespacePosition(namespaze:LNamespace):int;
		function getNamespaceSetPosition(namespaceSet:NamespaceSet):int;
		function getMultinamePosition(multiname:BaseMultiname):int;
		function getMultinamePositionByName(multinameName:String):int;
		function addString(string:String):int;
		function addInt(integer:int):int;
		function addUint(uinteger:uint):int;
		function addDouble(double:Number):int;
		function addNamespace(namespaceValue:LNamespace):int;
		function addNamespaceSet(namespaceSet:NamespaceSet):int;
		function addToPool(pool:*, lookup:*, item:Object):int;
	}
}
