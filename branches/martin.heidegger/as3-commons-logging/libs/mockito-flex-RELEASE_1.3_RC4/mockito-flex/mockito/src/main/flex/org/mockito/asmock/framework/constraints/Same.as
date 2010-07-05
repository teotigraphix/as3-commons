package org.mockito.asmock.framework.constraints
{
	import org.mockito.asmock.framework.Validate;
	
	public class Same extends AbstractConstraint
	{
		private var _value : Object;
		
		public function Same(value : Object)
		{
			_value = value;
		}
		
		public override function eval(obj:Object):Boolean
		{
			return _value === obj;
		}
		
		public override function get message():String
		{
			var str : String = (_value == null) ? "null" : _value.toString();
			
			return "same as " + str;
		}

	}
}