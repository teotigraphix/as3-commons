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
package org.as3commons.bytecode.io {
	import flash.utils.ByteArray;

	import org.as3commons.bytecode.abc.AbcFile;
	import org.as3commons.bytecode.abc.IConstantPool;

	public interface IAbcDeserializer {
		function get methodBodyExtractionMethod():MethodBodyExtractionKind;

		function set methodBodyExtractionMethod(value:MethodBodyExtractionKind):void;

		function get constantPoolEndPosition():uint;

		function deserializeConstantPool(pool:IConstantPool):IConstantPool;

		function deserialize(positionInByteArrayToReadFrom:int = 0):AbcFile;

		function deserializeClassInfos(abcFile:AbcFile, pool:IConstantPool, classCount:int):void;

		function deserializeMethodBodies(abcFile:AbcFile, pool:IConstantPool):void;

		function deserializeScriptInfos(abcFile:AbcFile):void;

		function deserializeInstanceInfo(abcFile:AbcFile, pool:IConstantPool):int;

		function deserializeMetadata(abcFile:AbcFile, pool:IConstantPool):void;

		function deserializeMethodInfos(abcFile:AbcFile, pool:IConstantPool):void;

		function deserializeTraitsInfo(abcFile:AbcFile, byteStream:ByteArray, isStatic:Boolean = false):Array;
	}
}