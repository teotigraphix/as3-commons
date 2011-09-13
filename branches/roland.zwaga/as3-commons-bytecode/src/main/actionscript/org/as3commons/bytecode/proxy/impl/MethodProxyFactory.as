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
	import org.as3commons.bytecode.abc.Multiname;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.enum.BuiltIns;
	import org.as3commons.bytecode.abc.enum.Opcode;
	import org.as3commons.bytecode.emit.IClassBuilder;
	import org.as3commons.bytecode.emit.IMethodBuilder;
	import org.as3commons.bytecode.emit.enum.MemberVisibility;
	import org.as3commons.bytecode.proxy.IMethodProxyFactory;
	import org.as3commons.bytecode.proxy.error.ProxyBuildError;
	import org.as3commons.bytecode.reflect.ByteCodeMethod;
	import org.as3commons.bytecode.reflect.ByteCodeParameter;
	import org.as3commons.bytecode.reflect.ByteCodeType;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.StringUtils;

	public class MethodProxyFactory extends AbstractMethodBodyFactory implements IMethodProxyFactory {

		public function MethodProxyFactory() {
			super();
		}

		/**
		 * Creates an overridden method on the specified <code>IClassBuilder</code> instance. Which method is determined by the specified <code>MemberInfo</code>
		 * instance.
		 * @param classBuilder The specified <code>IClassBuilder</code> instance.
		 * @param type The specified <code>ByteCodeType</code> instance.
		 * @param memberInfo The specified <code>MemberInfo</code> instance.
		 * @param failOnFinal When <code>true</code> an error is thrown when the.
		 * @return The <code>IMethodBuilder</code> representing the generated method.
		 * @throws org.as3commons.bytecode.proxy.error.ProxyError When the proxied method is marked as final.
		 */
		public function proxyMethod(classBuilder:IClassBuilder, type:ByteCodeType, memberInfo:MemberInfo, failOnFinal:Boolean=true):IMethodBuilder {
			CONFIG::debug {
				Assert.notNull(classBuilder, "classBuilder argument must not be null");
				Assert.notNull(type, "type argument must not be null");
				Assert.notNull(memberInfo, "memberInfo argument must not be null");
			}
			var methodBuilder:IMethodBuilder = classBuilder.defineMethod(memberInfo.qName.localName, memberInfo.qName.uri);
			methodBuilder.isOverride = !type.isInterface;
			var method:ByteCodeMethod = type.getMethod(memberInfo.qName.localName, memberInfo.qName.uri) as ByteCodeMethod;
			if (method == null) {
				throw new ProxyBuildError(ProxyBuildError.METHOD_NOT_EXISTS, classBuilder.name, memberInfo.qName.localName);
			}
			if ((method.isFinal) && (failOnFinal)) {
				throw new ProxyBuildError(ProxyBuildError.FINAL_METHOD_ERROR, method.name);
			}
			addMetadata(methodBuilder, method.metadata);
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

		/**
		 * Generates a method body that passes the method's arguments to the generated <code>methodInvocationInterceptor</code> property value's <code>intercept</code> method,
		 * along with a reference to the current instance, a <code>QName</code> for the current method, and a reference to the super method instance.
		 * <p>The actionscript would look like this:</p>
		 * <listing version="3.0">
		 * override public function returnStringWithParameters(param:String):String {
		 *  return as3commons_bytecode_proxy::methodInvocationInterceptor.intercept(this, InvocationKind.METHOD, new QName("", "returnStringWithParameters"), [param], super.returnStringWithParameters);
		 * }
		 * </listing>
		 * <p>A method without parameters will be generated like this:</p>
		 * <listing version="3.0">
		 * override public function returnString():String {
		 *  return as3commons_bytecode_proxy::methodInvocationInterceptor.intercept(this, InvocationKind.METHOD, new QName("", "returnString"), null, super.returnString);
		 * }
		 * </listing>
		 * <p>And, lastly, a method without a return value would end up looking like this:</p>
		 * <listing version="3.0">
		 * override public function voidWithParameters(param:String):void {
		 *  as3commons_bytecode_proxy::methodInvocationInterceptor.intercept(this, InvocationKind.METHOD, new QName("", "voidWithParameters"), [param], super.voidWithParameters);
		 * }
		 * </listing>
		 * @param methodBuilder The specified <code>IMethodBuilder</code> instance.
		 * @param multiName The specified <code>Multiname</code> instance.
		 * @param bytecodeQname The specified <code>QualifiedName</code> instance.
		 */
		public function addMethodBody(methodBuilder:IMethodBuilder, multiName:Multiname, bytecodeQname:QualifiedName, isInterface:Boolean):void {
			CONFIG::debug {
				Assert.notNull(methodBuilder, "methodBuilder argument must not be null");
			}
			var len:int = methodBuilder.arguments.length;
			var methodQName:QualifiedName = createMethodQName(methodBuilder);
			methodBuilder.addOpcode(Opcode.getlocal_0) //
				.addOpcode(Opcode.pushscope) //
				.addOpcode(Opcode.findpropstrict, [bytecodeQname]) //
				.addOpcode(Opcode.getproperty, [bytecodeQname]) //
				.addOpcode(Opcode.coerce, [namespaceQualifiedName]) //
				.addOpcode(Opcode.findpropstrict, [interceptorRTQName]) //
				.addOpcode(Opcode.findpropstrict, [bytecodeQname]) //
				.addOpcode(Opcode.getproperty, [bytecodeQname]) //
				.addOpcode(Opcode.coerce, [namespaceQualifiedName]) //
				.addOpcode(Opcode.getproperty, [interceptorRTQName]) //
				.addOpcode(Opcode.getlocal_0) //
				.addOpcode(Opcode.findpropstrict, [invocationKindQualifiedName]) //
				.addOpcode(Opcode.getproperty, [invocationKindQualifiedName]) //
				.addOpcode(Opcode.getproperty, [MethodKindQName]) //
				.addOpcode(Opcode.findpropstrict, [qnameQname]) //
				.addOpcode(Opcode.pushstring, [StringUtils.hasText(methodBuilder.namespaceURI) ? methodBuilder.namespaceURI : ""]) //
				.addOpcode(Opcode.pushstring, [methodBuilder.name]) //
				.addOpcode(Opcode.constructprop, [qnameQname, 2]) //
			if (len > 0) {
				for (var i:int = 0; i < len; ++i) {
					var idx:int = i + 1;
					switch (idx) {
						case 1:
							methodBuilder.addOpcode(Opcode.getlocal_1);
							break;
						case 2:
							methodBuilder.addOpcode(Opcode.getlocal_2);
							break;
						case 3:
							methodBuilder.addOpcode(Opcode.getlocal_3);
							break;
						default:
							methodBuilder.addOpcode(Opcode.getlocal, [idx]);
							break;
					}
				}
				methodBuilder.addOpcode(Opcode.newarray, [len]);
				if (methodBuilder.hasRestArguments) {
					methodBuilder.addOpcode(Opcode.getlocal, [len + 1]);
					methodBuilder.addOpcode(Opcode.callproperty, [concatQName, 1]);
				}
			} else if (methodBuilder.hasRestArguments) {
				methodBuilder.addOpcode(Opcode.getlocal_1);
			} else {
				methodBuilder.addOpcode(Opcode.pushnull);
			}
			if (!isInterface) {
				methodBuilder.addOpcode(Opcode.getlocal_0) //
					.addOpcode(Opcode.getsuper, [methodQName]);
			} else {
				methodBuilder.addOpcode(Opcode.pushnull);
			}
			methodBuilder.addOpcode(Opcode.callproperty, [multiName, 5]);
			if (methodBuilder.returnType == BuiltIns.VOID.fullName) {
				methodBuilder.addOpcode(Opcode.pop) //
					.addOpcode(Opcode.returnvoid);
			} else {
				methodBuilder.addOpcode(Opcode.returnvalue);
			}
		}

	}
}
