/**
 * Copyright 2009 Maxim Cassian Porges
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.as3commons.bytecode.io {
	import flash.utils.ByteArray;

	import org.as3commons.bytecode.TestConstants;
	import org.as3commons.bytecode.abc.AbcFile;
	import org.as3commons.bytecode.abc.IConstantPool;
	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.bytecode.util.Assertions;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
import org.flexunit.asserts.assertStrictlyEquals;
import org.flexunit.asserts.assertTrue;

public class AbcDeserializerTest {
		//NOTE: This is just used to dump the proxy template for inspection and comparison to weaved proxies 
//		public function TestPrintDynamicSubclass() : void
//		{
//			trace(new AbcDeserializer(TestConstants.getProxyTemplate()).deserialize());
//		}

		public function AbcDeserializerTest() {

		}

		[Test]
		public function testDeserializeBaseClass():void {
			var byteStream:ByteArray = TestConstants.getBaseClassTemplate();
			var abcFile:AbcFile = new AbcDeserializer(byteStream).deserialize();

			// Major/Minor version are 46 and 16 respectively at the time of writing
			assertEquals(16, abcFile.minorVersion);
			assertEquals(46, abcFile.majorVersion);

			// BEGIN CONSTANT POOL ASSERTIONS
			var pool:IConstantPool = abcFile.constantPool;

			// There are two integers in the pool: 0 and 10
			assertEquals(1, pool.integerPool.length);
			assertEquals(0, pool.integerPool[0]);

			// There's one entry in the uint pool: 0
			assertEquals(1, pool.uintPool.length);
			assertEquals(0, pool.uintPool[0]);

			// There's one entry in the double pool: 0
			assertEquals(1, pool.doublePool.length);
			assertTrue(isNaN(pool.doublePool[0]));

			// The namespace set pool has four entries, with 1, 8, 9, and 4 namespaces in each respectively
			//TODO: check contents
			assertEquals(3, pool.namespaceSetPool.length);
			assertEquals(1, pool.namespaceSetPool[0].namespaces.length);
			assertEquals(8, pool.namespaceSetPool[1].namespaces.length);
			assertEquals(4, pool.namespaceSetPool[2].namespaces.length);

			//TODO: check contents
			assertEquals(12, pool.multinamePool.length);

			//TODO: methodinfo
			assertEquals(6, abcFile.methodInfo.length);

			assertEquals(0, abcFile.metadataInfo.length);

			//TODO: classes
			assertEquals(1, abcFile.classInfo.length);

			//TODO: instances
			assertEquals(1, abcFile.instanceInfo.length);

			//TODO: scripts
			assertEquals(1, abcFile.scriptInfo.length);

			//TODO: method bodies
			assertEquals(abcFile.methodInfo.length, abcFile.methodBodies.length);
			assertEquals(6, abcFile.methodBodies.length);
		}

		[Test]
		public function testDeserializeFullClassDefinition():void {
			var byteStream:ByteArray = TestConstants.getFullClassDefinitionByteCode();
			var deserializer:AbcDeserializer = new AbcDeserializer(byteStream);
			var abcFile:AbcFile = deserializer.deserialize();
			var pool:IConstantPool = abcFile.constantPool;

			// Major/Minor version are 46 and 16 respectively at the time of writing
			assertEquals(16, abcFile.minorVersion);
			assertEquals(46, abcFile.majorVersion);

			// BEGIN CONSTANT POOL ASSERTIONS

			// There are two integers in the pool: 0 and 10
			assertEquals(2, pool.integerPool.length);
			assertEquals(0, pool.integerPool[0]);
			assertEquals(10, pool.integerPool[1]);

			// There's one entry in the uint pool: 0
			assertEquals(1, pool.uintPool.length);
			assertEquals(0, pool.uintPool[0]);

			// There's one entry in the double pool: 0
			assertEquals(1, pool.doublePool.length);
			assertTrue(isNaN(pool.doublePool[0]));

			// The following entries are expected in the string pool
			var expectedStringPoolEntries:Array =
					["*",
						"assets.abc:FullClassDefinition",
						"PUBLIC_STATIC_CONSTANT",
						"SOME_STATIC_CONSTANT",
						"SOME_STATIC_VAR",
						"FullClassDefinition.as$1",
						"",
						"assets.abc",
						"Object",
						"Dictionary",
						"flash.utils",
						"dictionary",
						"trace",
						"Constructor",
						"methodWithNoArguments",
						"void",
						"methodWithTwoArguments",
						"String",
						"int",
						"methodWithOptionalArguments",
						"methodWithRestArguments",
						"I don't want to die.",
						"_internalValue",
						"Interface",
						"implementMeOrDie",
						"MethodMetadata",
						"methodKey1",
						"methodValue1",
						"methodKey2",
						"methodValue2",
						"setterForInternalValue",
						"FieldMetadata",
						"fieldKey1",
						"fieldValue1",
						"fieldKey2",
						"fieldValue2",
						"getterForInternalValue",
						"FullClassDefinition",
						"ValuelessMetadata",
						"ValueOnlyMetadata",
						"valueOnlyValue",
						"ClassMetadata",
						"classKey1",
						"classValue1",
						"classKey2",
						"classValue2",
						"classKey3",
						"classValue3",
						"staticMethod",
						"customNamespaceFunction",
//				"custom_namespace",
				"http://www.maximporges.com"];

			assertEquals(expectedStringPoolEntries.length, pool.stringPool.length);
			for each (var expectedString:String in expectedStringPoolEntries) {
				assertFalse(-1 == pool.stringPool.indexOf(expectedString));
			}

			// The following entries are expected in the namespace pool
			var expectedNamespaceEntries:Array = [new LNamespace(NamespaceKind.NAMESPACE, "*"), // Namespace[namespace::*]
				new LNamespace(NamespaceKind.PRIVATE_NAMESPACE, "assets.abc:FullClassDefinition"), // Namespace[private::assets.abc:FullClassDefinition]
				new LNamespace(NamespaceKind.PRIVATE_NAMESPACE, "FullClassDefinition.as$1"), // Namespace[private::FullClassDefinition.as$1]
				new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, ""), // Namespace[public]
				new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, "assets.abc"), // Namespace[public::assets.abc]
				new LNamespace(NamespaceKind.PACKAGE_INTERNAL_NAMESPACE, "assets.abc"), // Namespace[packageInternalNamespace::assets.abc]
				new LNamespace(NamespaceKind.PROTECTED_NAMESPACE, "assets.abc:FullClassDefinition"), // Namespace[protectedNamespace::assets.abc:FullClassDefinition]
				new LNamespace(NamespaceKind.STATIC_PROTECTED_NAMESPACE, "assets.abc:FullClassDefinition"), // Namespace[staticProtectedNamespace::assets.abc:FullClassDefinition]
				new LNamespace(NamespaceKind.STATIC_PROTECTED_NAMESPACE, "Object"), // Namespace[staticProtectedNamespace::Object]
				new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, "flash.utils"), // Namespace[public::flash.utils]
				new LNamespace(NamespaceKind.NAMESPACE, "http://www.maximporges.com") // Namespace[public::flash.utils]
			];
			Assertions.assertArrayContentsEqual(expectedNamespaceEntries, pool.namespacePool);

			// The namespace set pool has four entries, with 1, 8, 9, and 4 namespaces in each respectively
			//TODO: check contents
			assertEquals(4, pool.namespaceSetPool.length);
			assertEquals(1, pool.namespaceSetPool[0].namespaces.length);
			assertEquals(9, pool.namespaceSetPool[1].namespaces.length);
			assertEquals(10, pool.namespaceSetPool[2].namespaces.length);
			assertEquals(5, pool.namespaceSetPool[3].namespaces.length);

			// The multiname pool has 25 entries
			//TODO: check contents
			assertEquals(28, pool.multinamePool.length);

			//TODO: methodinfo
			assertEquals(12, abcFile.methodInfo.length);

			//TODO: metadata
			assertEquals(5, abcFile.metadataInfo.length);

			//TODO: classes
			assertEquals(1, abcFile.classInfo.length);

			//TODO: instances
			assertEquals(1, abcFile.instanceInfo.length);

			//TODO: scripts
			assertEquals(1, abcFile.scriptInfo.length);

			//TODO: method bodies
			assertEquals(abcFile.methodInfo.length, abcFile.methodBodies.length);
			assertEquals(12, abcFile.methodBodies.length);
		}
	}
}