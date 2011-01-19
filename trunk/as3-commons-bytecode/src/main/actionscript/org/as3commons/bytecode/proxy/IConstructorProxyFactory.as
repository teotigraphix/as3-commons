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
package org.as3commons.bytecode.proxy {
	import flash.events.IEventDispatcher;

	import org.as3commons.bytecode.abc.Multiname;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.emit.IClassBuilder;
	import org.as3commons.bytecode.emit.ICtorBuilder;
	import org.as3commons.bytecode.reflect.ByteCodeType;

	/**
	 * @inheritDoc
	 */
	[Event(name="beforeConstructorBodyBuild", type="org.as3commons.bytecode.proxy.event.ProxyFactoryBuildEvent")]
	/**
	 * @inheritDoc
	 */
	[Event(name="afterConstructorBodyBuild", type="org.as3commons.bytecode.proxy.event.ProxyFactoryBuildEvent")]
	/**
	 *
	 * @author Roland Zwaga
	 */
	public interface IConstructorProxyFactory extends IEventDispatcher {

		function addConstructor(classBuilder:IClassBuilder, type:ByteCodeType, classProxyInfo:IClassProxyInfo):ICtorBuilder;

		function addConstructorBody(ctorBuilder:ICtorBuilder, bytecodeQname:QualifiedName, multiName:Multiname):void;

	}
}