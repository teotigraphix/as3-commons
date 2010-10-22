package org.mockito.asmock.framework.proxy {
	import org.mockito.asmock.reflection.FieldInfo;
	import org.mockito.asmock.reflection.MemberVisibility;
	import org.mockito.asmock.reflection.MethodInfo;
	import org.mockito.asmock.reflection.ParameterInfo;
	import org.mockito.asmock.reflection.PropertyInfo;
	import org.mockito.asmock.reflection.Type;
	import org.mockito.flemit.framework.bytecode.*;

	import flash.display.Sprite;
	
	[ExcludeClass]
	public class ProxyGenerator extends Sprite
	{
		public static const CREATE_METHOD : String = "__createInstance";
		
		private var proxyListenerType : Type = Type.getType(IProxyListener);
		
		public function ProxyGenerator()
		{
		}
		
		public function createProxyFromInterface(qname : QualifiedName, interfaces : Array) : DynamicClass
		{
			var superClass : Type = Type.getType(Object);
			
			var dynamicClass : DynamicClass = new DynamicClass(qname, superClass, interfaces);
			
			addInterfaceMembers(dynamicClass);
			
			var method : MethodInfo;
			var property : PropertyInfo;
			
			dynamicClass.constructor = createConstructor(dynamicClass);
			
			dynamicClass.addSlot(new FieldInfo(dynamicClass, PROXY_FIELD_NAME, qname.toString() + "/" + PROXY_FIELD_NAME, MemberVisibility.PUBLIC, false, Type.getType(IProxyListener)));
			
			dynamicClass.addMethodBody(dynamicClass.scriptInitialiser, generateScriptInitialier(dynamicClass));
			dynamicClass.addMethodBody(dynamicClass.staticInitialiser, generateStaticInitialiser(dynamicClass));
			dynamicClass.addMethodBody(dynamicClass.constructor, generateInitialiser(dynamicClass));
			
			for each(method in dynamicClass.getMethods())
			{
				dynamicClass.addMethodBody(method, generateMethod(dynamicClass, method, null, false, method.name, MethodType.METHOD));
			}
			
			for each(property in dynamicClass.getProperties())
			{
				dynamicClass.addMethodBody(property.getMethod, generateMethod(dynamicClass, property.getMethod, null, false, property.name, MethodType.PROPERTY_GET));
				dynamicClass.addMethodBody(property.setMethod, generateMethod(dynamicClass, property.setMethod, null, false, property.name, MethodType.PROPERTY_SET));
			}
			
			var createInstanceMethodBody : DynamicMethod = generateCreateInstanceMethod(dynamicClass);
			dynamicClass.addMethod(createInstanceMethodBody.method);
			dynamicClass.addMethodBody(createInstanceMethodBody.method, createInstanceMethodBody);
			
			return dynamicClass;
		}
		
		public function createProxyFromClass(qname : QualifiedName, superClass : Type, interfaces : Array) : DynamicClass
		{
			var dynamicClass : DynamicClass = new DynamicClass(qname, superClass, interfaces);
			
			var method : MethodInfo;
			var property : PropertyInfo;
			
			addSuperClassMembers(dynamicClass);
			
			dynamicClass.constructor = createConstructor(dynamicClass);
			
			dynamicClass.addSlot(new FieldInfo(dynamicClass, PROXY_FIELD_NAME, qname.toString() + "/" + PROXY_FIELD_NAME, MemberVisibility.PUBLIC, false, Type.getType(IProxyListener)));
			
			dynamicClass.addMethodBody(dynamicClass.scriptInitialiser, generateScriptInitialier(dynamicClass));
			dynamicClass.addMethodBody(dynamicClass.staticInitialiser, generateStaticInitialiser(dynamicClass));
			dynamicClass.addMethodBody(dynamicClass.constructor, generateInitialiser(dynamicClass));
			
			for each(method in dynamicClass.getMethods())
			{
				var baseMethod : MethodInfo = (method.isStatic)
					? null 
					: superClass.getMethod(method.name, true);
				
				dynamicClass.addMethodBody(method, generateMethod(dynamicClass, method, baseMethod, false, method.name, MethodType.METHOD));
			}
			
			for each(property in dynamicClass.getProperties())
			{
				var baseProperty : PropertyInfo = (property.isStatic)
					? null
					: superClass.getProperty(property.name, true);
				
				var baseGetDynamicMethod : DynamicMethod = null, 
					baseSetDynamicMethod : DynamicMethod = null;
				
				var baseGetMethod : MethodInfo = null,
					baseSetMethod : MethodInfo = null;
				
				if (baseProperty != null)
				{
					if (baseProperty.canRead)
					{
						baseGetDynamicMethod = generateSuperPropertyGetterMethod(property);
						baseGetMethod = baseGetDynamicMethod.method;
						
						dynamicClass.addMethod(baseGetDynamicMethod.method);
						dynamicClass.addMethodBody(baseGetDynamicMethod.method, baseGetDynamicMethod);
						
						dynamicClass.addMethodBody(property.getMethod, generateMethod(dynamicClass, property.getMethod, baseGetMethod, true, property.name, MethodType.PROPERTY_GET));
					}
					
					if (baseProperty.canWrite)
					{
						baseSetDynamicMethod = generateSuperPropertySetterMethod(property);
						baseSetMethod = baseSetDynamicMethod.method; 
						
						dynamicClass.addMethod(baseSetDynamicMethod.method);
						dynamicClass.addMethodBody(baseSetDynamicMethod.method, baseSetDynamicMethod);
						
						dynamicClass.addMethodBody(property.setMethod, generateMethod(dynamicClass, property.setMethod, baseSetMethod, true, property.name, MethodType.PROPERTY_SET));
					}
				}
			}
			
			var createInstanceMethodBody : DynamicMethod = generateCreateInstanceMethod(dynamicClass);
			dynamicClass.addMethod(createInstanceMethodBody.method);
			dynamicClass.addMethodBody(createInstanceMethodBody.method, createInstanceMethodBody);
			
			return dynamicClass;
		}
		
		private function addInterfaceMembers(dynamicClass : DynamicClass) : void
		{
			var allInterfaces : Array = dynamicClass.getInterfaces();
			
			for each(var inter : Type in allInterfaces)
			{
				for each(var extendedInterface : Type in inter.getInterfaces())
				{
					if (allInterfaces.indexOf(extendedInterface) == -1)
					{
						allInterfaces.push(extendedInterface);
					}
				}
				
				for each(var method : MethodInfo in inter.getMethods())
				{
					if (dynamicClass.getMethod(method.name) == null)
					{					
						dynamicClass.addMethod(new MethodInfo(dynamicClass, method.name, null, method.visibility, method.isStatic, false, method.returnType, method.parameters));
					}
				}
				
				for each(var property : PropertyInfo in inter.getProperties())
				{
					if (dynamicClass.getProperty(property.name) == null)
					{
						dynamicClass.addProperty(new PropertyInfo(dynamicClass, property.name, null, property.visibility, property.isStatic, false, property.type, property.canRead, property.canWrite));
					}
				}
			}
		}
		
		private function addSuperClassMembers(dynamicClass : DynamicClass) : void
		{
			var superClass : Type = dynamicClass.baseType;
			var objectType : Type = Type.getType(Object);
			
			while(superClass != objectType)
			{
				for each(var method : MethodInfo in superClass.getMethods(false, true))
				{
					if (method.qname.ns.name == "")
					{					
						if (dynamicClass.getMethod(method.name, false) == null)
						{
							// TODO: IsFinal?
							dynamicClass.addMethod(new MethodInfo(dynamicClass, method.name, null, method.visibility, method.isStatic, true, method.returnType, method.parameters));
						}
					}
				}
				
				for each(var property : PropertyInfo in superClass.getProperties(false, true))
				{
					if (property.qname.ns.name == "")
					{
						if (dynamicClass.getProperty(property.name, false) == null)
						{
							// TODO: IsFinal?
							dynamicClass.addProperty(new PropertyInfo(dynamicClass, property.name, null, property.visibility, property.isStatic, true, property.type, property.canRead, property.canWrite));
						}
					}
				}
				
				superClass = superClass.baseType;
			}
		}
		
		private function createConstructor(dynamicClass : DynamicClass) : MethodInfo
		{
			var baseCtor : MethodInfo = dynamicClass.baseType.constructor;
			
			var params : Array = new Array().concat(baseCtor.parameters);
			params.unshift(new ParameterInfo("_proxy", Type.getType(IProxyListener), false));
			
			//return new MethodInfo(dynamicClass, dynamicClass.name, null, MemberVisibility.PUBLIC, false, 
			return new MethodInfo(dynamicClass, "ctor", null, MemberVisibility.PUBLIC, false, false, 
				Type.star, params);
		}
		
		private function generateScriptInitialier(dynamicClass : DynamicClass) : DynamicMethod
		{
			var clsNamespaceSet : NamespaceSet = new NamespaceSet(
				[new BCNamespace(dynamicClass.packageName, NamespaceKind.PACKAGE_NAMESPACE)]);
			
			if (dynamicClass.isInterface)
			{
				return new DynamicMethod(dynamicClass.scriptInitialiser, 3, 2, 1, 3, [
					[Instructions.GetLocal_0],
					[Instructions.PushScope],
					[Instructions.FindPropertyStrict, new MultipleNamespaceName(dynamicClass.name, clsNamespaceSet)], 
					[Instructions.PushNull],
					[Instructions.NewClass, dynamicClass],
					[Instructions.InitProperty, dynamicClass.qname],
					[Instructions.ReturnVoid]
				]); 
			}
			else
			{
				// TODO: Support where base class is not Object
				return new DynamicMethod(dynamicClass.scriptInitialiser, 3, 2, 1, 3, [
					[Instructions.GetLocal_0],
					[Instructions.PushScope],
					//[GetScopeObject, 0],
					[Instructions.FindPropertyStrict, dynamicClass.multiNamespaceName], 
					[Instructions.GetLex, dynamicClass.baseType.qname],
					[Instructions.PushScope],
					[Instructions.GetLex, dynamicClass.baseType.qname],
					[Instructions.NewClass, dynamicClass],
					[Instructions.PopScope],
					[Instructions.InitProperty, dynamicClass.qname],
					[Instructions.ReturnVoid]
				]);
			}
		}
		
		private function generateStaticInitialiser(dynamicClass : DynamicClass) : DynamicMethod
		{
			return new DynamicMethod(dynamicClass.staticInitialiser, 2, 2, 3, 4, [
				[Instructions.GetLocal_0],
				[Instructions.PushScope],
				[Instructions.ReturnVoid]
			]);
		}
		
		private function generateInitialiser(dynamicClass : DynamicClass) : DynamicMethod
		{
			var baseCtor : MethodInfo = dynamicClass.baseType.constructor;
				
			var argCount : uint = baseCtor.parameters.length;
			
			var proxyField : FieldInfo = dynamicClass.getField(PROXY_FIELD_NAME);
			
			var instructions : Array = [
				[Instructions.GetLocal_0],
				[Instructions.PushScope],
				
				
				/* [ReturnVoid]]; */
				
				[Instructions.FindProperty, proxyField.qname],
				[Instructions.GetLocal_1], // proxy argument (always first arg)
				[Instructions.InitProperty, proxyField.qname],
				
				// begin construct super
				[Instructions.GetLocal_0] // 'this'
			];
			
			for (var i:uint=0; i<argCount; i++) 
			{
				instructions.push([Instructions.GetLocal, i+2]);
				
				/* if (ParameterInfo(baseCtor.parameters[i]).optional)
				{
					instructions.push([PushUndefined]);
					instructions.push([IfNotEquals, 2]);
					instructions.push([ConstructSuper, argCount]);
				} */
			}
			
			instructions.push(
				// Optionals?
				//[PushUndefined]
			
				[Instructions.ConstructSuper, argCount],
				// end construct super
			
				// call __proxy__.methodExecuted(this, CONSTRUCTOR, className, {arguments})
				[Instructions.GetLocal_1],
				[Instructions.GetLocal_0],
				[Instructions.PushByte, MethodType.CONSTRUCTOR],
				[Instructions.PushString, dynamicClass.name],
				[Instructions.GetLocal, argCount + 2], // 'arguments'
				[Instructions.PushNull],
				[Instructions.CallPropVoid, proxyListenerType.getMethod("methodExecuted").qname, 5],
				
				
				[Instructions.ReturnVoid]
			);
			
			return new DynamicMethod(dynamicClass.constructor, 6 + argCount, 3 + argCount, 4, 5, instructions);
		}
		
		private function generateMethod(dynamicClass : DynamicClass, method : MethodInfo, baseMethod : MethodInfo, baseIsDelegate : Boolean, name : String, methodType : uint) : DynamicMethod
		{
			var argCount : uint = method.parameters.length;
			var proxyField : FieldInfo = dynamicClass.getField(PROXY_FIELD_NAME);

			var instructions : Array = [
				[Instructions.GetLocal_0],
				[Instructions.PushScope],
				
				[Instructions.GetLex, proxyField.qname],
				[Instructions.GetLocal_0],
				[Instructions.PushByte, methodType],
				[Instructions.PushString, name],
				[Instructions.GetLocal, argCount + 1], // 'arguments'					
			];
			
			// TODO: IsFinal?
			if (baseMethod != null)
			{
				if (baseIsDelegate)
				{
					instructions.push(
						[Instructions.GetLex, baseMethod.qname]
					);
				}
				else
				{
					instructions.push(
						[Instructions.GetLocal_0],
						[Instructions.GetSuper, baseMethod.qname]
					);
				}
			}
			else
			{
				instructions.push(
					[Instructions.PushNull]
				);
			}
			
			instructions.push(
				[Instructions.CallProperty, proxyListenerType.getMethod("methodExecuted").qname, 5]
			);
			
			if (method.returnType == Type.voidType) // void
			{
				instructions.push([Instructions.ReturnVoid]);
			}
			else
			{
				instructions.push(
					//[GetLex, method.returnType.qname],
					//[AsTypeLate],
					[Instructions.ReturnValue]
				);
			}
			
			return new DynamicMethod(method, 7 + argCount, argCount + 2, 4, 5, instructions);
		}
		
		private function generateSuperPropertyGetterMethod(property : PropertyInfo) : DynamicMethod
		{
			var method : MethodInfo = new MethodInfo(property.owner, "get_" + property.name + "_internal", null, MemberVisibility.PRIVATE, false, false, Type.getType(Object), []); 
			
			var instructions : Array = [
				[Instructions.GetLocal_0],
				[Instructions.PushScope],
				
				[Instructions.GetLocal_0],
				[Instructions.GetSuper, property.qname],
				
				[Instructions.GetLex, property.type.qname],
				[Instructions.AsTypeLate],
				
				[Instructions.ReturnValue]
			];
			
			return new DynamicMethod(method, 3, 2, 4, 5, instructions);
		}
		
		private function generateSuperPropertySetterMethod(property : PropertyInfo) : DynamicMethod
		{
			var valueParam : ParameterInfo = new ParameterInfo("value", property.type, false);
			
			var method : MethodInfo = new MethodInfo(property.owner, "set_" + property.name + "_internal", null, MemberVisibility.PRIVATE, false, false, Type.getType(Object), [valueParam]); 
			
			
			var instructions : Array = [
				[Instructions.GetLocal_0],
				[Instructions.PushScope],
				
				[Instructions.GetLocal_0],
				[Instructions.GetLocal_1],
				[Instructions.SetSuper, property.qname],
				
				[Instructions.ReturnVoid]
			];
				
			return new DynamicMethod(method, 4, 3, 4, 5, instructions);
		}
		
		private function generateCreateInstanceMethod(dynamicClass : DynamicClass) : DynamicMethod
		{
			var argCount : int = dynamicClass.constructor.parameters.length;
			
			var method : MethodInfo = new MethodInfo(dynamicClass, CREATE_METHOD, null, MemberVisibility.PUBLIC, true, false, dynamicClass, dynamicClass.constructor.parameters); 
			
			var instructions : Array = [
				[Instructions.GetLocal_0],
				[Instructions.PushScope],
				
				[Instructions.GetLex, dynamicClass.qname]
			];
				
			for (var i : int = 0; i<argCount; i++)
			{
				instructions.push(
					[Instructions.GetLocal, i+1]
				);
			}
			
			instructions.push(
				[Instructions.Construct, dynamicClass.constructor.parameters.length],
				
				/* [GetLex, dynamicClass.qname],
				[AsTypeLate], */
				
				[Instructions.ReturnValue]
			);
			
			return new DynamicMethod(method, 2 + argCount, 2 + argCount, 3, 4, instructions);
		}
		
		private static const PROXY_FIELD_NAME : String = "__proxy__";
	}
}