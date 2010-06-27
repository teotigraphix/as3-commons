package org.as3commons.emit {
	import flash.system.ApplicationDomain;

	import org.as3commons.emit.bytecode.BCNamespace;
	import org.as3commons.emit.bytecode.DynamicClass;
	import org.as3commons.emit.bytecode.DynamicMethod;
	import org.as3commons.emit.bytecode.Instructions;
	import org.as3commons.emit.bytecode.QualifiedName;
	import org.as3commons.emit.reflect.EmitAccessor;
	import org.as3commons.emit.reflect.EmitMemberVisibility;
	import org.as3commons.emit.reflect.EmitMethod;
	import org.as3commons.emit.reflect.EmitType;
	import org.as3commons.emit.reflect.EmitTypeUtils;
	import org.as3commons.emit.reflect.EmitVariable;
	import org.as3commons.emit.reflect.IEmitMember;
	import org.as3commons.emit.reflect.IEmitProperty;
	import org.as3commons.reflect.AbstractMember;

	internal class ClassGenerator implements IClassGenerator {
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 * Constructor.
		 */
		public function ClassGenerator() {
		}

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private function addSuperClassProperties(dynamicClass:DynamicClass, objectClass:EmitType):void {
			var superClass:EmitType = objectClass;
			var objectType:EmitType = EmitType.forInstance(Object);

			while (superClass != objectType) {
				for each (var property:EmitAccessor in superClass.getProperties(false, true)) {
					if (property.qname.ns.name == "") {
						if (dynamicClass.getDeclaredProperty(property.name, false) == null) {
							dynamicClass.addProperty(new EmitAccessor(dynamicClass.fullName, property.name, null, property.access, EmitType(property.type).fullName, property.visibility, property.isStatic, false, ApplicationDomain.currentDomain));
						}
					}
				}

				superClass = superClass.superClassType;
			}
		}

		public function createClass(baseClass:EmitType):DynamicClass {
			var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			var qname:QualifiedName = new QualifiedName(BCNamespace.packageNS(baseClass.packageName), "Dynamic" + baseClass.name);
			var dynamicClass:DynamicClass = new DynamicClass(qname, baseClass, [], applicationDomain);

			//addSuperClassProperties(dynamicClass, baseClass);

			//dynamicClass.addField(new EmitVariable(dynamicClass, "property", null, EmitType.forClass(String), EmitMemberVisibility.PUBLIC, false, false));
			dynamicClass.generateInitializerMethods(applicationDomain);

			for each (var property:AbstractMember in dynamicClass.getProperties()) {
				if (property != null && property is IEmitProperty) {
					if (IEmitProperty(property).readable) {
						dynamicClass.addMethodBody(generatePropertyGetterMethod(IEmitMember(property), baseClass));
					}

					if (IEmitProperty(property).writeable) {
						dynamicClass.addMethodBody(generatePropertySetterMethod(IEmitMember(property), baseClass));
					}
				}
			}

			return dynamicClass;
		}

		/**
		 * @private
		 */
		private function generateMethod(method:EmitMethod, baseMethod:EmitMethod):DynamicMethod {
			var argCount:uint = method.parameters.length;

			with (Instructions) {
				var instructions:Array = [[GetLocal_0], [PushScope],

					[GetLocal_0], [CallSuper, baseMethod.qname, argCount]];

				if (method.returnType == Type.voidType) // void
				{
					instructions.push([ReturnVoid]);
				} else {
					instructions.push([ReturnValue]);
				}

				return new DynamicMethod(method, 7 + argCount, argCount + 2, 4, 5, instructions);
			}
		}

		/**
		 * @private
		 */
		private function generatePropertyGetterMethod(property:IEmitMember, proxyClass:EmitType):DynamicMethod {
			with (Instructions) {
				var instructions:Array = [[GetLocal_0], [PushScope], [GetProperty, property.qname], [ReturnValue]];

				return new DynamicMethod(property.getMethod, 3, 2, 5, 6, instructions);
			}
		}

		/**
		 * @private
		 */
		private function generatePropertySetterMethod(property:IEmitMember, proxyClass:EmitType):DynamicMethod {
			with (Instructions) {
				var instructions:Array = [[GetLocal_0], [PushScope], [GetLocal_0], [GetLocal_1], [SetProperty, property.qname], [ReturnVoid]];

				return new DynamicMethod(property.setMethod, 4, 3, 4, 5, instructions);
			}
		}

		/**
		 * @private
		 */
		private function generateSuperPropertyGetterMethod(property:EmitAccessor):DynamicMethod {
			with (Instructions) {
				var instructions:Array = [[GetLocal_0], [PushScope],

					[GetLocal_0], [GetSuper, property.qname],

					[ReturnValue]];

				return new DynamicMethod(property.getMethod, 3, 2, 4, 5, instructions);
			}
		}

		/**
		 * @private
		 */
		private function generateSuperPropertySetterMethod(property:EmitAccessor):DynamicMethod {
			with (Instructions) {
				var instructions:Array = [[GetLocal_0], [PushScope],

					[GetLocal_0], [GetLocal_1], [SetSuper, property.qname],

					[ReturnVoid]];

				return new DynamicMethod(property.setMethod, 4, 3, 4, 5, instructions);
			}
		}
	}
}