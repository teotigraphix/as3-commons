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

	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	import flexunit.framework.TestCase;

	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.enum.BuiltIns;
	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.bytecode.typeinfo.ClassDefinition;

	public class ClassGeneratorTest extends TestCase {
		private var _fixture:ClassGenerator;


		public function ClassGeneratorTest(methodName:String = null) {
			super(methodName);
		}

		override public function setUp():void {
			_fixture = new ClassGenerator();
		}

		public function testGenerateProxy():void {
			var baseClassClass:Class = getDefinitionByName(getQualifiedClassName(FullClassDefinition)) as Class;
			var definition:ClassDefinition = _fixture.generateProxy(baseClassClass);

			assertTrue(new QualifiedName("FullClassDefinition", new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, "assets.abc")).equals(definition.className));
			//assertEquals(BuiltIns.OBJECT, definition.superClass);
			assertEquals(BuiltIns.OBJECT, definition.superClass);
		}
	}
}