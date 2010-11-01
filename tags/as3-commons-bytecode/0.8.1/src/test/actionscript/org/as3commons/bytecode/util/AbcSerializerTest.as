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
package org.as3commons.bytecode.util {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.utils.ByteArray;

	import flexunit.framework.TestCase;

	import org.as3commons.bytecode.TestConstants;
	import org.as3commons.bytecode.abc.AbcFile;
	import org.as3commons.bytecode.abc.ConstantPool;
	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.Multiname;
	import org.as3commons.bytecode.abc.MultinameL;
	import org.as3commons.bytecode.abc.NamespaceSet;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.RuntimeQualifiedName;
	import org.as3commons.bytecode.abc.RuntimeQualifiedNameL;
	import org.as3commons.bytecode.abc.enum.MultinameKind;
	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.bytecode.swf.AbcClassLoader;
	import org.as3commons.bytecode.template.BaseClass;

	public class AbcSerializerTest extends TestCase {
		private var _fixture:AbcSerializer;

		private var _classLoader:AbcClassLoader;

		{
			BaseClass;
		}

		public function AbcSerializerTest(methodName:String = null) {
			super(methodName);
		}

		override public function setUp():void {
			_fixture = new AbcSerializer();
			_classLoader = new AbcClassLoader();
		}

		public function testSerializeDynamicSubClass():void {
			var abcFileAsByteArray:ByteArray = TestConstants.getProxyTemplate();
			var deserializedClass:AbcFile = new AbcDeserializer(abcFileAsByteArray).deserialize();
			var reserializedStream:ByteArray = _fixture.serializeAbcFile(deserializedClass);

//        	trace(deserializedClass.constantPool);
//        	trace("Total Bytes: " + abcFileAsByteArray.length);
			for (var index:int = 0; index < reserializedStream.length; index++) {
				var originalByte:int = abcFileAsByteArray[index];
				var serializedByte:int = reserializedStream[index];
//                (index >= 527 && index <= 563) ? trace("abcFileAsByteArray[" + index + "] = " + originalByte + ", serializedStream[" + index + "] = " + serializedByte) : null;
				assertEquals(originalByte, serializedByte);
			}

			_classLoader.addEventListener(Event.COMPLETE, addAsync(function(event:Event):void {
				assertTrue(true);
			}, 5000));
			_classLoader.addEventListener(IOErrorEvent.IO_ERROR, function(event:IOErrorEvent):void {
				fail("loader error: " + event.text);
			});
			_classLoader.addEventListener(IOErrorEvent.VERIFY_ERROR, function(event:IOErrorEvent):void {
				fail("loader error: " + event.text);
			});
			_classLoader.loadClassDefinitionsFromBytecode([TestConstants.getBaseClassTemplate(), TestConstants.getMethodInvocation(), reserializedStream]);
		}

		public function testSerializeBaseClass():void {
			var abcFileAsByteArray:ByteArray = TestConstants.getBaseClassTemplate();
			var deserializedClass:AbcFile = new AbcDeserializer(abcFileAsByteArray).deserialize();
			var reserializedStream:ByteArray = _fixture.serializeAbcFile(deserializedClass);

			for (var index:int = 0; index < reserializedStream.length; index++) {
				var originalByte:int = abcFileAsByteArray[index];
				var serializedByte:int = reserializedStream[index];
				assertEquals(originalByte, serializedByte);
			}

			_classLoader.addEventListener(Event.COMPLETE, addAsync(function(event:Event):void {
				assertTrue(true);
			}, 5000));
			_classLoader.addEventListener(IOErrorEvent.IO_ERROR, function(event:IOErrorEvent):void {
				fail("loader error: " + event.text);
			});
			_classLoader.addEventListener(IOErrorEvent.VERIFY_ERROR, function(event:IOErrorEvent):void {
				fail("loader error: " + event.text);
			});
			_classLoader.loadClassDefinitionsFromBytecode([reserializedStream]);
		}

		public function testSerializeClassWithNoMethodsOrProperties():void {
			var abcFileAsByteArray:ByteArray = TestConstants.getFullClassDefinitionByteCode();
			var deserializedClass:AbcFile = new AbcDeserializer(abcFileAsByteArray).deserialize();
			var reserializedStream:ByteArray = _fixture.serializeAbcFile(deserializedClass);

//        	for (var abcIndex : int = 0; abcIndex < abcFileAsByteArray.length; abcIndex++)
//        	{
//        		trace("abcFileAsByteArray[" + abcIndex + "] = " + abcFileAsByteArray[abcIndex]);
//        	}

			_classLoader.addEventListener(Event.COMPLETE, addAsync(function(event:Event):void {
				assertTrue(true);
			}, 5000));
			_classLoader.addEventListener(IOErrorEvent.IO_ERROR, function(event:IOErrorEvent):void {
				fail("loader error: " + event.text);
			});
			_classLoader.addEventListener(IOErrorEvent.VERIFY_ERROR, function(event:IOErrorEvent):void {
				fail("loader error: " + event.text);
			});
			_classLoader.loadClassDefinitionsFromBytecode([TestConstants.getInterfaceDefinitionByteCode(), reserializedStream]);
//
//        	var deserializer : AbcDeserializer = new AbcDeserializer(serializedStream);
//        	assertEquals(16, deserializer.readU16());
//        	assertEquals(46, deserializer.readU16());
//        	
//        	var expectedConstantPool : ConstantPool = new ConstantPool();
//        	expectedConstantPool.addInt(0);
//        	expectedConstantPool.addUint(0);
//        	expectedConstantPool.addDouble(0);
//        	var expectedStrings : Array = ["*", "assets.abc:ClassWithNoMethodsOrProperties", "", "assets.abc", "ClassWithNoMethodsOrProperties", "Object", "ClassWithNoMethodsOrProperties.as$1"];
//        	for each (var string : String in expectedStrings)
//        	{
//        	   expectedConstantPool.addString(string);
//        	}
//        	
//        	// namespaces
//        	var starNamespace : LNamespace = new LNamespace(NamespaceKind.NAMESPACE, "*"); // Namespace[namespace::*]
//        	var publicAssetsAbcNamespace : LNamespace = new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, "assets.abc"); // Namespace[public::assets.abc]
//        	var publicNamespace : LNamespace = new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, ""); // Namespace[public] 
//        	var scriptInitializerNamespace : LNamespace = new LNamespace(NamespaceKind.PRIVATE_NAMESPACE, "ClassWithNoMethodsOrProperties.as$1") // Namespace[private::ClassWithNoMethodsOrProperties.as$1]
//        	var packageInternalAssetsAbcNamespace : LNamespace = new LNamespace(NamespaceKind.PACKAGE_INTERNAL_NAMESPACE, "assets.abc"); // Namespace[packageInternalNamespace::assets.abc]
//        	expectedConstantPool.addNamespace(starNamespace);
//        	expectedConstantPool.addNamespace(new LNamespace(NamespaceKind.PRIVATE_NAMESPACE, "assets.abc:ClassWithNoMethodsOrProperties"));
//        	expectedConstantPool.addNamespace(publicAssetsAbcNamespace);
//        	expectedConstantPool.addNamespace(publicNamespace);
//        	expectedConstantPool.addNamespace(new LNamespace(NamespaceKind.PROTECTED_NAMESPACE, "assets.abc:ClassWithNoMethodsOrProperties"));
//        	expectedConstantPool.addNamespace(scriptInitializerNamespace);
//        	expectedConstantPool.addNamespace(packageInternalAssetsAbcNamespace);
//            
//            // namespace sets
//            // [Namespace[namespace::*]]
//            var firstNamespaceSet : NamespaceSet = new NamespaceSet([starNamespace]);
//            // [Namespace[public::assets.abc], Namespace[public], Namespace[private::ClassWithNoMethodsOrProperties.as$1], Namespace[packageInternalNamespace::assets.abc]]
//            var secondNamespaceSet : NamespaceSet = new NamespaceSet([
//               publicAssetsAbcNamespace,
//               publicNamespace,
//               scriptInitializerNamespace,
//               packageInternalAssetsAbcNamespace 
//            ]);
//            expectedConstantPool.addNamespaceSet(firstNamespaceSet);
//            expectedConstantPool.addNamespaceSet(secondNamespaceSet);
//
//            // multinames
//            expectedConstantPool.addMultiname(new QualifiedName("*", starNamespace)); // QName[Namespace[namespace::*]:*]
//            expectedConstantPool.addMultiname(new QualifiedName("ClassWithNoMethodsOrProperties", publicAssetsAbcNamespace)); // QName[Namespace[public::assets.abc]:ClassWithNoMethodsOrProperties]
//            expectedConstantPool.addMultiname(new QualifiedName("Object", publicNamespace)); // QName[Namespace[public]:Object]
//            expectedConstantPool.addMultiname(new Multiname("Object", secondNamespaceSet)); // Multiname[name=Object, nsset=[Namespace[public::assets.abc], Namespace[public], Namespace[private::ClassWithNoMethodsOrProperties.as$1], Namespace[packageInternalNamespace::assets.abc]]]
//            
//            // Check to make sure that original and serialized ConstantPools match
//            assertTrue(deserializer.deserializeConstantPool(new ConstantPool()).equals(expectedConstantPool));
//
//        	//TODO: Assert bytecode length the same
//        	//TODO: Load the serialized bytecode in to the AVM 
//        	trace("length: " + abcFileAsByteArray.length);
		}

		/**
		 * Manually assembles a ConstantPool and serializes it, checking validity.
		 */
		public function testSerializeConstantPool():void {
			// NOTE: The constant pool has to be completely filled before it is serialized. For example, you can't have Namespaces
			// added late in the game and expect the bytes to be in the right position afterward, since the names of the Namespaces
			// are stored in the String pool (which comes ahead of the Namespace pool). 
			var constantPool:ConstantPool = new ConstantPool();
			constantPool.addInt(1);
			constantPool.addInt(2);
			constantPool.addInt(-3);
			constantPool.addUint(3);
			constantPool.addUint(4);
			constantPool.addDouble(5.6789);
			constantPool.addDouble(9.8765);
			constantPool.addDouble(-10.1234);
			constantPool.addString("stringOne");
			constantPool.addString("stringTwo");

			// namespace pool
			var publicNamespace:LNamespace = new LNamespace(NamespaceKind.NAMESPACE, "publicNamespace");
			constantPool.addNamespace(publicNamespace);
			var packageNamespace:LNamespace = new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, "packageNamespace");
			constantPool.addNamespace(packageNamespace);
			var packageInternalNamespace:LNamespace = new LNamespace(NamespaceKind.PACKAGE_INTERNAL_NAMESPACE, "packageInternalNamespace");
			constantPool.addNamespace(packageInternalNamespace);
			var protectedNamespace:LNamespace = new LNamespace(NamespaceKind.PROTECTED_NAMESPACE, "protectedNamespace");
			constantPool.addNamespace(protectedNamespace);
			constantPool.addNamespace(new LNamespace(NamespaceKind.EXPLICIT_NAMESPACE, "explicitNamespace"));
			constantPool.addNamespace(new LNamespace(NamespaceKind.STATIC_PROTECTED_NAMESPACE, "staticProtectedNamespace"));
			constantPool.addNamespace(new LNamespace(NamespaceKind.PRIVATE_NAMESPACE, "privateNamespace"));

			// namespace set pool
			var firstNamespaceSet:NamespaceSet = new NamespaceSet([publicNamespace, packageNamespace]);
			constantPool.addNamespaceSet(firstNamespaceSet);
			constantPool.addNamespaceSet(new NamespaceSet([packageInternalNamespace, protectedNamespace]));
			var lastNamespaceSetNamespace:LNamespace = new LNamespace(NamespaceKind.NAMESPACE, "namespaceSetNamespace");
			constantPool.addNamespaceSet(new NamespaceSet([lastNamespaceSetNamespace]));

			// multiname pool
			constantPool.addMultiname(new QualifiedName("qualifiedName", publicNamespace, MultinameKind.QNAME));
			constantPool.addMultiname(new QualifiedName("qualifiedNameA", protectedNamespace, MultinameKind.QNAME_A));
			constantPool.addMultiname(new RuntimeQualifiedNameL(MultinameKind.RTQNAME_L));
			constantPool.addMultiname(new RuntimeQualifiedNameL(MultinameKind.RTQNAME_LA));
			constantPool.addMultiname(new RuntimeQualifiedName("cRuntimeQualifiedName", MultinameKind.RTQNAME));
			constantPool.addMultiname(new RuntimeQualifiedName("cRuntimeQualifiedNameA", MultinameKind.RTQNAME_A));
			constantPool.addMultiname(new Multiname("cMultiname", firstNamespaceSet, MultinameKind.MULTINAME));
			constantPool.addMultiname(new Multiname("cMultinameA", firstNamespaceSet, MultinameKind.MULTINAME_A));
			constantPool.addMultiname(new MultinameL(firstNamespaceSet, MultinameKind.MULTINAME_L));
			constantPool.addMultiname(new MultinameL(firstNamespaceSet, MultinameKind.MULTINAME_LA));

			// Convert to bytestream
			var actualBytes:ByteArray = AbcSpec.byteArray();
			_fixture.serializeConstantPool(constantPool, actualBytes);
			actualBytes.position = 0;


			// BEGIN ASSERTIONS (NOTE: assertion order is significant, must be the same as the order that the constants are added to the associated pools)		

			// Int Pool Assertions
			assertEquals(4, AbcSpec.readU30(actualBytes)); // u30 int_count (always +1 than actual count)
			assertEquals(1, AbcSpec.readU30(actualBytes));
			assertEquals(2, AbcSpec.readU30(actualBytes));
			assertEquals(-3, AbcSpec.readS32(actualBytes));

			// Uint Pool Assertions
			assertEquals(3, AbcSpec.readU30(actualBytes)); // u30 uint_count (always +1 than actual count)
			assertEquals(3, AbcSpec.readU30(actualBytes));
			assertEquals(4, AbcSpec.readU30(actualBytes));

			// Double Pool Assertions
			assertEquals(4, AbcSpec.readU30(actualBytes)); // u30 double_count (always +1 than actual count)
			assertEquals(5.6789, AbcSpec.readD64(actualBytes));
			assertEquals(9.8765, AbcSpec.readD64(actualBytes));
			assertEquals(-10.1234, AbcSpec.readD64(actualBytes));

			// String Pool Assertions
			assertEquals(17, AbcSpec.readU30(actualBytes)); // u30 string_count (always +1 than actual count)
			assertEquals("stringOne", AbcSpec.readStringInfo(actualBytes));
			assertEquals("stringTwo", AbcSpec.readStringInfo(actualBytes));
			assertEquals("publicNamespace", AbcSpec.readStringInfo(actualBytes));
			assertEquals("packageNamespace", AbcSpec.readStringInfo(actualBytes));
			assertEquals("packageInternalNamespace", AbcSpec.readStringInfo(actualBytes));
			assertEquals("protectedNamespace", AbcSpec.readStringInfo(actualBytes));
			assertEquals("explicitNamespace", AbcSpec.readStringInfo(actualBytes));
			assertEquals("staticProtectedNamespace", AbcSpec.readStringInfo(actualBytes));
			assertEquals("privateNamespace", AbcSpec.readStringInfo(actualBytes));
			assertEquals("namespaceSetNamespace", AbcSpec.readStringInfo(actualBytes));
			assertEquals("qualifiedName", AbcSpec.readStringInfo(actualBytes));
			assertEquals("qualifiedNameA", AbcSpec.readStringInfo(actualBytes));
			assertEquals("cRuntimeQualifiedName", AbcSpec.readStringInfo(actualBytes));
			assertEquals("cRuntimeQualifiedNameA", AbcSpec.readStringInfo(actualBytes));
			assertEquals("cMultiname", AbcSpec.readStringInfo(actualBytes));
			assertEquals("cMultinameA", AbcSpec.readStringInfo(actualBytes));

			// Namespace Pool Assertions
			assertEquals(9, AbcSpec.readU30(actualBytes)); // u30 namespace_count (always +1 than actual count)
			assertEquals(NamespaceKind.NAMESPACE.byteValue, AbcSpec.readU8(actualBytes)); // u8 namespace_count (always +1 than actual count)
			assertEquals(constantPool.getStringPosition("publicNamespace"), AbcSpec.readU30(actualBytes)); // u30 name
			assertEquals(NamespaceKind.PACKAGE_NAMESPACE.byteValue, AbcSpec.readU8(actualBytes));
			assertEquals(constantPool.getStringPosition("packageNamespace"), AbcSpec.readU30(actualBytes));
			assertEquals(NamespaceKind.PACKAGE_INTERNAL_NAMESPACE.byteValue, AbcSpec.readU8(actualBytes));
			assertEquals(constantPool.getStringPosition("packageInternalNamespace"), AbcSpec.readU30(actualBytes));
			assertEquals(NamespaceKind.PROTECTED_NAMESPACE.byteValue, AbcSpec.readU8(actualBytes));
			assertEquals(constantPool.getStringPosition("protectedNamespace"), AbcSpec.readU30(actualBytes));
			assertEquals(NamespaceKind.EXPLICIT_NAMESPACE.byteValue, AbcSpec.readU8(actualBytes));
			assertEquals(constantPool.getStringPosition("explicitNamespace"), AbcSpec.readU30(actualBytes));
			assertEquals(NamespaceKind.STATIC_PROTECTED_NAMESPACE.byteValue, AbcSpec.readU8(actualBytes));
			assertEquals(constantPool.getStringPosition("staticProtectedNamespace"), AbcSpec.readU30(actualBytes));
			assertEquals(NamespaceKind.PRIVATE_NAMESPACE.byteValue, AbcSpec.readU8(actualBytes));
			assertEquals(constantPool.getStringPosition("privateNamespace"), AbcSpec.readU30(actualBytes));
			assertEquals(NamespaceKind.NAMESPACE.byteValue, AbcSpec.readU8(actualBytes));
			assertEquals(constantPool.getStringPosition("namespaceSetNamespace"), AbcSpec.readU30(actualBytes));

			// Namespace Set Pool Assertions
			assertEquals(4, AbcSpec.readU30(actualBytes)); // actual namespace set count + 1
			assertEquals(2, AbcSpec.readU30(actualBytes)); // length of first namespaceSet, 2 items
			assertEquals(constantPool.getNamespacePosition(publicNamespace), AbcSpec.readU30(actualBytes));
			assertEquals(constantPool.getNamespacePosition(packageNamespace), AbcSpec.readU30(actualBytes));
			assertEquals(2, AbcSpec.readU30(actualBytes)); // length of second namespaceSet, 2 items
			assertEquals(constantPool.getNamespacePosition(packageInternalNamespace), AbcSpec.readU30(actualBytes));
			assertEquals(constantPool.getNamespacePosition(protectedNamespace), AbcSpec.readU30(actualBytes));
			assertEquals(1, AbcSpec.readU30(actualBytes)); // length of third namespaceSet, 1 item
			assertEquals(constantPool.getNamespacePosition(lastNamespaceSetNamespace), AbcSpec.readU30(actualBytes));

			// Multiname Pool Assertions
			assertEquals(11, AbcSpec.readU30(actualBytes)); // actual multiname count + 1
			assertEquals(MultinameKind.QNAME.byteValue, AbcSpec.readU8(actualBytes)); // first multiname is of type QNAME
			assertEquals(constantPool.getNamespacePosition(publicNamespace), AbcSpec.readU30(actualBytes)); // index of QName namespace (in this case, public namespace)
			assertEquals(constantPool.getStringPosition("qualifiedName"), AbcSpec.readU30(actualBytes)); // index of QName name
			assertEquals(MultinameKind.QNAME_A.byteValue, AbcSpec.readU8(actualBytes)); // second multiname is of type QNAME_A
			assertEquals(constantPool.getNamespacePosition(protectedNamespace), AbcSpec.readU30(actualBytes)); // index of QName namespace (in this case, protected namespace)
			assertEquals(constantPool.getStringPosition("qualifiedNameA"), AbcSpec.readU30(actualBytes)); // index of QName name
			assertEquals(MultinameKind.RTQNAME_L.byteValue, AbcSpec.readU30(actualBytes)); // third namespace is of type RTQNAME_L, which has no data
			assertEquals(MultinameKind.RTQNAME_LA.byteValue, AbcSpec.readU30(actualBytes)); // fourth namespace is of type RTQNAME_LA, which has no data
			assertEquals(MultinameKind.RTQNAME.byteValue, AbcSpec.readU30(actualBytes)); // fifth namespace is of type RTQNAME
			assertEquals(constantPool.getStringPosition("cRuntimeQualifiedName"), AbcSpec.readU30(actualBytes)); // data for RTQNAME is the string position of the qualified name
			assertEquals(MultinameKind.RTQNAME_A.byteValue, AbcSpec.readU30(actualBytes)); // sixth namespace is of type RTQNAME_A
			assertEquals(constantPool.getStringPosition("cRuntimeQualifiedNameA"), AbcSpec.readU30(actualBytes)); // data for RTQNAME_A is the string position of the qualified name
			assertEquals(MultinameKind.MULTINAME.byteValue, AbcSpec.readU30(actualBytes)); // seventh namespace is of type MULTINAME
			assertEquals(constantPool.getStringPosition("cMultiname"), AbcSpec.readU30(actualBytes)); // first data item is the multiname string position
			assertEquals(constantPool.getNamespaceSetPosition(firstNamespaceSet), AbcSpec.readU30(actualBytes)); // second data item is the namespace set position
			assertEquals(MultinameKind.MULTINAME_A.byteValue, AbcSpec.readU30(actualBytes)); // eighth namespace is of type MULTINAME
			assertEquals(constantPool.getStringPosition("cMultinameA"), AbcSpec.readU30(actualBytes)); // first data item is the multiname string position
			assertEquals(constantPool.getNamespaceSetPosition(firstNamespaceSet), AbcSpec.readU30(actualBytes)); // second data item is the namespace set position
			assertEquals(MultinameKind.MULTINAME_L.byteValue, AbcSpec.readU30(actualBytes)); // ninth namespace is of type MULTINAME_L
			assertEquals(constantPool.getNamespaceSetPosition(firstNamespaceSet), AbcSpec.readU30(actualBytes)); // data is the namespace set index
			assertEquals(MultinameKind.MULTINAME_LA.byteValue, AbcSpec.readU30(actualBytes)); // tenth namespace is of type MULTINAME_LA
			assertEquals(constantPool.getNamespaceSetPosition(firstNamespaceSet), AbcSpec.readU30(actualBytes)); // data is the namespace set index 
		}
	}
}