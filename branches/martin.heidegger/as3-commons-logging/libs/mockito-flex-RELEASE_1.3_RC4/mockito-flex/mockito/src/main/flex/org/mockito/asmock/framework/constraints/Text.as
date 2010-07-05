package org.mockito.asmock.framework.constraints
{
	public class Text
	{
		public static function contains(innerString : String) : AbstractConstraint
		{
			return new Contains(innerString);
		}
		
		public static function startsWith(start : String) : AbstractConstraint
		{
			return new StartsWith(start);
		}
		
		public static function endsWith(end : String) : AbstractConstraint
		{
			return new EndsWith(end);
		}
		
		public static function like(expression : RegExp) : AbstractConstraint
		{
			return new Like(expression);
		}

	}
}