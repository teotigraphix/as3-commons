package org.mockito.asmock.framework.util
{
	import org.mockito.asmock.reflection.*;
	import org.mockito.asmock.util.StringBuilder;
	
	import flash.utils.getQualifiedClassName;
	
	[ExcludeClass]
	public class MethodUtil
	{
		public static function getRequiredArgumentCount(method :  MethodInfo) : uint
		{
			var i : uint = 0;
			
			for (; i<method.parameters.length; i++)
			{
				var param : ParameterInfo = method.parameters[i];
				
				if (param.optional)
				{
					return i;
				}
			}
			
			return method.parameters.length;
		}
		
		private static function defaultFormatArgument(args : Array, index : uint) : String
		{
			if (args.length <= index)
			{
				return "missing argument";
			}
			
			var arg : * = args[index];
			
			if (arg is Array)
			{
				var array : Array = arg as Array;
				
				var sb : StringBuilder = new StringBuilder();
				
				sb.append("[");
				
				for (var j:uint=0; j<array.length; j++)
				{
					if (j > 0)
					{
						sb.append(", ");
					}
					
					sb.append(defaultFormatArgument(array, j));
				}
				
				sb.append("]");
				
				return sb.toString();
			}
			
			if (arg is String)
			{
				return "\"".concat(arg, "\"");
			}
			
			if (arg == null)
			{
				return "null";
			}
			
			if (arg == undefined)
			{
				return "undefined";
			}
			
			try
			{
				return arg.toString();
			}
			catch(err : Error)
			{
				return "[" + getQualifiedClassName(arg) + "]";
			}
			
			return null;
		}
		
		public static function formatMethod(method : MethodInfo, args : Array, formatter : Function = null) : String 
		{
			formatter = formatter || defaultFormatArgument;
			
			var sb : StringBuilder = new StringBuilder();
			
			var property : PropertyInfo = getPropertyFromMethod(method);
			
			var methodName : String = formatMethodName(property, method);
			
			sb.append(methodName);
			
			sb.append("(");
			
			for (var i:uint=0; i<args.length; i++)
			{
				if (i > 0)
				{
					sb.append(", ");
				}
				
				sb.append(formatter(args, i));
			}
			
			sb.append(");");
			
			return sb.toString();
		}

		public static function formatMethodSignature(method : MethodInfo) : String
		{
			var sb : StringBuilder = new StringBuilder();
			
			sb.append("(");
			
			for (var i:uint=0; i<method.parameters.length; i++)
			{
				if (i > 0)
				{
					sb.append(", ");
				}
				
				sb.append(method.parameters[i].type.name);
			}
			
			sb.append(") : ");
			sb.append(method.returnType.name);
			
			return sb.toString();
		}
		
		public static function signaturesMatch(methodA : MethodInfo, methodB : MethodInfo) : Boolean
		{
			if (methodA.returnType != methodB.returnType)
			{
				return false;
			}
			
			if (methodA.parameters.length != methodB.parameters.length)
			{
				return false;
			}
			
			for (var i:uint=0; i<methodA.parameters.length; i++)
			{
				if (methodA.parameters[i].type != methodB.parameters[i].type)
				{
					return false;
				}
			}
			
			return true;
		}
		
		private static function formatMethodName(property : PropertyInfo, method : MethodInfo) : String
		{
			var methodName : String = (property == null)
				? method.name
				: property.name + "/" + method.name;
			
			return getRealMethodOwner(property, method).fullName +
				"/" + methodName;
		}
		
		private static function getRealMethodOwner(property : PropertyInfo, method : MethodInfo) : Type  
		{
			// TODO: Put custom "Mocked" metadata on the class to mark it as mocked
			
			var type : Type = method.owner;
			
			var interfaces : Array = type.getInterfaces();
			
			if (type.baseType == Type.getType(Object))
			{
				if (interfaces.length > 0)
				{
					for each(var interfaceType : Type in interfaces)
					{
						if (typeHasMethod(interfaceType, property, method))
						{
							return interfaceType;
						}
					}
				}
				
				return type; 
			}
			else
			{
				return (typeHasMethod(type.baseType, property, method))
					? type.baseType
					: type;
			}
		}
		
		private static function typeHasMethod(type : Type, property : PropertyInfo, method : MethodInfo) : Boolean
		{
			if (property != null)
			{
				return type.getProperty(property.name, false) != null;
			}
			else
			{
				return type.getMethod(method.name, false) != null;
			}
		}
		
		private static function getPropertyFromMethod(method : MethodInfo) : PropertyInfo
		{
			var propertyRegex : RegExp = new RegExp("^.+\\/(.+)\/.+$");
			
			var match : Object = propertyRegex.exec(method.fullName);
			
			return (match != null)
				? method.owner.getProperty(match[1], true)
				: null;
		}
	}
}