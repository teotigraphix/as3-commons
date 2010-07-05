package org.mockito.asmock.framework.constraints
{
	import mx.utils.StringUtil;
	
	public class StartsWith extends AbstractConstraint
	{
		private var _value : String;
		
		public function StartsWith(value : String)
		{
			if (value == null || value.length == 0)
			{
				throw new ArgumentError("value cannot be null or empty");
			}
			
			_value = value;
		}
		
		public override function eval(obj:Object):Boolean 
		{
			if (obj == null)
			{
				return false;
			}
			
			var objValue : String = obj.toString();
			var index : int = objValue.indexOf(_value);
			
			return (index == 0);
		}
		
		public override function get message():String
		{
			return "starts with \"".concat(_value, "\"");
		}
	}
}