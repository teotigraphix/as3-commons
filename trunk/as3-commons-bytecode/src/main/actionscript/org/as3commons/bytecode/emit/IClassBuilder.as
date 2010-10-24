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
	import flash.system.ApplicationDomain;

	public interface IClassBuilder extends IEmitObject {
		function get superClassName():String;

		function set superClassName(value:String):void;

		function get isDynamic():Boolean;

		function set isDynamic(value:Boolean):void;

		function get isFinal():Boolean;

		function set isFinal(value:Boolean):void;

		function get isProtected():Boolean;

		function set isProtected(value:Boolean):void;

		function implementInterface(name:String):void;

		function defineConstructor():ICtorBuilder;

		function defineMethod(name:String = null):IMethodBuilder;

		function defineAccessor():IAccessorBuilder;

		function defineVariable(name:String = null, type:String = null, initialValue:* = undefined):IVariableBuilder;

		function build(applicationDomain:ApplicationDomain):Array;
	}
}