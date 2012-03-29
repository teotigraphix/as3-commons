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
	import avmplus.getQualifiedClassName;

	import flash.events.Event;
	import flash.system.ApplicationDomain;

	import org.as3commons.bytecode.abc.enum.Opcode;
	import org.as3commons.bytecode.as3commons_bytecode_proxy;
	import org.as3commons.bytecode.emit.IAbcBuilder;
	import org.as3commons.bytecode.emit.IAccessorBuilder;
	import org.as3commons.bytecode.emit.IClassBuilder;
	import org.as3commons.bytecode.emit.IInterfaceBuilder;
	import org.as3commons.bytecode.emit.IMethodBuilder;
	import org.as3commons.bytecode.emit.IPropertyBuilder;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.reflect.AccessorAccess;
	import org.as3commons.reflect.Field;
	import org.as3commons.reflect.Method;
	import org.as3commons.reflect.Type;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.asserts.fail;
	import org.flexunit.async.Async;

	public class AbcBuilderTest {

		private var _abcBuilder:IAbcBuilder;
		private static var _staticWasCalled:Boolean;

		public function AbcBuilderTest() {
			super();
		}

		[Before]
		public function setUp():void {
			_abcBuilder = new AbcBuilder();
		}

		[Test(async)]
		public function testBuildClassWithSimpleProperty():void {
			var handler:Function = function (event:Event, data:*):void {
				var cls:Class = ApplicationDomain.currentDomain.getDefinition("com.myclasses.test.MySimplePropertyTest") as Class;
				assertNotNull(cls);
				var instance:Object = new cls();
				assertNotNull(instance);
				assertEquals("test", instance.testString);
				instance.testString = "test2";
				assertEquals("test2", instance.testString);
			};

			var classBuilder:IClassBuilder = _abcBuilder.definePackage("com.myclasses.test").defineClass("MySimplePropertyTest");
			classBuilder.defineProperty("testString", "String", "test");
			_abcBuilder.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handler, 5000), false, 0, true);
			_abcBuilder.buildAndLoad();
		}

		[Test(async)]
		public function testBuildClassWithMetadata():void {
			var handler:Function = function propertyMetadataBuildSuccessHandler(event:Event, data:*):void {
				var cls:Class = ApplicationDomain.currentDomain.getDefinition("com.myclasses.test.MySimplePropertyWithMetadataTest") as Class;
				assertNotNull(cls);
				var instance:Object = new cls();
				var type:Type = Type.forClass(cls);
				var fld:Field = type.getField('testString');
				assertTrue(fld.hasMetadata('Custom'));
				var mthd:Method = type.getMethod('testMethod');
				assertTrue(mthd.hasMetadata('CustomMethod'));
			};

			var classBuilder:IClassBuilder = _abcBuilder.definePackage("com.myclasses.test").defineClass("MySimplePropertyWithMetadataTest");
			var propertyBuilder:IPropertyBuilder = classBuilder.defineProperty("testString", "String", "test");
			propertyBuilder.defineMetadata("Custom");
			var mb:IMethodBuilder = classBuilder.defineMethod("testMethod");
			mb.defineMetadata("CustomMethod");
			mb.addOpcode(Opcode.getlocal_0).addOpcode(Opcode.pushscope).addOpcode(Opcode.returnvoid);
			_abcBuilder.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handler, 5000), false, 0, true);
			_abcBuilder.buildAndLoad();
			//var abcFile:AbcFile = _abcBuilder.build();
			//var ba:ByteArray = new AbcSerializer().serializeAbcFile(abcFile);
			//abcFile = new AbcDeserializer(ba).deserialize();
		}

		[Test(async)]
		public function testBuildClassWithSimplePropertyWithStaticInitializer():void {
			var handler:Function = function (event:Event, data:*):void {
				var cls:Class = ApplicationDomain.currentDomain.getDefinition("com.myclasses.test.MySimplePropertyTestWithStaticInitializerClass") as Class;
				assertNotNull(cls);
				var instance:Object = new cls();
				assertEquals("testValue", instance.testString);
			};

			var classBuilder:IClassBuilder = _abcBuilder.definePackage("com.myclasses.test").defineClass("MySimplePropertyTestWithStaticInitializerClass");
			var propertyBuilder:IPropertyBuilder = classBuilder.defineProperty("testString", "String");
			propertyBuilder.memberInitialization = new MemberInitialization();
			propertyBuilder.memberInitialization.factoryMethodName = "createString";
			var methodBuilder:IMethodBuilder = classBuilder.defineMethod("createString");
			methodBuilder.isStatic = true;
			methodBuilder.returnType = "String";
			methodBuilder.addOp(Opcode.getlocal_0.op()).addOp(Opcode.pushscope.op()).addOp(Opcode.pushstring.op(["testValue"])).addOp(Opcode.returnvalue.op());
			_abcBuilder.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handler, 5000), false, 0, true);
			_abcBuilder.buildAndLoad();
		}

		[Test(async)]
		public function testBuildClassWithSimplePropertyWithStaticInitializerOnDifferentClass():void {
			var handler:Function = function (event:Event, data:*):void {
				_staticWasCalled = false;
				var cls:Class = ApplicationDomain.currentDomain.getDefinition("com.myclasses.test.MySimplePropertyTestWithStaticInitializerClassOnDifferentClass") as Class;
				assertNotNull(cls);
				var instance:Object = new cls();
				assertEquals("testValue", instance.testString);
				assertTrue(_staticWasCalled);
			};

			var classBuilder:IClassBuilder = _abcBuilder.definePackage("com.myclasses.test").defineClass("MySimplePropertyTestWithStaticInitializerClassOnDifferentClass");
			var propertyBuilder:IPropertyBuilder = classBuilder.defineProperty("testString", "String");
			propertyBuilder.memberInitialization = new MemberInitialization();
			propertyBuilder.memberInitialization.factoryMethodName = "org.as3commons.bytecode.emit.impl.AbcBuilderTest.createString";
			_abcBuilder.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handler, 5000), false, 0, true);
			_abcBuilder.buildAndLoad();
		}

		public static function createString():String {
			_staticWasCalled = true;
			return "testValue";
		}

		[Test(async)]
		public function testBuildClassWithComplexProperty():void {
			var handler:Function = function (event:Event, data:*):void {
				var cls:Class = ApplicationDomain.currentDomain.getDefinition("com.myclasses.test.MyComplexPropertyTest") as Class;
				assertNotNull(cls);
				var instance:Object = new cls();
				assertNotNull(instance);
				assertNull(instance.testObject);
				var evt:Event = new Event("test");
				instance.testObject = evt;
				assertNotNull(instance.testObject);
				assertStrictlyEquals(evt, instance.testObject);
			};

			var classBuilder:IClassBuilder = _abcBuilder.definePackage("com.myclasses.test").defineClass("MyComplexPropertyTest");
			classBuilder.defineProperty("testObject", "flash.events.Event");
			_abcBuilder.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handler, 5000), false, 0, true);
			_abcBuilder.buildAndLoad();
		}

		[Test(async)]
		public function testBuildClassWithPropertyInitializations():void {
			var handler:Function = function (event:Event, data:*):void {
				var cls:Class = ApplicationDomain.currentDomain.getDefinition("com.myclasses.test.MyPropertyInitializationTest") as Class;
				assertNotNull(cls);
				var instance:Object = new cls();
				assertNotNull(instance);
				assertNotNull(instance.testObject);
				var event2:Event = instance.testObject as Event;
				assertNotNull(event2);
				assertEquals("myEventType", event2.type);
				assertTrue(event2.bubbles);
				assertTrue(event2.cancelable);
			};

			var classBuilder:IClassBuilder = _abcBuilder.definePackage("com.myclasses.test").defineClass("MyPropertyInitializationTest");
			var propertyBuilder:IPropertyBuilder = classBuilder.defineProperty("testObject", "flash.events.Event");
			propertyBuilder.memberInitialization = new MemberInitialization();
			propertyBuilder.memberInitialization.constructorArguments = ["myEventType", true, true];
			_abcBuilder.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handler, 5000), false, 0, true);
			_abcBuilder.buildAndLoad();
		}

		[Test(async)]
		public function testBuildClassWithPropertyWithGeneratedNamespaceScope():void {
			var handler:Function = function (event:Event, data:*):void {
				var cls:Class = ApplicationDomain.currentDomain.getDefinition("com.myclasses.test.MyCustomNamespacePropertyTest") as Class;
				assertNotNull(cls);
				var instance:Object = new cls();
				assertNotNull(instance);
				var qn:QName = new QName("http://www.test.com/mytestnamespace", "testObject");
				assertNull(instance[qn]);
				var evt:Event = new Event("test");
				instance[qn] = evt;
				assertStrictlyEquals(evt, instance[qn]);
			};

			_abcBuilder.definePackage("com.myclasses.test").defineNamespace("my_namespace_test", "http://www.test.com/mytestnamespace");
			var classBuilder:IClassBuilder = _abcBuilder.definePackage("com.myclasses.test").defineClass("MyCustomNamespacePropertyTest");
			var propertyBuilder:IPropertyBuilder = classBuilder.defineProperty("testObject", "flash.events.Event");
			propertyBuilder.scopeName = "my_namespace_test";
			propertyBuilder.namespaceURI = "http://www.test.com/mytestnamespace";
			_abcBuilder.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handler, 5000), false, 0, true);
			_abcBuilder.buildAndLoad();
		}

		[Test(async)]
		public function testBuildClassWithMethodThatReturnsString():void {
			var classBuilder:IClassBuilder = _abcBuilder.definePackage("com.myclasses.test").defineClass("MyMethodTest1");
			var methodBuilder:IMethodBuilder = classBuilder.defineMethod();
			methodBuilder.name = "testMe";
			methodBuilder.returnType = "String";
			methodBuilder.addOpcode(Opcode.getlocal_0);
			methodBuilder.addOpcode(Opcode.pushscope);
			methodBuilder.addOpcode(Opcode.pushstring, ["testReturnString"]);
			methodBuilder.addOpcode(Opcode.returnvalue);

			var handler:Function = function (event:Event, data:*):void {
				var cls:Class = ApplicationDomain.currentDomain.getDefinition("com.myclasses.test.MyMethodTest1") as Class;
				assertNotNull(cls);
				var instance:Object = new cls();
				assertNotNull(instance);
				var result:String = instance.testMe();
				assertEquals("testReturnString", result);
			};

			_abcBuilder.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handler, 5000), false, 0, true);
			_abcBuilder.buildAndLoad();
		}

		[Test(async)]
		public function testBuildClassWithCustomNameSpacedProperty():void {
			var classBuilder:IClassBuilder = _abcBuilder.definePackage("com.myclasses.test").defineClass("MyCustomNamespacedPropertyClass");
			var propertyBuilder:IPropertyBuilder = classBuilder.defineProperty("nameSpacedProperty", "Object");
			propertyBuilder.namespaceURI = as3commons_bytecode_proxy;
			propertyBuilder.memberInitialization = new MemberInitialization();

			var handler:Function = function (event:Event, data:*):void {
				var cls:Class = ApplicationDomain.currentDomain.getDefinition("com.myclasses.test.MyCustomNamespacedPropertyClass") as Class;
				assertNotNull(cls);
				var instance:Object = new cls();
				assertNotNull(instance);
				var result:Object = instance.as3commons_bytecode_proxy::nameSpacedProperty;
				assertNotNull(result);
			};

			_abcBuilder.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handler, 5000), false, 0, true);
			_abcBuilder.buildAndLoad();
		}

		[Test(async)]
		public function testBuildClassWithMethodThatReturnsInt_0():void {
			doTestBuildClassWithMethodThatReturnsInt(0, Opcode.pushbyte);
		}

		[Test(async)]
		public function testBuildClassWithMethodThatReturnsInt_1():void {
			doTestBuildClassWithMethodThatReturnsInt(1, Opcode.pushbyte);
		}

		[Test(async)]
		public function testBuildClassWithMethodThatReturnsInt_negative1():void {
			doTestBuildClassWithMethodThatReturnsInt(-1, Opcode.pushbyte);
		}

		[Test(async)]
		public function testBuildClassWithMethodThatReturnsInt_negative128():void {
			doTestBuildClassWithMethodThatReturnsInt(-128, Opcode.pushbyte);
		}

		[Test(async)]
		public function testBuildClassWithMethodThatReturnsInt_negative129():void {
			doTestBuildClassWithMethodThatReturnsInt(-129, Opcode.pushshort);
		}

		[Test(async)]
		public function testBuildClassWithMethodThatReturnsInt_127():void {
			doTestBuildClassWithMethodThatReturnsInt(127, Opcode.pushbyte);
		}

		[Test(async)]
		public function testBuildClassWithMethodThatReturnsInt_128():void {
			doTestBuildClassWithMethodThatReturnsInt(128, Opcode.pushshort);
		}

		[Test(async)]
		public function testBuildClassWithMethodThatReturnsInt_32767():void {
			doTestBuildClassWithMethodThatReturnsInt(32767, Opcode.pushshort);
		}

		[Test(async)]
		public function testBuildClassWithMethodThatReturnsInt_32768():void {
			doTestBuildClassWithMethodThatReturnsInt(32768, Opcode.pushint);
		}

		[Test(async)]
		public function testBuildClassWithMethodThatReturnsInt_2147483647():void {
			doTestBuildClassWithMethodThatReturnsInt(2147483647, Opcode.pushint);
		}

		[Test(async)]
		public function testBuildClassWithMethodThatReturnsInt_2147483648():void {
			doTestBuildClassWithMethodThatReturnsInt(2147483648, Opcode.pushdouble);
		}

		private function doTestBuildClassWithMethodThatReturnsInt(value:int, opcode:Opcode):void {
			var abcBuilder:AbcBuilder = new AbcBuilder();
			var className:String = generateRandomClassName();
			var classBuilder:IClassBuilder = abcBuilder.definePackage("com.myclasses.test").defineClass(className);
			var methodBuilder:IMethodBuilder = classBuilder.defineMethod();
			methodBuilder.name = "testMe";
			methodBuilder.returnType = "int";
			methodBuilder.addOpcode(Opcode.getlocal_0);
			methodBuilder.addOpcode(Opcode.pushscope);
			methodBuilder.addOpcode(opcode, [value]);
			methodBuilder.addOpcode(Opcode.returnvalue);

			var handler:Function = function (event:Event, data:*):void {
				var cls:Class = ApplicationDomain.currentDomain.getDefinition("com.myclasses.test." + className) as Class;
				assertNotNull(cls);
				var instance:Object = new cls();
				assertNotNull(instance);
				var result:int = instance.testMe();
				assertEquals(data, result);
			};

			abcBuilder.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handler, 5000, value), false, 0, true);
			abcBuilder.buildAndLoad();
		}

		[Test(async)]
		public function testBuildClassWithMethodThatReturnsUint_0():void {
			doTestBuildClassWithMethodThatReturnsUint(0);
		}

		[Test(async)]
		public function testBuildClassWithMethodThatReturnsUint_1():void {
			doTestBuildClassWithMethodThatReturnsUint(1);
		}

		private function doTestBuildClassWithMethodThatReturnsUint(value:uint):void {
			var abcBuilder:AbcBuilder = new AbcBuilder();
			var className:String = "MyClass" + Math.round(Math.random() * 100000);
			var classBuilder:IClassBuilder = abcBuilder.definePackage("com.myclasses.test").defineClass(className);
			var methodBuilder:IMethodBuilder = classBuilder.defineMethod();
			methodBuilder.name = "testMe";
			methodBuilder.returnType = "uint";
			methodBuilder.addOpcode(Opcode.getlocal_0);
			methodBuilder.addOpcode(Opcode.pushscope);
			methodBuilder.addOpcode(Opcode.pushbyte, [value]);
			methodBuilder.addOpcode(Opcode.returnvalue);

			var handler:Function = function (event:Event, data:*):void {
				var cls:Class = ApplicationDomain.currentDomain.getDefinition("com.myclasses.test." + className) as Class;
				assertNotNull(cls);
				var instance:Object = new cls();
				assertNotNull(instance);
				var result:uint = instance.testMe();
				assertEquals(data, result);
			};

			abcBuilder.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handler, 5000, value), false, 0, true);
			abcBuilder.buildAndLoad();
		}

		[Test(async)]
		public function testBuildClassWithMethodThatReturnsDouble():void {
			var handler:Function = function methodBuildSuccessHandler4(event:Event, data:*):void {
				var cls:Class = ApplicationDomain.currentDomain.getDefinition("com.myclasses.test.MyMethodTest4") as Class;
				assertNotNull(cls);
				var instance:Object = new cls();
				assertNotNull(instance);
				var result:Number = instance.testMe();
				assertEquals(0, result);
			};

			var classBuilder:IClassBuilder = _abcBuilder.definePackage("com.myclasses.test").defineClass("MyMethodTest4");
			var methodBuilder:IMethodBuilder = classBuilder.defineMethod();
			methodBuilder.name = "testMe";
			methodBuilder.returnType = "Number";
			methodBuilder.addOpcode(Opcode.getlocal_0);
			methodBuilder.addOpcode(Opcode.pushscope);
			methodBuilder.addOpcode(Opcode.pushdouble, [0]);
			methodBuilder.addOpcode(Opcode.returnvalue);
			_abcBuilder.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handler, 5000), false, 0, true);
			_abcBuilder.buildAndLoad();
		}

		[Test(async)]
		public function testBuildInterfaceWithCustomNameSpacedProperty():void {
			var interfaceBuilder:IInterfaceBuilder = _abcBuilder.definePackage("com.myclasses.test").defineInterface("IMyCustomNamespacedMethodInterface");
			interfaceBuilder.defineMethod("nameSpacedMethod");

			var handler:Function = function (event:Event, data:*):void {
				var cls:Class = Type.currentApplicationDomain.getDefinition("com.myclasses.test.IMyCustomNamespacedMethodInterface") as Class;
				assertNotNull(cls);
				assertTrue(ClassUtils.isInterface(cls));
			};

			_abcBuilder.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handler, 5000), false, 0, true);
			_abcBuilder.buildAndLoad();
		}

		[Test(async)]
		public function testBuildClassReadOnlyAccessor():void {
			var handler:Function = function readOnlyAccessorBuildSuccessHandler(event:Event, data:*):void {
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
			};

			var classBuilder:IClassBuilder = _abcBuilder.definePackage("com.myclasses.test").defineClass("MyReadOnlyAccessorTest");
			var accessorBuilder:IAccessorBuilder = classBuilder.defineAccessor("testAccessor", "String", "test");
			accessorBuilder.access = AccessorAccess.READ_ONLY;
			_abcBuilder.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handler, 5000), false, 0, true);
			_abcBuilder.buildAndLoad();
		}

		[Test(async)]
		public function testBuildClassWriteOnlyAccessor():void {
			var handler:Function = function (event:Event, data:*):void {
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
			};

			var classBuilder:IClassBuilder = _abcBuilder.definePackage("com.myclasses.test").defineClass("MyWriteOnlyAccessorTest");
			var accessorBuilder:IAccessorBuilder = classBuilder.defineAccessor("testAccessor", "String");
			accessorBuilder.access = AccessorAccess.WRITE_ONLY;
			_abcBuilder.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handler, 5000), false, 0, true);
			_abcBuilder.buildAndLoad();
		}

		[Test(async)]
		public function testBuildClassReadWriteAccessor():void {
			var handler:Function = function readWriteAccessorBuildSuccessHandler(event:Event, data:*):void {
				var cls:Class = ApplicationDomain.currentDomain.getDefinition("com.myclasses.test.MyReadWriteAccessorTest") as Class;
				assertNotNull(cls);
				var instance:Object = new cls();
				assertNotNull(instance);
				assertEquals("test", instance.testAccessor);
				instance.testAccessor = "test1";
				assertEquals("test1", instance.testAccessor);
			};

			var classBuilder:IClassBuilder = _abcBuilder.definePackage("com.myclasses.test").defineClass("MyReadWriteAccessorTest");
			classBuilder.defineAccessor("testAccessor", "String", "test");
			_abcBuilder.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handler, 5000), false, 0, true);
			_abcBuilder.buildAndLoad();
		}

		[Test(async)]
		public function testBuildClassWithMethodThatUsesUint():void {
			var handler:Function = function (event:Event, data:*):void {
				var cls:Class = ApplicationDomain.currentDomain.getDefinition("com.myclasses.test.MyClassWithMethodThatUsesUintTest") as Class;
				assertNotNull(cls);
				var instance:Object = new cls();
				assertNotNull(instance);
				var nr:uint = 4294967295;
				var result:uint = instance.testUintMethod(nr);
				assertEquals(0, result);
				assertEquals("int", getQualifiedClassName(result));
			};

			var classBuilder:IClassBuilder = _abcBuilder.definePackage("com.myclasses.test").defineClass("MyClassWithMethodThatUsesUintTest");
			var methodBuilder:IMethodBuilder = classBuilder.defineMethod("testUintMethod");
			methodBuilder.returnType = "uint";
			var arg:MethodArgument = new MethodArgument();
			arg.type = "uint";
			methodBuilder.arguments.push(arg);
			methodBuilder.addOpcode(Opcode.getlocal_0).addOpcode(Opcode.pushscope);
			methodBuilder.addOpcode(Opcode.pushuint, [4294967295]);
			methodBuilder.addOpcode(Opcode.setlocal_2);
			methodBuilder.addOpcode(Opcode.getlocal_2);
			methodBuilder.addOpcode(Opcode.getlocal_1);
			methodBuilder.addOpcode(Opcode.subtract);
			methodBuilder.addOpcode(Opcode.convert_u);
			methodBuilder.addOpcode(Opcode.returnvalue);
			_abcBuilder.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handler, 5000), false, 0, true);
			_abcBuilder.buildAndLoad();
		}

		private static function generateRandomClassName():String {
			return "MyClass" + Math.round(Math.random() * 100000);
		}

	}
}
