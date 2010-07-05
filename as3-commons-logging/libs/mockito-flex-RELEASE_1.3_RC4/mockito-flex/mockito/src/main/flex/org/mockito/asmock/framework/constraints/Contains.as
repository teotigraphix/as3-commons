package org.mockito.asmock.framework.constraints
{
	public class Contains extends AbstractConstraint
	{
		private var _innerString : String;
		
		public function Contains(innerString : String)
		{
			if (innerString == null || innerString.length == 0)
			{
				throw new ArgumentError("innerString cannot be null or empty");
			}
			
			_innerString = innerString;
		}
		
		public override function eval(obj:Object):Boolean 
		{
			return (obj != null) && (obj.toString().indexOf(_innerString) > -1);
		}
		
		public override function get message():String
		{
			return "contains \"".concat(_innerString, "\"");
		}
		

	}
}