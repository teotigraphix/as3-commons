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
	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.RuntimeQualifiedName;
	import org.as3commons.bytecode.abc.enum.MultinameKind;
	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.bytecode.emit.IMethodBuilder;
	import org.as3commons.bytecode.emit.enum.MemberVisibility;
	import org.as3commons.bytecode.util.MultinameUtil;
	import org.as3commons.lang.Assert;

	public class AbstractMethodBodyFactory extends AbstractProxyFactory {

		protected var namespaceQualifiedName:QualifiedName = new QualifiedName("Namespace", LNamespace.PUBLIC, MultinameKind.QNAME);
		protected var arrayQualifiedName:QualifiedName = new QualifiedName("Array", LNamespace.PUBLIC, MultinameKind.QNAME);
		protected var invocationKindQualifiedName:QualifiedName = new QualifiedName("InvocationKind", new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, "org.as3commons.bytecode.interception.impl"), MultinameKind.QNAME);
		protected var interceptorQName:QualifiedName = new QualifiedName("methodInvocationInterceptor", LNamespace.PUBLIC);
		protected var interceptorRTQName:RuntimeQualifiedName = new RuntimeQualifiedName("methodInvocationInterceptor", MultinameKind.RTQNAME);
		protected var interceptQName:QualifiedName = new QualifiedName("intercept", new LNamespace(NamespaceKind.NAMESPACE, "org.as3commons.bytecode.interception:IMethodInvocationInterceptor"));
		protected var proxyEventQName:QualifiedName = new QualifiedName("ProxyCreationEvent", new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, "org.as3commons.bytecode.proxy.event"));
		protected var proxyEventTypeQName:QualifiedName = new QualifiedName("PROXY_CREATED", LNamespace.PUBLIC);
		protected var proxyFactoryQName:QualifiedName = new QualifiedName("ProxyFactory", new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, "org.as3commons.bytecode.proxy.impl"));
		protected var dispatchEventQName:QualifiedName = new QualifiedName("dispatchEvent", new LNamespace(NamespaceKind.NAMESPACE, "flash.events:IEventDispatcher"));
		protected var proxyCreationDispatcherQName:QualifiedName = new QualifiedName("proxyCreationDispatcher", LNamespace.PUBLIC);
		protected var ConstructorKindQName:QualifiedName = new QualifiedName("CONSTRUCTOR", LNamespace.PUBLIC);
		protected var MethodKindQName:QualifiedName = new QualifiedName("METHOD", LNamespace.PUBLIC);
		protected var GetterKindQName:QualifiedName = new QualifiedName("GETTER", LNamespace.PUBLIC);
		protected var SetterKindQName:QualifiedName = new QualifiedName("SETTER", LNamespace.PUBLIC);
		protected var qnameQname:QualifiedName = new QualifiedName("QName", LNamespace.PUBLIC);
		protected var concatQName:QualifiedName = new QualifiedName("concat", LNamespace.BUILTIN);

		public function AbstractMethodBodyFactory() {
			super();
		}

		/**
		 * Creates a <code>QualifiedName</code> instance for the specified <code>IMethodBuilder</code> to be used
		 * a the parameter for the <code>Opcode.getsuper</code> opcode.
		 * @param methodBuilder The specified <code>IMethodBuilder</code>.
		 * @return The new <code>QualifiedName</code> instance.
		 */
		protected function createMethodQName(methodBuilder:IMethodBuilder):QualifiedName {
			var ns:LNamespace;
			switch (methodBuilder.visibility) {
				case MemberVisibility.PUBLIC:
					ns = LNamespace.PUBLIC;
					break;
				case MemberVisibility.PROTECTED:
					ns = MultinameUtil.toLNamespace(removeProxyPackage(methodBuilder.packageName), NamespaceKind.PROTECTED_NAMESPACE);
					break;
				case MemberVisibility.NAMESPACE:
					ns = new LNamespace(NamespaceKind.NAMESPACE, methodBuilder.namespaceURI);
					break;
			}
			return new QualifiedName(methodBuilder.name, ns);
		}

		protected function removeProxyPackage(packageName:String):String {
			CONFIG::debug {
				Assert.hasText(packageName, "packageName argument must not be empty or null");
			}
			var parts:Array = packageName.split(MultinameUtil.PERIOD);
			parts.splice(parts.length - 2, 1)
			var newPackage:String = parts.join(MultinameUtil.PERIOD);
			return newPackage;
		}
	}
}
