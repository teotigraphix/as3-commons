package org.mockito.asmock.framework.constraints
{
	import org.mockito.asmock.framework.Validate;
	
	public class Equal extends AbstractConstraint
	{
		private var _value : Object;
		
		public function Equal(value : Object)
		{
			_value = value;
		}
		
		public override function eval(obj:Object):Boolean
		{
			return Validate.argsEqual([_value], [obj]);
		}
		
		public override function get message():String
		{
			var str : String = (_value == null) ? "null" : _value.toString();
			
			return "equal to " + str;
		}

	}
}