package org.mockito.asmock.framework.constraints
{
	public class Property
	{
		public static function isNotNull(propertyName : String) : AbstractConstraint
		{
			return new Not(new PropertyIs(propertyName, null));
		}
		
		public static function isNull(propertyName : String) : AbstractConstraint
		{
			return new PropertyIs(propertyName, null);
		}
		
		public static function value(propertyName : String, expectedValue : Object) : AbstractConstraint
		{
			return new PropertyIs(propertyName, expectedValue);
		}
		
		public static function valueConstraint(propertyName : String, constraint : AbstractConstraint) : AbstractConstraint
		{
			return new PropertyConstraint(propertyName, constraint);
		}

	}
}