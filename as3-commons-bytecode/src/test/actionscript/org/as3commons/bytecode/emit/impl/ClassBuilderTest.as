package org.as3commons.bytecode.emit.impl {
	import flash.system.ApplicationDomain;

	import flexunit.framework.TestCase;

	import org.as3commons.bytecode.abc.BaseMultiname;
	import org.as3commons.bytecode.abc.InstanceInfo;
	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.MethodInfo;
	import org.as3commons.bytecode.abc.MethodTrait;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.enum.MultinameKind;
	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.bytecode.as3commons_bytecode;
	import org.as3commons.bytecode.emit.IClassBuilder;

	public class ClassBuilderTest extends TestCase {

		private var _classBuilder:ClassBuilder;

		public function ClassBuilderTest(methodName:String = null) {
			super(methodName);
		}

		override public function setUp():void {
			super.setUp();
			_classBuilder = new ClassBuilder();
		}

		/*public function testBuild():void {
			fail("Test method Not yet implemented");
		}*/

		public function testDefineConstructorWithExistingInstance():void {
			var instanceInfo:InstanceInfo = new InstanceInfo();
			instanceInfo.superclassMultiname = new QualifiedName("supertest", new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, "com.classes"), MultinameKind.QNAME);
			instanceInfo.classMultiname = new QualifiedName("test", new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, "com.classes"), MultinameKind.QNAME);
			instanceInfo.instanceInitializer = new MethodInfo();
			instanceInfo.instanceInitializer.as3commonsByteCodeAssignedMethodTrait = new MethodTrait();
			var traitMultiname:QualifiedName = new QualifiedName("testmethod", new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, "com.classes"));
			instanceInfo.instanceInitializer.as3commonsByteCodeAssignedMethodTrait.traitMultiname = traitMultiname;
			_classBuilder.as3commons_bytecode::setInstanceInfo(instanceInfo);
			var arr:Array = _classBuilder.build(ApplicationDomain.currentDomain);
			assertStrictlyEquals(arr[1], instanceInfo);
		}

	/*public function testDefineProperty():void {
		fail("Test method Not yet implemented");
	}

	public function testImplementInterface():void {
		fail("Test method Not yet implemented");
	}

	public function testImplementInterfaces():void {
		fail("Test method Not yet implemented");
	}*/
	}
}