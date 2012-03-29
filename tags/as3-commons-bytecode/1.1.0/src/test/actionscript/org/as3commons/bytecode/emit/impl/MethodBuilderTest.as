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
package org.as3commons.bytecode.emit.impl {

	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.MethodInfo;
	import org.as3commons.bytecode.abc.MethodTrait;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.enum.BuiltIns;
	import org.as3commons.bytecode.abc.enum.MethodFlag;
	import org.as3commons.bytecode.as3commons_bytecode;
	import org.as3commons.bytecode.emit.enum.MemberVisibility;
	import org.as3commons.bytecode.typeinfo.Argument;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.flexunit.asserts.assertTrue;

	public class MethodBuilderTest {

		private var _methodBuilder:MethodBuilder;

		public function MethodBuilderTest() {
		}

		[Before]
		public function setUp():void {
			_methodBuilder = new MethodBuilder();
		}

		[Test]
		public function testBuildWithExistingMethodInfo():void {
			var mi:MethodInfo = new MethodInfo();
			mi.methodName = "com.myclasses::MyClass/testMethod";
			mi.flags = MethodFlag.addFlag(mi.flags, MethodFlag.HAS_OPTIONAL);
			mi.returnType = BuiltIns.STRING;
			var arg:Argument = new Argument(BuiltIns.STRING, true);
			mi.argumentCollection[mi.argumentCollection.length] = arg;
			var trait:MethodTrait = new MethodTrait();
			trait.traitMultiname = new QualifiedName("test", LNamespace.PUBLIC);
			mi.as3commonsByteCodeAssignedMethodTrait = trait;

			_methodBuilder.as3commons_bytecode::setMethodInfo(mi);

			assertEquals("testMethod", _methodBuilder.name);
			assertEquals("com.myclasses::MyClass", _methodBuilder.packageName);
			assertTrue(_methodBuilder.hasOptionalArguments);
			assertEquals(1, _methodBuilder.arguments.length);
			assertStrictlyEquals(MemberVisibility.PUBLIC, _methodBuilder.visibility);

			var mi2:MethodInfo = _methodBuilder.build();
			assertStrictlyEquals(mi2, mi);
			assertEquals("com.myclasses::MyClass/testMethod", mi2.methodName);
			assertTrue(MethodFlag.flagPresent(mi2.flags, MethodFlag.HAS_OPTIONAL));
			assertStrictlyEquals(BuiltIns.STRING, mi2.returnType);
			assertEquals(1, mi2.argumentCollection.length);
			var arg2:Argument = mi2.argumentCollection[0];
			assertStrictlyEquals(arg2, arg);
			assertStrictlyEquals(arg2.type, BuiltIns.STRING);
			assertTrue(arg2.isOptional);
			assertNull(arg2.defaultValue);
		}
	}
}