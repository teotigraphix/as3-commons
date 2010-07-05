package org.mockito.asmock.reflection
{
	[ExcludeClass]
	public class ParameterInfo
	{
		private var _method : MethodInfo;
		private var _name : String;
		private var _type : Type;
		private var _optional : Boolean;
		
		public function ParameterInfo(/* method : MethodInfo,  */name : String, type : Type, optional : Boolean)
		{
			//_method = method;
			_name = name;
			_type = type;
			_optional = optional;
		}
		
		/* public function get method() : MethodInfo
		{
			return _method;
		} */
		
		public function get name() : String
		{
			return _name;
		}
		
		public function get type() : Type
		{
			return _type;
		}
		
		public function get optional() : Boolean
		{
			return _optional;
		}
	}
}