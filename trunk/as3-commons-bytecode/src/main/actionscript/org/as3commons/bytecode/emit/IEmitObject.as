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
package org.as3commons.bytecode.emit {
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.emit.enum.MemberVisibility;

	public interface IEmitObject {
		function get packageName():String;
		function set packageName(value:String):void;
		function get name():String;
		function set name(value:String):void;
		function get visibility():MemberVisibility;
		function set visibility(value:MemberVisibility):void;
		function get namespace():String;
		function set namespace(value:String):void;
		function get traits():Array;
		function set traits(value:Array):void;
	}
}