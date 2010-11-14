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
	import flash.utils.describeType;

	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.enum.BuiltIns;
	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.bytecode.typeinfo.ClassDefinition;

	public class ClassGenerator {
		public function ClassGenerator() {
		}

		/**
		 * The limitations with this will be that it will not be able to see custom namespace functions
		 * and will not be able to introspect private/internal methods and properties. It also will not
		 * be able to determine the optional values of method arguments.
		 */
		public function generateProxy(clazz:Class):ClassDefinition {
			var classDef:ClassDefinition = new ClassDefinition();

			var typeXml:XML = describeType(clazz);

//			<type name="assets.abc::FullClassDefinition" base="Class" isDynamic="true" isFinal="true" isStatic="true">
//			  <extendsClass type="Class"/>
//			  <extendsClass type="Object"/>
//			  <method name="staticMethod" declaredBy="assets.abc::FullClassDefinition" returnType="void"/>
//			  <constant name="PUBLIC_STATIC_CONSTANT" type="String"/>
//			  <accessor name="prototype" access="readonly" type="*" declaredBy="Class"/>
//			  <factory type="assets.abc::FullClassDefinition">
//			    <metadata name="ClassMetadata">
//			      <arg key="classKey1" value="classValue1"/>
//			      <arg key="classKey2" value="classValue2"/>
//			      <arg key="classKey3" value="classValue3"/>
//			    </metadata>
//			    <extendsClass type="Object"/>
//			    <implementsInterface type="assets.abc::Interface"/>
//			    <method name="methodWithTwoArguments" declaredBy="assets.abc::FullClassDefinition" returnType="void">
//			      <parameter index="1" type="String" optional="false"/>
//			      <parameter index="2" type="int" optional="false"/>
//			    </method>
//			    <method name="methodWithOptionalArguments" declaredBy="assets.abc::FullClassDefinition" returnType="void">
//			      <parameter index="1" type="String" optional="false"/>
//			      <parameter index="2" type="String" optional="true"/>
//			      <parameter index="3" type="int" optional="true"/>
//			    </method>
//			    <accessor name="setterForInternalValue" access="writeonly" type="String" declaredBy="assets.abc::FullClassDefinition"/>
//			    <method name="customNamespaceFunction" declaredBy="assets.abc::FullClassDefinition" returnType="void" uri="http://www.maximporges.com"/>
//			    <method name="methodWithRestArguments" declaredBy="assets.abc::FullClassDefinition" returnType="void">
//			      <parameter index="1" type="String" optional="false"/>
//			    </method>
//			    <method name="methodWithNoArguments" declaredBy="assets.abc::FullClassDefinition" returnType="void">
//			      <metadata name="MethodMetadata">
//			        <arg key="methodKey1" value="methodValue1"/>
//			        <arg key="methodKey2" value="methodValue2"/>
//			      </metadata>
//			    </method>
//			    <method name="implementMeOrDie" declaredBy="assets.abc::FullClassDefinition" returnType="void"/>
//			    <accessor name="getterForInternalValue" access="readonly" type="String" declaredBy="assets.abc::FullClassDefinition"/>
//			  </factory>
//			</type>

			var className:String = typeXml.@name;
			classDef.className = MultinameUtil.toQualifiedName(className);

			var superClassName:String = typeXml.factory.extendsClass.@type;
			classDef.superClass = MultinameUtil.toQualifiedName(superClassName);

			var methods:XMLList = typeXml.factory.method;
			for each (var method:XML in methods) {
//            	classDef.addMethod(
				// There is no way to determine the optional parameter values without parsing the opcodes; it's not in the describeType output
				trace(method.parameter);
			}

			// TODO: Fields and properties

			return classDef;
		}

	}
}