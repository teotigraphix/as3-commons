package org.mockito.asmock.reflection
{
	import flash.utils.*;
	import flash.system.*;
	import flash.net.registerClassAlias;
	
	import org.mockito.flemit.framework.bytecode.*;
	
	[ExcludeClass]
	public class DescribeTypeTypeProvider implements ITypeProvider
	{
		private var _typeCache : Dictionary = new Dictionary(true);
		
		public function DescribeTypeTypeProvider()
		{
		}
		
		public function getType(cls : Class, applicationDomain : ApplicationDomain = null) : Type
		{
			if (_typeCache[cls] == null)
			{
				var className : String = getQualifiedClassName(cls);
				
				if (!applicationDomain.hasDefinition(className))
				{
					registerClassAlias(className, cls);
				}
				
				var typeXml : XML = flash.utils.describeType(cls);
				
				var typeName : String = typeXml.@name.toString();
				
				var genericParams : Array = getGenericParameters(typeName);
				
				var typeDefinition : Type = (genericParams.length > 0)
					? getGenericTypeDefinition(typeName)
					: null;
					
				
				if (typeDefinition != null)
				{
					// TODO: This should only happen once
					typeDefinition.setGenericParameterCount(genericParams.length);
				}
				
				var qname : QualifiedName = getQualifiedName(typeName);
				
				var multiname : Multiname = (typeDefinition != null)
					? getGenericName(typeDefinition, genericParams)
					: qname;

				var type : Type = new Type(qname, multiname, cls);
				_typeCache[cls] = type; // for circular references
								
				setClassFlags(type, typeXml);
				
				type.setBaseType(getBaseType(type, typeXml));
				
				type.setInterfaces(getInterfaces(typeXml));
				
				if (!type.isInterface && typeXml.factory.constructor.length() != 0)
				{
					type.setConstructor(getMethodInfo(typeXml.factory.constructor[0], type, false));
				}
				
				addMembers(typeXml, type, true);
				addMembers(typeXml.factory[0], type, false);
			}
			
			return _typeCache[cls];
		}
		
		private function isPrivateClass(namespaceName : String) : Boolean
		{
			return (namespaceName.indexOf(".as$") > -1);
		}
		
		private function getGenericName(genericTypeDefinition : Type, genericParams : Array) : GenericName 
		{
			genericParams = genericParams.map(function(type : Type, ... args) : Multiname { return type.multiname; });
			
			return new GenericName(genericTypeDefinition.multiname, genericParams);
		}

		private function getQualifiedName(typeName : String) : QualifiedName
		{
			var ns : String, nsKind : uint, name : String;
				
			if (typeName.indexOf('::') == -1)
			{
				ns = "";
				nsKind = NamespaceKind.PACKAGE_NAMESPACE;
				name = typeName;
			}
			else
			{
				ns = typeName.substr(0, typeName.indexOf('::'));
				name = typeName.substr(typeName.indexOf('::') + 2);
				nsKind = isPrivateClass(ns)
					? NamespaceKind.PRIVATE_NS
					: NamespaceKind.PACKAGE_NAMESPACE;
			}
			
			return new QualifiedName(new BCNamespace(ns, nsKind), name);
		}
		
		private function setClassFlags(type : Type, typeXml : XML) : void
		{
			var isClass : Boolean = (typeXml.factory.extendsClass.length() > 0) || type.classDefinition == Object;
			var isStatic : Boolean = (typeXml.@isStatic.toString() == "true");
			var isFinal : Boolean = (typeXml.@isFinal.toString() == "true");
			var isDynamic : Boolean = (typeXml.@isDynamic.toString() == "true");
			
			// TODO: Experimental for nested types
			if (isFinal && type.qname.ns.kind != NamespaceKind.PACKAGE_NAMESPACE)
			{
				isFinal = false;
			}
			
			type.setIsInterface(!isClass);
			type.setIsFinal(isFinal);
			type.setIsDynamic(isDynamic);
		}
		
		private function getInterfaces(typeXml : XML) : Array
		{
			var interfaces : Array = new Array();
			
			for each(var interfaceNode : XML in typeXml.factory.implementsInterface)
			{
				var interfaceTypeName : String = interfaceNode.@type.toString();
				
				var interfaceType : Type = Type.getTypeByName(interfaceTypeName);
				
				interfaces.push(interfaceType);
			}
			
			return interfaces;
		}
		
		private function getBaseType(type : Type, typeXml : XML) : Type
		{
			var baseType : Type = null;
				
			if (!type.isInterface && type.classDefinition != Object)
			{
				var baseTypeName : String = typeXml.factory.extendsClass[0].@type.toString();
				
				return Type.getTypeByName(baseTypeName);
			}
			
			return null;
		}
		
		private function getGenericTypeDefinition(typeName : String) : Type
		{
			var genericExpr : RegExp = /^([^\<]+)\.\<.+\>$/;
			
			var genericTypeName : String = genericExpr.exec(typeName)[1].toString();
			
			return Type.getTypeByName(genericTypeName);
		}
		
		private function getGenericParameters(typeName : String) : Array
		{
			var genericParameters : Array = new Array();
			
			var paramsExpr : RegExp = /\<(.+)\>$/;
			
			var result : Object = paramsExpr.exec(typeName);
			
			if (result != null)
			{
				// TODO: Update with correct delmiter
				var paramTypeNames : Array = result[1].toString().split(', ');
				
				for each(var paramTypeName : String in paramTypeNames) 
				{
					genericParameters.push(Type.getTypeByName(paramTypeName));
				}
			}
			
			return genericParameters;
		}
		
		private function addMembers(typeXML : XML, owner : Type, isStatic : Boolean) : void 
		{
			var declaredBy : String = null;
			
			for each(var methodNode : XML in typeXML.method)
			{
				declaredBy = methodNode.@declaredBy.toString().replace('::',':');
				
				if (declaredBy == owner.fullName)
				{
					try
					{
						var methodInfo : MethodInfo = getMethodInfo(methodNode, owner, isStatic);
						
						owner.addMethod(methodInfo);
					}
					catch(err : TypeNotFoundError)
					{
					}
				}
			}
			
			for each(var propertyNode : XML in typeXML.accessor)
			{
				declaredBy = propertyNode.@declaredBy.toString().replace('::',':');
				
				if (declaredBy == owner.fullName)
				{
					try
					{
						var propertyInfo : PropertyInfo = getPropertyInfo(propertyNode, owner, isStatic);
						
						owner.addProperty(propertyInfo);
					}
					catch(err : TypeNotFoundError)
					{
					}
				}
			}
			
			var fieldInfo : FieldInfo = null;
			
			for each(var fieldNode : XML in typeXML.variable)
			{
				try
				{
					fieldInfo = getFieldInfo(fieldNode, owner, isStatic);

					owner.addField(fieldInfo);
				}
				catch(err : TypeNotFoundError)
				{
				}
			}
			
			for each(var constantNode : XML in typeXML.constant)
			{
				fieldInfo = getFieldInfo(constantNode, owner, isStatic);
					
				owner.addField(fieldInfo);
			}
		}
		
		private function getMemberFullName(name : String, owner : Type) : String
		{
			return owner.isInterface
				? owner.qname.toString().concat('/', owner.qname.toString(), ':', name)
				: owner.qname.toString().concat('/', name);
		}
		
		private function getMethodInfo(methodInfoNode : XML, owner : Type, isStatic : Boolean) : MethodInfo
		{
			var uri : String = methodInfoNode.@uri.toString();
			var name : String = methodInfoNode.@name.toString();
			var returnTypeName : String = methodInfoNode.@returnType.toString();
			
			var returnType : Type = (returnTypeName == "") ? Type.voidType : Type.getTypeByName(returnTypeName);
			
			var isOverride : Boolean = (owner.baseType != null && owner.baseType.getMethod(name) != null);
			
			var parameters : Array = new Array();
			
			for each(var parameterXML : XML in methodInfoNode.parameter)
			{
				var index : int = parseInt(parameterXML.@index.toString());
				var parameterTypeName : String = parameterXML.@type.toString();
				var optional : Boolean = (parameterXML.@optional.toString() == "true");

				var parameterName : String = ("arg" + index.toString());
				var parameterType : Type = Type.getTypeByName(parameterTypeName); 
				
				var parameter : ParameterInfo = new ParameterInfo(parameterName, parameterType, optional);
				
				parameters.push(parameter);
			}
			
			return new MethodInfo(owner, name, getMemberFullName(name, owner), MemberVisibility.PUBLIC, isStatic, isOverride, returnType, parameters, uri);
		}
		
		private function getPropertyInfo(propertyInfoNode : XML, owner : Type, isStatic : Boolean) : PropertyInfo
		{
			var uri : String = propertyInfoNode.@uri.toString();
			var name : String = propertyInfoNode.@name.toString();
			var typeName : String = propertyInfoNode.@type.toString();
			
			var propertyType : Type = Type.getTypeByName(typeName);
			
			var access : String = propertyInfoNode.@access.toString();
			var canRead : Boolean = (access == "readonly" || access == "readwrite");
			var canWrite : Boolean = (access == "writeonly" || access == "readwrite");
			
			var isOverride : Boolean = (owner.baseType != null && owner.baseType.getProperty(name) != null);
			
			return new PropertyInfo(owner, name, getMemberFullName(name, owner), MemberVisibility.PUBLIC, isStatic, isOverride, propertyType, canRead, canWrite, uri);
		}
		
		private function getFieldInfo(fieldInfoNode : XML, owner : Type, isStatic : Boolean) : FieldInfo
		{
			var name : String = fieldInfoNode.@name.toString();
			var typeName : String = fieldInfoNode.@type.toString();
			
			var type : Type = Type.getTypeByName(typeName);
			
			return new FieldInfo(owner, name, getMemberFullName(name, owner), MemberVisibility.PUBLIC, isStatic, type);
		}

	}
}