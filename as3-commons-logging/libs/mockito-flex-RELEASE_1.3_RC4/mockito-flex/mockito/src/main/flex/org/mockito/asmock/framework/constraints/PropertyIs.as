package org.mockito.asmock.framework.constraints
{
	public class PropertyIs extends PropertyConstraint
	{
		public function PropertyIs(propertyName : String, expectedValue : Object)
		{
			super(propertyName, new Equal(expectedValue));	
		}
	}
}