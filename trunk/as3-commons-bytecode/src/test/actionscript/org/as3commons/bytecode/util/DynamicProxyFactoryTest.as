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
	import assets.abc.FullClassDefinition;
	import assets.abc.custom_namespace;

	import flash.events.Event;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;

	import flexunit.framework.TestCase;

	import org.as3commons.bytecode.TestConstants;
	import org.as3commons.bytecode.abc.AbcFile;
	import org.as3commons.bytecode.abc.ClassInfo;
	import org.as3commons.bytecode.abc.InstanceInfo;
	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.MethodBody;
	import org.as3commons.bytecode.abc.MethodInfo;
	import org.as3commons.bytecode.abc.MethodTrait;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.ScriptInfo;
	import org.as3commons.bytecode.abc.SlotOrConstantTrait;
	import org.as3commons.bytecode.abc.enum.BuiltIns;
	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.bytecode.as3commons_bytecode;
	import org.as3commons.bytecode.typeinfo.Argument;
	import org.as3commons.bytecode.swf.AbcClassLoader;
	import org.as3commons.bytecode.template.BaseClass;
	import org.as3commons.bytecode.template.MethodInvocation;
	import org.as3commons.bytecode.template.SubClassOfSubClassOfSubClass;

	use namespace custom_namespace;

	public class DynamicProxyFactoryTest extends TestCase {
		// Convenience utility
//		public function testPrintFullClassDefinitionSubClass() : void
//		{
//			// As soon as the Loom-namespace getters and setters are added to FCDSubClass, the multiname error with the superclass name
//			// starts happening. Remove the loom namespace, recompile from the CL, refresh Eclipse, and run test again to see it go away. 
//			trace(new AbcDeserializer(TestConstants.getFullClassDefinitionSubClassByteCode()).deserialize());
//		}


		public function DynamicProxyFactoryTest(methodName:String = null) {
			super(methodName);
		}

		public function testDummy():void {
			assertTrue(true);
		}


	/**
	 * Tests to make sure that the appropriate changes are applied when subclasses of classes
	 * other than Object are created.
	 */
	/*public function testCreateSubClassOfSubClassOfSubClass():void {
	   var subclassName:String = "SubClassOfSubClassOfSubClass_RuntimeSubClass";
	   var proxyAS3QualifiedName:String = "loom.template::" + subclassName;

	   var classDefInMemory:Boolean = true;
	   try {
	   getDefinitionByName(proxyAS3QualifiedName);
	   } catch (e:Error) {
	   classDefInMemory = false;
	   }
	   assertFalse(classDefInMemory);

	   var abcFile:AbcFile = new AbcDeserializer(TestConstants.getSubClassOfSubClassOfSubClassTemplate()).deserialize();
	   new DynamicProxyFactory(abcFile).createProxy(subclassName);

	   var classLoader:AbcClassLoader = new AbcClassLoader();
	   classLoader.addEventListener(Event.COMPLETE, function(event:Event):void {
	   var classRef:* = getDefinitionByName(proxyAS3QualifiedName);
	   var instance:SubClassOfSubClassOfSubClass = new classRef(null, null);
	   assertTrue(instance is SubClassOfSubClassOfSubClass);
	   });

	   classLoader.loadClassDefinitionsFromBytecode([new AbcSerializer().serializeAbcFile(abcFile)]);
	 }*/

	/*public function testCreateProxyWithFullClassDefinition():void {
	   var subclassName:String = "FullClassDefinition_RuntimeSubClass";
	   var proxyAS3QualifiedName:String = "assets.abc::" + subclassName;

	   var classDefInMemory:Boolean = true;
	   try {
	   getDefinitionByName(proxyAS3QualifiedName);
	   } catch (e:Error) {
	   classDefInMemory = false;
	   }
	   assertFalse(classDefInMemory);

	   var proxyFile:AbcFile = new AbcDeserializer(TestConstants.getFullClassDefinitionByteCode()).deserialize();
	   var fixture:DynamicProxyFactory = new DynamicProxyFactory(proxyFile);
	   fixture.createProxy(subclassName);

	   var classLoader:AbcClassLoader = new AbcClassLoader();
	   classLoader.addEventListener(Event.COMPLETE, function(event:Event):void {
	   var classRef:* = getDefinitionByName(proxyAS3QualifiedName);
	   trace(describeType(classRef));

	   var instance:FullClassDefinition = new classRef();
	   assertTrue(instance is FullClassDefinition);

	   // Run through a series of tests for each method in this class

	   var valueToSet:String = "New Value";
	   instance.setterForInternalValue = valueToSet;
	   assertEquals(valueToSet, instance.getterForInternalValue);
	   //					instance.custom_namespace::setHandler("getterForInternalValue", function(invocation:MethodInvocation):* {
	   //   return "OverridenGetterValue";
	   //   });
	   //   assertEquals("OverridenGetterValue", instance.getterForInternalValue);
	   //
	   instance.implementMeOrDie();
	   instance.as3commons_bytecode::setHandler("implementMeOrDie", function(invocation:MethodInvocation):* {
	   assertEquals("implementMeOrDie", invocation.methodName);
	   });
	   instance.implementMeOrDie();

	   instance.methodWithTwoArguments("ArgumentOne", 10);
	   instance.as3commons_bytecode::setHandler("methodWithTwoArguments", function(invocation:MethodInvocation):* {
	   assertEquals("methodWithTwoArguments", invocation.methodName);
	   assertEquals(2, invocation.args.length);
	   assertEquals("ArgumentOne", invocation.args[0]);
	   assertEquals(10, invocation.args[1]);
	   });
	   instance.methodWithTwoArguments("ArgumentOne", 10);

	   instance.methodWithRestArguments("First", "Second", "Third", "Fourth");
	   instance.as3commons_bytecode::setHandler("methodWithRestArguments", function(invocation:MethodInvocation):* {
	   assertEquals("methodWithRestArguments", invocation.methodName);
	   assertEquals(2, invocation.args.length);
	   assertEquals("First", invocation.args[0]);
	   assertTrue(invocation.args[1] is Array);
	   assertEquals("Second", invocation.args[1][0]);
	   assertEquals("Third", invocation.args[1][1]);
	   assertEquals("Fourth", invocation.args[1][2]);
	   });
	   instance.methodWithRestArguments("First", "Second", "Third", "Fourth");

	   //TODO: Static methods can be called but cannot be advised
	   classRef.staticMethod();

	   //TODO: Custom namespace functions cannot be called, and don't show up in describeType output for proxy for some reason
	   // Looks like the namespace set for the multiname does not include the custom namespace, based upon this error
	   // ReferenceError: Error #1069: Property customNamespaceFunction not found on assets.abc.FullClassDefinition and there is no default value
	   // Since this is referencing the superclass, my guess is that the multiname that invokes this method does not have a reference to the
	   // custom namespace, which prevents the runtime from finding the call.
	   //                    instance.custom_namespace::customNamespaceFunction();
	   var fcd:FullClassDefinition = new FullClassDefinition();
	   fcd.custom_namespace::customNamespaceFunction();

	   instance.methodWithOptionalArguments("Required", "Optional");
	   instance.as3commons_bytecode::setHandler("methodWithOptionalArguments", function(invocation:MethodInvocation):* {
	   assertEquals("methodWithOptionalArguments", invocation.methodName);

	   // We should always get all the arguments due to the way Loom weaves the bytecode for NEED_OPTIONAL methods
	   assertEquals(3, invocation.args.length);
	   assertEquals("Required", invocation.args[0]);
	   assertEquals("Optional", invocation.args[1]);
	   assertEquals(10, invocation.args[2]);
	   });
	   instance.methodWithOptionalArguments("Required", "Optional");
	   });

	   trace(proxyFile);
	   classLoader.loadClassDefinitionsFromBytecode([new AbcSerializer().serializeAbcFile(proxyFile)]);
	 }*/

	/**
	 * Creates a proxy with loom.template.BaseClass and checks out its structure, then loads it
	 * in to the AVM and exercises its runtime behavior.
	 */
	/*public function testCreateProxyWithBaseClass():void {
	   var packageName:String = "loom.template";
	   var proxyClassName:String = "SomeRandomSubclass";
	   var proxyFullName:String = (packageName + ":" + proxyClassName);
	   var proxyAS3QualifiedName:String = packageName + "::" + proxyClassName;
	   var baseClassName:String = "BaseClass";
	   var baseClassFullName:String = (packageName + ":" + baseClassName);

	   // Assume the class definition is already in memory, although we don't want this to be the case
	   var classDefinitionAlreadyInMemory:Boolean = true;
	   try {
	   getDefinitionByName(proxyAS3QualifiedName);
	   } catch (e:Error) {
	   classDefinitionAlreadyInMemory = false;
	   // We expect an error from the dynamic subclass not being in the AVM yet
	   }
	   assertFalse(classDefinitionAlreadyInMemory);

	   // We enhance the loaded ABC file to save the work the compiler already did, and just add to/replace it
	   var proxyFile:AbcFile = new AbcDeserializer(TestConstants.getBaseClassTemplate()).deserialize();
	   var fixture:DynamicProxyFactory = new DynamicProxyFactory(proxyFile);
	   fixture.createProxy(proxyClassName);

	   // Get a reference to the instance info to run tests against
	   var proxyInstance:InstanceInfo = proxyFile.instanceInfo[0];

	   // Check the class and superclass names
	   assertTrue(proxyInstance.classMultiname.name, proxyClassName);
	   assertTrue(proxyInstance.classMultiname.nameSpace.name, packageName);
	   if (proxyInstance.superclassMultiname is QualifiedName) {
	   assertTrue(QualifiedName(proxyInstance.superclassMultiname).name, baseClassName);
	   assertTrue(QualifiedName(proxyInstance.superclassMultiname).nameSpace.name, packageName);
	   }

	   // Check the remaining instance properties protected namespace
	   assertTrue(new LNamespace(NamespaceKind.PROTECTED_NAMESPACE, proxyFullName).equals(proxyInstance.protectedNamespace));
	   assertEquals(true, proxyInstance.isProtected);
	   assertEquals(0, proxyInstance.interfaceCount);
	   assertEquals(0, proxyInstance.interfaceMultinames.length);

	   // Check format of constructor method signature and body
	   var constructor:MethodInfo = proxyInstance.constructor;
	   assertEquals("constructor", constructor.loomName);
	   assertEquals(2, constructor.argumentCollection.length);
	   assertTrue(BuiltIns.STRING.equals(Argument(constructor.argumentCollection[0]).type));
	   assertTrue(BuiltIns.STRING.equals(Argument(constructor.argumentCollection[1]).type));
	   assertTrue(BuiltIns.ANY.equals(constructor.returnType));
	   var constructorBody:MethodBody = constructor.methodBody;
	   assertEquals(3, constructorBody.maxStack);
	   assertEquals(3, constructorBody.localCount);
	   assertEquals(5, constructorBody.initScopeDepth);
	   assertEquals(6, constructorBody.maxScopeDepth);
	   assertEquals(11, constructorBody.opcodes.length);

	   // Check instance method traits
	   var loomNamespace:LNamespace = new LNamespace(NamespaceKind.NAMESPACE, "http://loom.ninjitsoft.com");
	   var expectedInstanceMethodNames:Array = ["methodCallOne", "methodCallTwo", "methodCallThree"];
	   var loomInstanceMethodNames:Array = ["setHandler", "proxyInvocation"];
	   var matchingInstanceNames:int = 0;
	   var matchingLoomNames:int = 0;
	   for each (var methodTrait:MethodTrait in proxyInstance.methodTraits) {
	   var isOriginalInstanceMethod:Boolean = expectedInstanceMethodNames.indexOf(methodTrait.traitMultiname.name) != -1;
	   var isLoomMethod:Boolean = loomInstanceMethodNames.indexOf(methodTrait.traitMultiname.name) != -1;
	   var instanceMethodBody:MethodBody = methodTrait.traitMethod.methodBody;

	   if (!isOriginalInstanceMethod && !isLoomMethod) {
	   fail("MethodTrait " + methodTrait + " is neither a Loom method nor an original instance method.");
	   }

	   // All the original methods should be present and overriden
	   if (isOriginalInstanceMethod) {
	   matchingInstanceNames++;
	   assertTrue(methodTrait.isOverride);

	   // Check the state of the method body based upon whether or not there is a return value
	   var methodReturnsValue:Boolean = methodTrait.traitMethod.returnType.equals(BuiltIns.VOID);
	   if (methodReturnsValue) {
	   assertEquals(6, instanceMethodBody.maxStack);
	   assertEquals(5, instanceMethodBody.localCount);
	   assertEquals(5, instanceMethodBody.initScopeDepth);
	   assertEquals(6, instanceMethodBody.maxScopeDepth);
	   assertEquals(13, instanceMethodBody.opcodes.length);
	   } else {
	   assertEquals(6, instanceMethodBody.maxStack);
	   assertEquals(4, instanceMethodBody.localCount);
	   assertEquals(5, instanceMethodBody.initScopeDepth);
	   assertEquals(6, instanceMethodBody.maxScopeDepth);
	   assertEquals(12, instanceMethodBody.opcodes.length);
	   }
	   }

	   // All the Loom methods should be Loom namespaced and not overriden
	   if (isLoomMethod) {
	   matchingLoomNames++;
	   assertTrue(loomNamespace.equals(methodTrait.traitMultiname.nameSpace));
	   assertFalse(methodTrait.isOverride);

	   if (methodTrait.traitMultiname.name == "proxyInvocation") {
	   //maxStack=3, localCount=3, initScopeDepth=5, maxScopeDepth=6, 22
	   assertEquals(3, instanceMethodBody.maxStack);
	   assertEquals(3, instanceMethodBody.localCount);
	   assertEquals(5, instanceMethodBody.initScopeDepth);
	   assertEquals(6, instanceMethodBody.maxScopeDepth);
	   assertEquals(22, instanceMethodBody.opcodes.length);
	   }

	   if (methodTrait.traitMultiname.name == "setHandler") {
	   //maxStack=3, localCount=3, initScopeDepth=5, maxScopeDepth=6, 8
	   assertEquals(3, instanceMethodBody.maxStack);
	   assertEquals(3, instanceMethodBody.localCount);
	   assertEquals(5, instanceMethodBody.initScopeDepth);
	   assertEquals(6, instanceMethodBody.maxScopeDepth);
	   assertEquals(8, instanceMethodBody.opcodes.length);
	   }
	   }
	   }
	   assertEquals(expectedInstanceMethodNames.length, matchingInstanceNames);
	   assertEquals(loomInstanceMethodNames.length, matchingLoomNames);

	   // Check instance slot for a reference to handlerMappings
	   var slotTraits:Array = proxyInstance.slotOrConstantTraits;
	   assertEquals(1, slotTraits.length);
	   var handlerMappingsSlotTrait:SlotOrConstantTrait = slotTraits[0];
	   assertTrue(loomNamespace.equals(handlerMappingsSlotTrait.traitMultiname.nameSpace));
	   assertEquals("handlerMappings", handlerMappingsSlotTrait.traitMultiname.name);
	   assertTrue(handlerMappingsSlotTrait.typeMultiname.equals(BuiltIns.DICTIONARY));

	   // Validate the state of the static initializer
	   var classInfo:ClassInfo = proxyFile.classInfo[0];
	   var staticInitializer:MethodBody = classInfo.staticInitializer.methodBody;
	   assertEquals(1, staticInitializer.maxStack);
	   assertEquals(1, staticInitializer.localCount);
	   assertEquals(4, staticInitializer.initScopeDepth);
	   assertEquals(5, staticInitializer.maxScopeDepth);
	   assertEquals(3, staticInitializer.opcodes.length);

	   // Validate the state of the script initializer
	   var scriptInfo:ScriptInfo = proxyFile.scriptInfo[0];
	   var scriptInitializer:MethodBody = scriptInfo.scriptInitializer.methodBody;
	   assertEquals(2, scriptInitializer.maxStack);
	   assertEquals(1, scriptInitializer.localCount);
	   assertEquals(1, scriptInitializer.initScopeDepth);
	   assertEquals(3, scriptInitializer.maxScopeDepth);
	   assertEquals(12, scriptInitializer.opcodes.length);

	   // Final test... load the class and see if the AVM likes it, then check out its behavior as a runtime instance
	   var classLoader:AbcClassLoader = new AbcClassLoader();
	   classLoader.addEventListener(Event.COMPLETE, function(event:Event):void {
	   var classRef:* = getDefinitionByName(proxyAS3QualifiedName);
	   trace(describeType(classRef));

	   // This would blow up if the types are not compatible
	   var instance:BaseClass = new classRef(null, null);
	   assertTrue(instance is BaseClass); // redundant, yet satisfying :)

	   // Run original method invocation, which returns 100
	   assertEquals(100, instance.methodCallOne("Hello Original Method Invocation!", -1));
	   trace(">>> Original method invocation");
	   trace(instance.methodCallOne("Hello Original Method Invocation!", -1));

	   // Set up a handler
	   var handler:Function = function(invocation:MethodInvocation):* {
	   trace("Before advice for: " + invocation);

	   try {
	   return 123;
	   } catch (e:Error) {
	   trace("Throws advice for: " + e);
	   } finally {
	   trace("After advice for: " + invocation);
	   }
	   };
	   instance.as3commons_bytecode::setHandler("methodCallOne", handler);
	   assertEquals(handler, instance.as3commons_bytecode::handlerMappings["methodCallOne"]);
	   assertEquals(123, instance.methodCallOne("Hello Dynamic Method Invocation!", -1));
	   trace(">>> AOP method invocation");
	   trace(instance.methodCallOne("Hello Dynamic Method Invocation!", 1234));
	   });

	   // Load in the proxied class definition. If anything is out of whack you will find out about it here
	   // since the AVM verifies as a first step (look for VerifyErrors)
	   classLoader.loadClassDefinitionsFromBytecode([new AbcSerializer().serializeAbcFile(proxyFile)]);
	 }*/
	}
}