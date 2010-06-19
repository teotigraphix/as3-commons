/*
 * Copyright (c) 2007-2009-2010 the original author or authors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package org.as3commons.emit.bytecode {
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	import org.as3commons.emit.SWFConstant;
	import org.as3commons.emit.reflect.EmitAccessor;
	import org.as3commons.emit.reflect.EmitConstant;
	import org.as3commons.emit.reflect.EmitMemberVisibility;
	import org.as3commons.emit.reflect.EmitMethod;
	import org.as3commons.emit.reflect.EmitType;
	import org.as3commons.emit.reflect.EmitTypeUtils;
	import org.as3commons.emit.reflect.EmitVariable;
	import org.as3commons.emit.reflect.IEmitMember;
	import org.as3commons.lang.Assert;

	public class DynamicClass extends EmitType {

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------

		private var _methodBodies:Dictionary = new Dictionary();

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 * Constructor.
		 */
		public function DynamicClass(qname:QualifiedName, superClassType:EmitType, interfaces:Array, applicationDomain:ApplicationDomain, autoGenerateInitializers:Boolean = false) {
			super(superClassType.applicationDomain, qname);
			initDynamicClass(superClassType, interfaces, applicationDomain, autoGenerateInitializers);
		}

		protected function initDynamicClass(superClassType:EmitType, interfaces:Array, applicationDomain:ApplicationDomain, autoGenerateInitializers:Boolean):void {
			Assert.notNull(superClassType, "superClassType argument must not be null");
			Assert.notNull(interfaces, "interfaces argument must not be null");
			this.superClassType = superClassType;
			this.interfaces.concat(interfaces);
			if (autoGenerateInitializers) {
				generateInitializerMethods(applicationDomain);
			}
		}

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		public function addField(field:IEmitMember):DynamicClass {
			Assert.notNull(field, "field argument must not be null");
			if (field is EmitConstant) {
				if (field.isStatic) {
					staticConstants.push(field);
				} else {
					constants.push(field);
				}
			} else if (field is EmitVariable) {
				if (field.isStatic) {
					staticVariables.push(field);
				} else {
					variables.push(field);
				}
			}
			return this;
		}

		public function addMethod(method:EmitMethod):DynamicClass {
			Assert.notNull(method, "method argument must not be null");
			methods[methods.length] = method;
			return this;
		}

		public function addMethodBody(methodBody:DynamicMethod):DynamicClass {
			Assert.notNull(methodBody, "methodBody argument must not be null");
			_methodBodies[methodBody.method] = methodBody;
			return this;
		}

		public function addProperty(property:EmitAccessor):DynamicClass {
			Assert.notNull(property, "property argument must not be null");
			accessors[accessors.length] = property;
			return this;
		}

		public function getMethodBodies():Dictionary {
			return _methodBodies;
		}

		/**
		 * @private
		 */
		private function generateConstructor(applicationDomain:ApplicationDomain):EmitMethod {
			var typeName:String = getQualifiedClassName(this);
			return new EmitMethod(typeName, SWFConstant.CONSTRUCTOR_IDENTIFIER, null, EmitMemberVisibility.PUBLIC, false, false, superClassType.constructorMethod.parameters, EmitTypeUtils.UNTYPED, applicationDomain);
		}

		public function generateInitializerMethods(applicationDomain:ApplicationDomain):void {
			generateConstructor(applicationDomain);
			addMethodBody(generateScriptInitializer());
			addMethodBody(generateStaticInitializer());
			addMethodBody(generateInitializer());
		}

		/**
		 * @private
		 * Corresponds to the constructor method ClassName()
		 */
		private function generateInitializer():DynamicMethod {
			var argCount:uint = superClassType.constructorMethod.parameters.length;
			var instructions:Array = [[Instructions.GetLocal_0], [Instructions.PushScope], [Instructions.GetLocal_0], [Instructions.ConstructSuper, argCount]];

			/*var fields:Array = getFields(false, true);
			   var length:int = fields.length;

			   for(var a:int = 0; a < length; a++) {
			   var field:IEmitMember = fields[a];
			   instructions.push([Instructions.GetProperty, field.qname]);
			   instructions.push([Instructions.PushString, ""]);
			   instructions.push([Instructions.SetProperty, field.qname]);
			 }*/

			instructions[instructions.length] = [Instructions.ReturnVoid];

			return new DynamicMethod(constructorMethod, 6 + argCount, 3 + argCount, 4, 5, instructions);
		}

		/**
		 * @private
		 * Corresponds to the script method init()
		 */
		private function generateScriptInitializer():DynamicMethod {
			var instructions:Array = [[Instructions.GetLocal_0], [Instructions.PushScope], [Instructions.FindPropertyStrict, multiNamespaceName], [Instructions.GetLex, superClassType.qname], [Instructions.PushScope], [Instructions.GetLex, superClassType.qname], [Instructions.NewClass, this], [Instructions.PopScope], [Instructions.InitProperty, qname], [Instructions.ReturnVoid]];
			return new DynamicMethod(scriptInitializer, 3, 2, 1, 3, instructions);
		}

		/**
		 * @private
		 * Corresponds to the static method cinit()
		 */
		private function generateStaticInitializer():DynamicMethod {
			var instructions:Array = [[Instructions.GetLocal_0], [Instructions.PushScope]];

			var fields:Array = getFields(true, false);
			var length:int = fields.length;

			for (var a:int = 0; a < length; a++) {
				var field:IEmitMember = fields[a];
				instructions.push([Instructions.FindProperty, field.qname]);
				instructions.push([Instructions.PushString, SWFConstant.EMPTY_STRING]);
				instructions.push([Instructions.InitProperty, field.qname]);
			}

			instructions.push([Instructions.ReturnVoid]);

			return new DynamicMethod(staticInitializer, 1 + length, 2, 1, 2, instructions);
		}
	}
}