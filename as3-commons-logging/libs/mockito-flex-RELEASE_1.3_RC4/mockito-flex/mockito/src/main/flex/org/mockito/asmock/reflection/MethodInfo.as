package org.mockito.asmock.reflection
{
	[ExcludeClass]
	public class MethodInfo extends MemberInfo
	{
		private var _returnType : Type;
		private var _parameters : Array;
		
		public function MethodInfo(type : Type, name : String, fullName : String, visibility : uint, isStatic : Boolean, isOverride : Boolean, returnType : Type,  parameters : Array, ns : String = null)
		{
			super(type, name, fullName, visibility, isStatic, isOverride, ns);
			
			_returnType= returnType;
			_parameters = new Array().concat(parameters || []);
		}
		
		public function get returnType() : Type
		{
			return _returnType;
		}
		
		public function get parameters() : Array
		{
			return [].concat(_parameters);
		}
		
		public function clone() : MethodInfo
		{
			return new MethodInfo(owner, name, fullName, visibility, isStatic, isOverride, returnType, parameters);
		}
		
		/**
		 * This method causes a performance hit due to an error being thrown. 
		 * Use with caution. 
		 * @return The method that called this method (excluding any embedded functions)
		 */		
		public static function getCallingMethod() : MethodInfo
		{
			try
			{
				throw new Error();
			}
			catch(error : Error)
			{
				var stackTrace : String = error.getStackTrace();
				
				var matchExpr : RegExp = /^\tat\s([^\/\$\n]+)(\$)?\/([^\(\n]+).+$/mg;
				var first : Boolean = true;
				var match : Object;
				
				while((match = matchExpr.exec(stackTrace)) != null)
				{
					// Skip getCallingMethod
					if (first)
					{
						first = false;
						continue;
					}
					
					var typeName : String = match[1].toString();
					var isStatic : Boolean = (match[2] == "$");
					var methodName : String = match[3].toString();
					
					try
					{
						var type : Type = Type.getTypeByName(typeName);
						
						if (type != null)
						{
							var method : MethodInfo = type.getMethod(methodName);
							
							if (method != null)
							{
								return method;
							}
						}
					}
					catch(e : Error)
					{
					}
				}
			}
			
			return null;
		}
	}
}