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
	import org.as3commons.bytecode.abc.MethodInfo;
	import org.as3commons.bytecode.emit.impl.MethodArgument;

	/**
	 * Describes an object that can generate a <code>MethodInfo</code> instance to be used in an <code>AbcFile</code>.
	 * @author Roland Zwaga
	 */
	public interface IMethodBuilder extends IEmitMember, IMethodBodyBuilder {
		/**
		 * The fully qualified type of the return value of the generated <code>MethodBody</code>. I.e. <code>flash.utils.Dictionary</code>.
		 */
		function get returnType():String;
		/**
		 * @private
		 */
		function set returnType(value:String):void;
		/**
		 * An <code>Array</code> of <code>MethodArguments</code>.
		 */
		function get arguments():Array;
		/**
		 * @private
		 */
		function set arguments(value:Array):void;
		/**
		 * If <code>true</code> the generated method will support rest arguments (...rest).
		 */
		function get hasRestArguments():Boolean;
		/**
		 * @private
		 */
		function set hasRestArguments(value:Boolean):void;
		/*
		 * Creates and returns an <code>IMethodBodyBuilder</code> for the generated method.
		 * @return The specified <code>IMethodBodyBuilder</code>.
		 */
		//function defineMethodBody():IMethodBodyBuilder;
		/**
		 * Creates and returns a new <code>MethodArgument</code> for the current method.
		 * @param type The fully qualified type for the argument. I.e. <code>flash.events.Event</code>
		 * @param defaultValue The default value for the argument when the <code>isOptional</code> property is set to <code>true</code>.
		 * @return The specified <code>MethodArgument</code>.
		 */
		function defineArgument(type:String = "", isOptional:Boolean = false, defaultValue:Object = null):MethodArgument;
		/**
		 * Internally used build method, this method should never be called by third parties.
		 * @param applicationDomain
		 * @return
		 */
		function build(initScopeDepth:uint = 1):MethodInfo;
	}
}