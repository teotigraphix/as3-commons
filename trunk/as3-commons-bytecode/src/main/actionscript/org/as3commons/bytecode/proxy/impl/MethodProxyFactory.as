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
package org.as3commons.bytecode.proxy.impl {
	import org.as3commons.bytecode.emit.IClassBuilder;
	import org.as3commons.bytecode.emit.IMethodBuilder;
	import org.as3commons.bytecode.emit.enum.MemberVisibility;
	import org.as3commons.bytecode.proxy.error.ProxyBuildError;
	import org.as3commons.bytecode.reflect.ByteCodeMethod;
	import org.as3commons.bytecode.reflect.ByteCodeParameter;
	import org.as3commons.bytecode.reflect.ByteCodeType;
	import org.as3commons.lang.Assert;

	public class MethodProxyFactory extends AbstractProxyFactory {

		public function MethodProxyFactory() {
			super();
		}

		/**
		 * Creates an overridden method on the specified <code>IClassBuilder</code> instance. Which method is determined by the specified <code>MemberInfo</code>
		 * instance.
		 * @param classBuilder The specified <code>IClassBuilder</code> instance.
		 * @param type The specified <code>ByteCodeType</code> instance.
		 * @param memberInfo The specified <code>MemberInfo</code> instance.
		 * @return The <code>IMethodBuilder</code> representing the generated method.
		 * @throws org.as3commons.bytecode.proxy.error.ProxyError When the proxied method is marked as final.
		 */
		public function proxyMethod(classBuilder:IClassBuilder, type:ByteCodeType, memberInfo:MemberInfo, failOnFinal:Boolean = true):IMethodBuilder {
			Assert.notNull(classBuilder, "classBuilder argument must not be null");
			Assert.notNull(type, "type argument must not be null");
			Assert.notNull(memberInfo, "memberInfo argument must not be null");
			var methodBuilder:IMethodBuilder = classBuilder.defineMethod(memberInfo.qName.localName, memberInfo.qName.uri);
			methodBuilder.isOverride = (!type.isInterface);
			var method:ByteCodeMethod = type.getMethod(memberInfo.qName.localName, memberInfo.qName.uri) as ByteCodeMethod;
			if (method == null) {
				throw new ProxyBuildError(ProxyBuildError.METHOD_NOT_EXISTS, classBuilder.name, memberInfo.qName.localName);
			}
			if ((method.isFinal) && (failOnFinal)) {
				throw new ProxyBuildError(ProxyBuildError.FINAL_METHOD_ERROR, method.name);
			}
			addMetadata(methodBuilder, method.metaData);
			methodBuilder.visibility = (!type.isInterface) ? ProxyFactory.getMemberVisibility(method) : MemberVisibility.PUBLIC;
			methodBuilder.namespaceURI = method.namespaceURI;
			methodBuilder.scopeName = method.scopeName;
			methodBuilder.returnType = method.returnType.fullName;
			methodBuilder.hasRestArguments = method.hasRestArguments;
			for each (var arg:ByteCodeParameter in method.parameters) {
				methodBuilder.defineArgument(arg.type.fullName, arg.isOptional, arg.defaultValue);
			}
			return methodBuilder;
		}

	}
}