package org.mockito.asmock.reflection
{
	import flash.system.*;
	import flash.utils.*;
	import flash.net.*;
	
	import org.mockito.flemit.framework.bytecode.BCNamespace;
	import org.mockito.flemit.framework.bytecode.Multiname;
	import org.mockito.flemit.framework.bytecode.MultipleNamespaceName;
	import org.mockito.flemit.framework.bytecode.NamespaceKind;
	import org.mockito.flemit.framework.bytecode.NamespaceSet;
	import org.mockito.flemit.framework.bytecode.QualifiedName;
	
	[ExcludeClass]
	public class Type 
	{
		private var _class : Class;
		
		private var _isDynamic : Boolean = false;		
		private var _isFinal : Boolean = false;		
		private var _isInterface : Boolean = false;		
		
		protected var _baseClass : Type;
		public var _interfaces : Array;
		protected var _properties : Array;
		protected var _methods : Array;
		protected var _fields : Array;
		
		private var _scriptInitialiser : MethodInfo;
		private var _staticInitialiser : MethodInfo;
		protected var _constructor : MethodInfo;
		
		private var _qname : QualifiedName;
		private var _multiname : Multiname;
		private var _multiNamespaceName : MultipleNamespaceName;
		private var _typeNamespace : BCNamespace;
		
		private var _genericParameterCount : uint = 0;
		private var _genericParameters : Array;
		private var _genericTypeDefinition : Type; 
		
		public function Type(qname : QualifiedName, multiname : Multiname = null, classDefinition : Class = null)
		{
			_interfaces = new Array();
			_properties = new Array();
			_methods = new Array();
			_fields = new Array();
			_qname = qname;
			_multiname = multiname || qname;
			
			_multiNamespaceName = new MultipleNamespaceName(name, 
				new NamespaceSet([qname.ns]));
			
			_class = classDefinition;
			
			var typeNamespaceKind : uint = (_qname.ns.kind == NamespaceKind.PACKAGE_NAMESPACE)
				? NamespaceKind.NAMESPACE
				: NamespaceKind.PROTECTED_NAMESPACE;	
			
			_typeNamespace = new BCNamespace(qname.ns.name.concat(':', qname.name), typeNamespaceKind);
			
			_constructor = new MethodInfo(this, qname.name, null, MemberVisibility.PUBLIC, false, false, star, []);
			_scriptInitialiser = new MethodInfo(this, "", "", MemberVisibility.PUBLIC, true, false, star, []);
			_staticInitialiser = new MethodInfo(this, "", "", MemberVisibility.PUBLIC, true, false, star, []);
		}
		
		public function get classDefinition() : Class
		{
			return _class;
		}
		
		public function get baseType() : Type
		{
			return _baseClass;
		}
		
		internal function setBaseType(value : Type) : void
		{
			_baseClass = value;
		}
		
		public function get name() : String
		{
			return qname.name;
		}
		
		public function get fullName() : String
		{
			return qname.toString();
		}
		
		public function get packageName() : String
		{
			return qname.ns.name;
		}
		
		public function get qname() : QualifiedName
		{
			return _qname;
		}
		
		public function get multiname() : Multiname
		{
			return _multiname;
		}
		
		public function get multiNamespaceName() : MultipleNamespaceName
		{
			return _multiNamespaceName;
		}
		
		internal function setMultiNamespaceName(value : MultipleNamespaceName) : void
		{
			_multiNamespaceName = value;
		}
		
		public function get isDynamic() : Boolean
		{
			return _isDynamic;
		}
		
		internal function setIsDynamic(value : Boolean) : void
		{
			_isDynamic = value;
		}
		
		public function get isFinal() : Boolean
		{
			return _isFinal;
		}
		
		internal function setIsFinal(value : Boolean) : void
		{
			_isFinal = value;
		}
		
		public function get isInterface() : Boolean
		{
			return _isInterface;
		}
		
		internal function setIsInterface(value : Boolean) : void
		{
			_isInterface = value;
		}
		
		public function get typeNamespace() : BCNamespace
		{
			return _typeNamespace;
		}
		
		internal function setTypeNamespace(value : BCNamespace) : void
		{
			_typeNamespace = value;
		}
		
		public function getInterfaces() : Array
		{
			return new Array().concat(_interfaces);
		}
		
		internal function setInterfaces(value : Array) : void
		{
			_interfaces = new Array().concat(value);
		}
		
		public function get genericTypeDefinition() : Type
		{
			return _genericTypeDefinition;
		}
		
		public function get genericParameters() : Array
		{
			return new Array().concat(_genericParameters);
		}
		
		public function get isGeneric() : Boolean
		{
			return _genericTypeDefinition != null &&
				_genericParameters.length > 0;
		}
		
		public function get isGenericTypeDefinition() : Boolean
		{
			return _genericTypeDefinition == null &&
				_genericParameterCount > 0;
		}
		
		internal function setGenericParameterCount(value : uint) : void
		{
			_genericParameterCount = value;
		}
		
		internal function setGenericParameters(parameters : Array, genericTypeDefinition : Type) : void
		{
			_genericParameters = parameters;
			_genericTypeDefinition = genericTypeDefinition;
		}
		
		public function getProperties(includeStatic : Boolean = true, includeInstance : Boolean = true) : Array
		{
			return new Array().concat(_properties).filter(function (member : MemberInfo, i : int, arr : Array) : Boolean
			{
				return (member.isStatic) ? includeStatic : includeInstance;
			});
		}
		
		public function getProperty(name : String, trySuper : Boolean = false) : PropertyInfo
		{
			var property : PropertyInfo = findMember(_properties, name) as PropertyInfo;
			
			return (property == null && trySuper)
				? baseType.getProperty(name, trySuper)
				: property;
		}
		
		public function getMethods(includeStatic : Boolean = true, includeInstance : Boolean = true) : Array
		{
			return new Array().concat(_methods).filter(function (member : MemberInfo, i : int, arr : Array) : Boolean
			{
				return (member.isStatic) ? includeStatic : includeInstance;
			});
		}
		
		public function getMethod(name : String, trySuper : Boolean = false) : MethodInfo
		{
			var method : MethodInfo = findMember(_methods, name) as MethodInfo;
			
			return (method == null && trySuper)
				? baseType.getMethod(name, trySuper)
				: method;
		}
		
		public function getFields(includeStatic : Boolean = true, includeInstance : Boolean = true) : Array
		{
			return new Array().concat(_fields).filter(function (member : MemberInfo, i : int, arr : Array) : Boolean
			{
				return (member.isStatic) ? includeStatic : includeInstance;
			});
		}
		
		public function getField(name : String) : FieldInfo
		{
			return findMember(_fields, name) as FieldInfo;
		}
		
		public function getMembers(includeStatic : Boolean = true, includeInstance : Boolean = true) : Array
		{
			return _methods.concat(_properties).concat(_fields).filter(function (member : MemberInfo, i : int, arr : Array) : Boolean
			{
				return (member.isStatic) ? includeStatic : includeInstance;
			});
		}		
		
		public function getMember(name : String) : MemberInfo
		{
			return getMethod(name) || getProperty(name) || getField(name);
		}
		
		internal function addProperty(propertyInfo : PropertyInfo) : void
		{
			_properties.push(propertyInfo);
		}
		
		internal function addMethod(methodInfo : MethodInfo) : void
		{
			_methods.push(methodInfo);
		}
		
		internal function addField(fieldInfo : FieldInfo) : void
		{
			_fields.push(fieldInfo);
		}
		
		public function get scriptInitialiser() : MethodInfo
		{
			return _scriptInitialiser;
		}
		
		public function get staticInitialiser() : MethodInfo
		{
			return _staticInitialiser;
		}
		
		public function get constructor() : MethodInfo
		{
			return _constructor;
		}
		
		internal function setConstructor(value : MethodInfo) : void
		{
			_constructor = value;
		}
		
		/**
		 * Returns whether this type is a numeric type (Number, int, uint)
		 * @return true is the type is a numeric type; false otherwsie
		 */
		public function get isNumeric() : Boolean
		{
			return (this == Type.getType(int)) ||
				(this == Type.getType(uint)) ||
				(this == Type.getType(Number));
		}
		
		private function findMember(members : Array, name : String) : MemberInfo
		{
			for each(var memberInfo : MemberInfo in members)
			{
				if (memberInfo.name == name)
				{
					return memberInfo;
				}
			}
			
			return null;
		}
		
		public function isAssignableFromInstance(value : Object) : Boolean 
		{
			if (this.classDefinition == Class && value is Class)
			{
				return true;
			}
			
			if (value == null)
			{
				return true;
			}

			return this.isAssignableFrom(getType(value));

		}
		
		public function isAssignableFrom(type : Type) : Boolean
		{
			if (this == Type.voidType)
			{
				return false;
			}
			
			if (this == Type.star)
			{
				return true;
			}
			
			if (this == type)
			{
				return true;
			}
			
			if (this.classDefinition == Class)
			{
				return true;
			}
			
			// Vector can be assigne from Vector.<int>
			if (this.isGenericTypeDefinition && type.isGeneric && 
				type.genericTypeDefinition == this)
			{
				return true;
			}
			
			// int/Number can be implicitly cast
			if (this.isNumeric && type.isNumeric)
			{
				return true;
			}
			
			if (this.isInterface)
			{
				if (type.getInterfaces().indexOf(this) != -1)
				{
					return true;
				}
			}
			
			var parentType : Type = type;
			
			while(parentType != null)		
			{
				if (this == parentType)
				{
					return true;
				}
				
				parentType = parentType.baseType;
			}
			
			return false;
		}
		
		public static function getTypeByName(name : String, applicationDomain : ApplicationDomain =  null) : Type
		{
			applicationDomain = applicationDomain || ApplicationDomain.currentDomain;			
			
			if (name == "*")
			{
				return Type.star;
			}
			
			if (name == "void")
			{
				return Type.voidType; // Type.void ?
			}
			
			name = removeGenericStar(name);
			
			var cls : Class = null;
			
			try
			{
				cls = (applicationDomain.hasDefinition(name))
					? applicationDomain.getDefinition(name) as Class
					: getClassByAlias(name);
			}
			catch(err : ReferenceError)
			{
				throw new TypeNotFoundError(name);
			}
			
			return getType(cls);
		}
		
		private static function removeGenericStar(typeName : String) : String
		{
			var expr : RegExp = /^([^\<]+)\.\<\*(, \*)*\>$/;
			
			var result : Object = expr.exec(typeName);
			
			return (result != null)
				? result[1]
				: typeName;
		}
		
		public static function getType(obj : Object) : Type
		{
			if (obj == null)
			{
				throw new ArgumentError("obj cannot be null");
			}
			
			var cls : Class = null;
			
			try
			{
				cls = (obj as Class) || (obj.constructor as Class);
			}
			catch(ref : Error) // for when obj has no constructor property (why does it not extend Error or have an ID?)
			{
			}
			
			if (cls == null)
			{
				cls = getDefinitionByName(getQualifiedClassName(obj)) as Class;
			}
			
			return _typeProvider.getType(cls, ApplicationDomain.currentDomain);
		}
		
		private static var _typeProvider : ITypeProvider = new DescribeTypeTypeProvider();
		
		private static var _star : Type = createStar();
		public static function get star() : Type { return _star; }
		
		private static function createStar() : Type
		{
			return new Type(
				new QualifiedName(BCNamespace.packageNS("*"), "*")
			);
		}
		
		private static var _void : Type;
		public static function get voidType() : Type 
		{
			if (_void == null)
			{
				_void = new Type(
					new QualifiedName(BCNamespace.packageNS(""), "void")
				);
			}
			
			return _void;
		}
		
		private static var _rest : Type = createRest();
		public static function get rest() : Type { return _rest; }
		
		private static function createRest() : Type
		{
			return new Type(
				new QualifiedName(BCNamespace.packageNS(""), "...")
			);
		}
	}
}