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
	import flash.events.Event;
	import flash.system.ApplicationDomain;

	import flexunit.framework.TestCase;

	import org.as3commons.bytecode.abc.enum.Opcode;
	import org.as3commons.bytecode.emit.IAbcBuilder;
	import org.as3commons.bytecode.emit.IAccessorBuilder;
	import org.as3commons.bytecode.emit.IClassBuilder;
	import org.as3commons.bytecode.emit.IMethodBuilder;
	import org.as3commons.bytecode.emit.IPropertyBuilder;
	import org.as3commons.reflect.AccessorAccess;
	import org.as3commons.reflect.Field;
	import org.as3commons.reflect.Method;
	import org.as3commons.reflect.Type;

	public class AbcBuilderTest extends TestCase {

		private var _abcBuilder:IAbcBuilder;

		public function AbcBuilderTest() {
			super();
		}

		override public function setUp():void {
			_abcBuilder = new AbcBuilder();
		}

		public function testBuildClassWithSimpleProperty():void {
			var classBuilder:IClassBuilder = _abcBuilder.definePackage("com.myclasses.test").defineClass("MySimplePropertyTest");
			var propertyBuilder:IPropertyBuilder = classBuilder.defineProperty("testString", "String", "test");
			_abcBuilder.addEventListener(Event.COMPLETE, addAsync(propertyBuildSuccessHandler, 5000), false, 0, true);
			_abcBuilder.buildAndLoad();
		}

		private function propertyBuildSuccessHandler(event:Event):void {
			var cls:Class = ApplicationDomain.currentDomain.getDefinition("com.myclasses.test.MySimplePropertyTest") as Class;
			assertNotNull(cls);
			var instance:Object = new cls();
			assertNotNull(instance);
			assertEquals("test", instance.testString);
			instance.testString = "test2";
			assertEquals("test2", instance.testString);
		}

		public function testBuildClassWithMetadata():void {
			var classBuilder:IClassBuilder = _abcBuilder.definePackage("com.myclasses.test").defineClass("MySimplePropertyWithMetadataTest");
			var propertyBuilder:IPropertyBuilder = classBuilder.defineProperty("testString", "String", "test");
			propertyBuilder.defineMetadata("Custom");
			var mb:IMethodBuilder = classBuilder.defineMethod("testMethod");
			mb.defineMetadata("CustomMethod");
			mb.addOpcode(Opcode.getlocal_0).addOpcode(Opcode.pushscope).addOpcode(Opcode.returnvoid);
			_abcBuilder.addEventListener(Event.COMPLETE, addAsync(propertyMetadataBuildSuccessHandler, 5000), false, 0, true);
			_abcBuilder.buildAndLoad();
			//var abcFile:AbcFile = _abcBuilder.build();
			//var ba:ByteArray = new AbcSerializer().serializeAbcFile(abcFile);
			//abcFile = new AbcDeserializer(ba).deserialize();
		}

		private function propertyMetadataBuildSuccessHandler(event:Event):void {
			var cls:Class = ApplicationDomain.currentDomain.getDefinition("com.myclasses.test.MySimplePropertyWithMetadataTest") as Class;
			assertNotNull(cls);
			var instance:Object = new cls();
			var type:Type = Type.forClass(cls);
			var fld:Field = type.getField('testString');
			assertTrue(fld.hasMetadata('Custom'));
			var mthd:Method = type.getMethod('testMethod');
			assertTrue(mthd.hasMetadata('CustomMethod'));
		}

		public function testBuildClassWithComplexProperty():void {
			var classBuilder:IClassBuilder = _abcBuilder.definePackage("com.myclasses.test").defineClass("MyComplexPropertyTest");
			var propertyBuilder:IPropertyBuilder = classBuilder.defineProperty("testObject", "flash.events.Event");
			_abcBuilder.addEventListener(Event.COMPLETE, addAsync(propertyComplexBuildSuccessHandler, 5000), false, 0, true);
			_abcBuilder.buildAndLoad();
		}

		private function propertyComplexBuildSuccessHandler(event:Event):void {
			var cls:Class = ApplicationDomain.currentDomain.getDefinition("com.myclasses.test.MyComplexPropertyTest") as Class;
			assertNotNull(cls);
			var instance:Object = new cls();
			assertNotNull(instance);
			assertNull(instance.testObject);
			var evt:Event = new Event("test");
			instance.testObject = evt;
			assertNotNull(instance.testObject);
			assertStrictlyEquals(evt, instance.testObject);
		}

		public function testBuildClassWithPropertyInitializations():void {
			var classBuilder:IClassBuilder = _abcBuilder.definePackage("com.myclasses.test").defineClass("MyPropertyInitializationTest");
			var propertyBuilder:IPropertyBuilder = classBuilder.defineProperty("testObject", "flash.events.Event");
			propertyBuilder.memberInitialization = new MemberInitialization();
			propertyBuilder.memberInitialization.constructorArguments = ["myEventType", true, true];
			_abcBuilder.addEventListener(Event.COMPLETE, addAsync(propertyInitsBuildSuccessHandler, 5000), false, 0, true);
			_abcBuilder.buildAndLoad();
		}

		public function propertyInitsBuildSuccessHandler(event:Event):void {
			var cls:Class = ApplicationDomain.currentDomain.getDefinition("com.myclasses.test.MyPropertyInitializationTest") as Class;
			assertNotNull(cls);
			var instance:Object = new cls();
			assertNotNull(instance);
			assertNotNull(instance.testObject);
			var event:Event = instance.testObject as Event;
			assertNotNull(event);
			assertEquals("myEventType", event.type);
			assertTrue(event.bubbles);
			assertTrue(event.cancelable);
		}

		public function testBuildClassWithPropertyWithGeneratedNamespaceScope():void {
			_abcBuilder.definePackage("com.myclasses.test").defineNamespace("my_namespace_test", "http://www.test.com/mytestnamespace");
			var classBuilder:IClassBuilder = _abcBuilder.definePackage("com.myclasses.test").defineClass("MyCustomNamespacePropertyTest");
			var propertyBuilder:IPropertyBuilder = classBuilder.defineProperty("testObject", "flash.events.Event");
			propertyBuilder.scopeName = "my_namespace_test";
			propertyBuilder.namespaceURI = "http://www.test.com/mytestnamespace";
			_abcBuilder.addEventListener(Event.COMPLETE, addAsync(propertyWithGeneratednamespaceBuildSuccessHandler, 5000), false, 0, true);
			_abcBuilder.buildAndLoad();
		}

		private function propertyWithGeneratednamespaceBuildSuccessHandler(event:Event):void {
			var cls:Class = ApplicationDomain.currentDomain.getDefinition("com.myclasses.test.MyCustomNamespacePropertyTest") as Class;
			assertNotNull(cls);
			var instance:Object = new cls();
			assertNotNull(instance);
			var qn:QName = new QName("http://www.test.com/mytestnamespace", "testObject");
			assertNull(instance[qn]);
			var evt:Event = new Event("test");
			instance[qn] = evt;
			assertStrictlyEquals(evt, instance[qn]);
		}

		public function testBuildClassWithMethod():void {
			var classBuilder:IClassBuilder = _abcBuilder.definePackage("com.myclasses.test").defineClass("MyMethodTest");
			var methodBuilder:IMethodBuilder = classBuilder.defineMethod();
			methodBuilder.name = "testMe";
			methodBuilder.addOpcode(Opcode.getlocal_0);
			methodBuilder.addOpcode(Opcode.pushscope);
			methodBuilder.addOpcode(Opcode.returnvoid);
			_abcBuilder.addEventListener(Event.COMPLETE, addAsync(methodBuildSuccessHandler, 5000), false, 0, true);
			_abcBuilder.buildAndLoad();
		}

		private function methodBuildSuccessHandler(event:Event):void {
			var cls:Class = ApplicationDomain.currentDomain.getDefinition("com.myclasses.test.MyMethodTest") as Class;
			assertNotNull(cls);
			var instance:Object = new cls();
			assertNotNull(instance);
                        instance.testMe();
                        assertTrue(true);
		}

		public function testBuildClassReadOnlyAccessor():void {
			var classBuilder:IClassBuilder = _abcBuilder.definePackage("com.myclasses.test").defineClass("MyReadOnlyAccessorTest");
			var accessorBuilder:IAccessorBuilder = classBuilder.defineAccessor("testAccessor", "String", "test");
			accessorBuilder.access = AccessorAccess.READ_ONLY;
			_abcBuilder.addEventListener(Event.COMPLETE, addAsync(readOnlyAccessorBuildSuccessHandler, 5000), false, 0, true);
			_abcBuilder.buildAndLoad();
		}

		private function readOnlyAccessorBuildSuccessHandler(event:Event):void {
			var cls:Class = ApplicationDomain.currentDomain.getDefinition("com.myclasses.test.MyReadOnlyAccessorTest") as Class;
			assertNotNull(cls);
			var instance:Object = new cls();
			assertNotNull(instance);
			assertEquals("test", instance.testAccessor);
			try {
				instance.testAccessor = "test1";
				fail("accessor should be read-only");
			} catch (e:Error) {

			}
		}

		public function testBuildClassWriteOnlyAccessor():void {
			var classBuilder:IClassBuilder = _abcBuilder.definePackage("com.myclasses.test").defineClass("MyWriteOnlyAccessorTest");
			var accessorBuilder:IAccessorBuilder = classBuilder.defineAccessor("testAccessor", "String");
			accessorBuilder.access = AccessorAccess.WRITE_ONLY;
			_abcBuilder.addEventListener(Event.COMPLETE, addAsync(writeOnlyAccessorBuildSuccessHandler, 5000), false, 0, true);
			_abcBuilder.buildAndLoad();
		}

		private function writeOnlyAccessorBuildSuccessHandler(event:Event):void {
			var cls:Class = ApplicationDomain.currentDomain.getDefinition("com.myclasses.test.MyWriteOnlyAccessorTest") as Class;
			assertNotNull(cls);
			var instance:Object = new cls();
			assertNotNull(instance);
			instance.testAccessor = "test1";
			try {
				var val:String = instance.testAccessor;
				fail("accessor should be write-only");
			} catch (e:Error) {

			}
		}

		public function testBuildClassReadWriteAccessor():void {
			var classBuilder:IClassBuilder = _abcBuilder.definePackage("com.myclasses.test").defineClass("MyReadWriteAccessorTest");
			var accessorBuilder:IAccessorBuilder = classBuilder.defineAccessor("testAccessor", "String", "test");
			_abcBuilder.addEventListener(Event.COMPLETE, addAsync(readWriteAccessorBuildSuccessHandler, 5000), false, 0, true);
			_abcBuilder.buildAndLoad();
		}

		private function readWriteAccessorBuildSuccessHandler(event:Event):void {
			var cls:Class = ApplicationDomain.currentDomain.getDefinition("com.myclasses.test.MyReadWriteAccessorTest") as Class;
			assertNotNull(cls);
			var instance:Object = new cls();
			assertNotNull(instance);
			assertEquals("test", instance.testAccessor);
			instance.testAccessor = "test1";
			assertEquals("test1", instance.testAccessor);
		}

	}
}
