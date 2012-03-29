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
package org.as3commons.bytecode.swf {
	import org.flexunit.asserts.assertTrue;

	public class AbcClassLoaderTest {

		public function AbcClassLoaderTest() {

		}

		[Test]
		public function testDummy():void {
			assertTrue(true);
		}

		/*[Test] public function testLoadClassDefinitionsFromBytecode():void {
		 var fixture:AbcClassLoader = new AbcClassLoader();
		 var qualifiedNamesOfExpectedClassDefinitions:Array = ["assets.abc::Interface", "assets.abc::FullClassDefinition"];

		 // Assert that the class definitions we are attempting to load are not already on the classpath
		 for each (var qualifiedName:String in qualifiedNamesOfExpectedClassDefinitions) {
		 try {
		 getDefinitionByName(qualifiedName);
		 fail("Class definition for " + qualifiedName + " already present in AS classpath.");
		 } catch (e:Error) { // expected
		 }
		 }

		 var interfaceByteCode:ByteArray = TestConstants.getInterfaceDefinitionByteCode();
		 var fullClassDefinitionByteCode:ByteArray = TestConstants.getFullClassDefinitionByteCode();

		 var successHandler : Function =
		 function (event : Event, passThroughData : Object) : void
		 {
		 for each (var qualifiedName : String in qualifiedNamesOfExpectedClassDefinitions)
		 {
		 var clazz : * = getDefinitionByName(qualifiedName);
		 assertNotNull(clazz);
		 assertEquals(qualifiedName, getQualifiedClassName(clazz));
		 }

		 // Play with the loaded class definitions a little :)
		 var fullClassDefinitionClassRef : * = getDefinitionByName("assets.abc.FullClassDefinition");
		 assertEquals("PUBLIC_STATIC_CONSTANT", fullClassDefinitionClassRef.PUBLIC_STATIC_CONSTANT);

		 var fullClassDefinitionInstance : * = new fullClassDefinitionClassRef();
		 assertEquals(void, fullClassDefinitionInstance.methodWithNoArguments());
		 };

		 fixture.addEventListener(Event.COMPLETE, Async.asyncHandler( this, successHandler, 5000));

		 //NOTE: Order of bytecode blocks significant here. The interface must be loaded before the class definition, since this class implements the interface
		 fixture.loadClassDefinitionsFromBytecode([interfaceByteCode, fullClassDefinitionByteCode]);
		 }*/
	}
}