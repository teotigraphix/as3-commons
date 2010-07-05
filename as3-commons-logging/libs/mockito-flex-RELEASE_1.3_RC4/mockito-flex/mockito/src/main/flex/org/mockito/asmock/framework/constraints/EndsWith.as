package org.mockito.asmock.framework.constraints
{
	import mx.utils.StringUtil;
	
	public class EndsWith extends AbstractConstraint
	{
		private var _value : String;
		
		public function EndsWith(value : String)
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
			
			return (index > -1) && (index == objValue.length - _value.length);
		}
		
		public override function get message():String
		{
			return "ends with \"".concat(_value, "\"");
		}
	}
}