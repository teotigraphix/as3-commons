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
	import flash.system.ApplicationDomain;



	import org.as3commons.bytecode.abc.ClassInfo;
	import org.as3commons.bytecode.abc.InstanceInfo;
	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.MethodBody;
	import org.as3commons.bytecode.abc.MethodInfo;
	import org.as3commons.bytecode.abc.MethodTrait;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.SlotOrConstantTrait;
	import org.as3commons.bytecode.abc.TraitInfo;
	import org.as3commons.bytecode.abc.enum.MultinameKind;
	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.bytecode.as3commons_bytecode;
	import org.as3commons.bytecode.emit.ICtorBuilder;
	import org.as3commons.bytecode.emit.IPropertyBuilder;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertStrictlyEquals;

	public class ClassBuilderTest {

		private var _classBuilder:ClassBuilder;

		public function ClassBuilderTest() {

		}

		[Before]
		public function setUp():void {
			_classBuilder = new ClassBuilder();
		}

		[Test] public function testDefineConstructorWithExistingInstance():void {
			var instanceInfo:InstanceInfo = new InstanceInfo();
			instanceInfo.superclassMultiname = new QualifiedName("supertest", new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, "com.classes"), MultinameKind.QNAME);
			instanceInfo.classMultiname = new QualifiedName("test", new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, "com.classes"), MultinameKind.QNAME);
			instanceInfo.instanceInitializer = new MethodInfo();
			instanceInfo.instanceInitializer.methodBody = new MethodBody();
			instanceInfo.instanceInitializer.as3commonsByteCodeAssignedMethodTrait = new MethodTrait();
			instanceInfo.instanceInitializer.methodName = "test/test()";
			var traitMultiname:QualifiedName = new QualifiedName("testmethod", new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, "com.classes"));
			instanceInfo.instanceInitializer.as3commonsByteCodeAssignedMethodTrait.traitMultiname = traitMultiname;

			var classInfo:ClassInfo = new ClassInfo();
			classInfo.classMultiname = instanceInfo.classMultiname;
			instanceInfo.classInfo = classInfo;

			_classBuilder.as3commons_bytecode::setInstanceInfo(instanceInfo);
			_classBuilder.as3commons_bytecode::setClassInfo(classInfo);

			var cb:ICtorBuilder = _classBuilder.defineConstructor();
			var instInit:MethodInfo = instanceInfo.instanceInitializer;
			var methodTrait:TraitInfo = instanceInfo.instanceInitializer.as3commonsByteCodeAssignedMethodTrait;

			var arr:Array = _classBuilder.build(ApplicationDomain.currentDomain);
			var cls:ClassInfo = arr[0];
			var inst:InstanceInfo = arr[1];

			assertStrictlyEquals(inst, instanceInfo);
			assertStrictlyEquals(inst.instanceInitializer, instInit);
			assertStrictlyEquals(inst.instanceInitializer.as3commonsByteCodeAssignedMethodTrait, methodTrait);
			assertStrictlyEquals(inst.instanceInitializer.as3commonsByteCodeAssignedMethodTrait.traitMultiname, methodTrait.traitMultiname);

			assertStrictlyEquals(cls, classInfo);
			assertStrictlyEquals(cls.classMultiname, instanceInfo.classMultiname);
			assertStrictlyEquals(cls, instanceInfo.classInfo);
		}

		[Test] public function testBuildWithExistingClassInfo():void {
			var classInfo:ClassInfo = new ClassInfo();
			classInfo.classMultiname = new QualifiedName("test", new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, "com.classes"), MultinameKind.QNAME);
			classInfo.staticInitializer = new MethodInfo();
			classInfo.staticInitializer.methodBody = new MethodBody();
			classInfo.staticInitializer.as3commonsByteCodeAssignedMethodTrait = new MethodTrait();
			classInfo.staticInitializer.as3commonsByteCodeAssignedMethodTrait.traitMultiname = new QualifiedName("test", new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, "com.classes"), MultinameKind.QNAME);
			classInfo.staticInitializer.methodName = "test/cinit()";
			_classBuilder.as3commons_bytecode::setClassInfo(classInfo);

			var arr:Array = _classBuilder.build(ApplicationDomain.currentDomain);
			var cls:ClassInfo = arr[0];
			assertStrictlyEquals(cls, classInfo);
			assertStrictlyEquals(cls.staticInitializer, classInfo.staticInitializer);
			assertStrictlyEquals(cls.staticInitializer.as3commonsByteCodeAssignedMethodTrait, classInfo.staticInitializer.as3commonsByteCodeAssignedMethodTrait);
		}

		[Test] public function testDefineExistingProperty():void {
			var instanceInfo:InstanceInfo = new InstanceInfo();
			instanceInfo.superclassMultiname = new QualifiedName("supertest", new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, "com.classes"), MultinameKind.QNAME);
			instanceInfo.classMultiname = new QualifiedName("test", new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, "com.classes"), MultinameKind.QNAME);
			instanceInfo.instanceInitializer = new MethodInfo();
			instanceInfo.instanceInitializer.methodBody = new MethodBody();
			instanceInfo.instanceInitializer.as3commonsByteCodeAssignedMethodTrait = new MethodTrait();
			var traitMultiname:QualifiedName = new QualifiedName("testmethod", new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, "com.classes"));
			instanceInfo.instanceInitializer.as3commonsByteCodeAssignedMethodTrait.traitMultiname = traitMultiname;
			instanceInfo.instanceInitializer.methodName = "test/test()";
			var slot:SlotOrConstantTrait = new SlotOrConstantTrait();
			slot.traitMultiname = new QualifiedName("testProperty", new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, "com.classes.test"));
			slot.typeMultiname = new QualifiedName("testPropType", new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, "com.classes.types"));
			instanceInfo.addTrait(slot);

			_classBuilder.as3commons_bytecode::setInstanceInfo(instanceInfo);

			var pb:IPropertyBuilder = _classBuilder.defineProperty("testProperty");

			assertEquals(pb.type, "com.classes.types.testPropType");

			var arr:Array = _classBuilder.build(ApplicationDomain.currentDomain);
			var inst:InstanceInfo = arr[1];

			assertStrictlyEquals(inst.traits[0], slot);
		}

	}
}