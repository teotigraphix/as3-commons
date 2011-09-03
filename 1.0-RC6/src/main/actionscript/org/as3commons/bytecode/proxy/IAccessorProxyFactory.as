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
	import org.as3commons.bytecode.proxy.impl.MemberInfo;
	import org.as3commons.bytecode.reflect.ByteCodeType;

	/**
	 * Describes an object that is capable of generating a proxy accessor on a proxy class
	 * based on the existing accessor of a proxied class.
	 * @author Roland Zwaga
	 */
	public interface IAccessorProxyFactory extends IEventDispatcher {

		/**
		 *
		 * @param classBuilder The <code>IClassBuilder</code> used to generate the proxy class.
		 * @param type The <code>ByteCodeType</code> instance that describes the proxied class.
		 * @param memberInfo The <code>MemberInfo</code> instance that describes the proxied accessor.
		 * @param multiName
		 * @param bytecodeQname
		 * @param failOnFinal Determines whether the <code>proxyAccessor()</code> needs to throw an error when an accessor marked as final is being proxied.
		 * @param isInterfaceAccessor Determines whether the specified accessor belongs to an introduced interface.
		 */
		function proxyAccessor(classBuilder:IClassBuilder, type:ByteCodeType, memberInfo:MemberInfo, multiName:Multiname, bytecodeQname:QualifiedName, failOnFinal:Boolean=true):void;

	}
}
