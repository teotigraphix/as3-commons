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
	import org.as3commons.bytecode.abc.ConstantPool;
	import org.as3commons.bytecode.abc.Label;
	import org.as3commons.bytecode.abc.MethodBody;
	import org.as3commons.bytecode.abc.Op;
	import org.as3commons.bytecode.abc.enum.Opcode;

	/**
	 * Describes an object that can generate a <code>MethodBody</code> to be used in an <code>AbcFile</code>.
	 * @author Roland Zwaga
	 */
	public interface IMethodBodyBuilder {
		/**
		 * An <code>Array</code> of <code>Op</code> instances that represent the programming logic inside the method.
		 */
		function get opcodes():Array;
		/**
		 * @private
		 */
		function set opcodes(value:Array):void;
		/**
		 * An <code>Array</code> of <code>IExceptionInfoBuilders</code> that are able to generate the necessary <code>ExceptionInfo</code> instances references in the method body.
		 */
		function get exceptionInfos():Array;
		/**
		 * @private
		 */
		function set exceptionInfos(value:Array):void;
		/**
		 * Adds an extra <code>Op</code> instance with the specified <code>Opcode</code> and parameters.
		 * @param opcode The specified <code>Op</code>.
		 * @param params An array of parameters requried by the specified <code>Opcode</code>.
		 * @return the current <code>IMethodBodyBuilder</code> to enable chaining of <code>addOpcode()</code> and <code>addOp</code>  invocations.
		 */
		function addOpcode(opcode:Opcode, params:Array = null):IMethodBodyBuilder;
		/**
		 * Adds the specified <code>Op</code> instance.
		 * @param opcode The specified <code>Op</code>.
		 * @return the current <code>IMethodBodyBuilder</code> to enable chaining of <code>addOpcode()</code> and <code>addOp</code> invocations.
		 */
		function addOp(opcode:Op):IMethodBodyBuilder;
		/**
		 * Defines a jump between the <code>triggerOpcode</code> and <code>targetOpcode</code>, for example, an <code>iffalse</code> opcode
		 * can trigger a jump to an opcode further down the chain of command if it resolves to true.
		 * <p>The <code>targetOpcode</code> will be added to the opcodes list if it hasn't been already.</p>
		 * @return The current <code>IMethodBodyBuilder</code> to enable chaining.
		 */
		function defineJump(triggerOpcode:Op, targetOpcode:Op):IMethodBodyBuilder;
		/**
		 * Adds an <code>Array</code> of <code>Op</code> instances.
		 * @param newOpcodes The specified <code>Array</code> of <code>Op</code> instances.
		 * @return the current <code>IMethodBodyBuilder</code> to enable chaining of <code>addOpcodes()</code> invocations.
		 */
		function addOpcodes(newOpcodes:Array):IMethodBodyBuilder;
		/**
		 * Creates and returns a new <code>IExceptionInfoBuilder</code> instance.
		 * @return The specified <code>IExceptionInfoBuilder</code> instance.
		 */
		function defineExceptionInfo():IExceptionInfoBuilder;
		/**
		 * Internally used build method, this method should never be called by third parties.
		 * @param applicationDomain
		 * @return
		 */
		function buildBody(initScopeDepth:uint = 1, extraLocalCount:uint = 0):MethodBody;
	}
}