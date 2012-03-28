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
package org.as3commons.bytecode.util {

	import org.as3commons.bytecode.abc.MultinameG;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;

	public class MultinameUtilTest {

		public function MultinameUtilTest() {
		}

		[Test]
		public function testToArgumentMultiNameWithRegularClassNameWithoutColons():void {
			var className:String = "com.myclasses.MyClass";
			var qualifiedName:QualifiedName = MultinameUtil.toArgumentMultiName(className) as QualifiedName;
			assertNotNull(qualifiedName);
			assertEquals("MyClass", qualifiedName.name);
			assertEquals("com.myclasses", qualifiedName.nameSpace.name);
		}

		[Test]
		public function testToArgumentMultiNameWithRegularClassNameWithColons():void {
			var className:String = "com.myclasses::MyClass";
			var qualifiedName:QualifiedName = MultinameUtil.toArgumentMultiName(className) as QualifiedName;
			assertNotNull(qualifiedName);
			assertEquals("MyClass", qualifiedName.name);
			assertEquals("com.myclasses", qualifiedName.nameSpace.name);
		}

		[Test]
		public function testToArgumentMultiNameWithVectorClassNameWithoutColons():void {
			var className:String = "com.myclasses.MyClass.<String>";
			var genericName:MultinameG = MultinameUtil.toArgumentMultiName(className) as MultinameG;
			assertNotNull(genericName);
			assertEquals("MyClass", genericName.qualifiedName.name);
			assertEquals("com.myclasses", genericName.qualifiedName.nameSpace.name);
			assertEquals(1, genericName.paramCount);
			assertEquals("String", QualifiedName(genericName.parameters[0]).name);
		}

		[Test]
		public function testToArgumentMultiNameWithVectorClassNameWithColons():void {
			var className:String = "com.myclasses::MyClass.<String>";
			var genericName:MultinameG = MultinameUtil.toArgumentMultiName(className) as MultinameG;
			assertNotNull(genericName);
			assertEquals("MyClass", genericName.qualifiedName.name);
			assertEquals("com.myclasses", genericName.qualifiedName.nameSpace.name);
			assertEquals(1, genericName.paramCount);
			assertEquals("String", QualifiedName(genericName.parameters[0]).name);
		}

	}
}