package org.mockito.asmock.framework.constraints
{
	public class PropertyConstraint extends AbstractConstraint
	{
		private var _propertyName : String;
		private var _constraint : AbstractConstraint;
		
		public function PropertyConstraint(propertyName : String, constraint : AbstractConstraint)
		{
			if (propertyName == null || propertyName.length == 0)
			{
				throw new ArgumentError("propertyName cannot be null or empty");
			}
			
			if (constraint == null)
			{
				throw new ArgumentError("constraint cannot be null");
			}
			
			_propertyName = propertyName;
			_constraint = constraint;
		}
		
		public override function eval(obj:Object):Boolean 
		{
			if (obj == null)
			{
				return false;
			}
			
			var propertyValue : Object;
			try
			{
				propertyValue = obj[_propertyName];
			}
			catch(err : Error)
			{
				if (err.errorID == PROPERTY_NOT_FOUND_ERRORID)
				{
					return false;
				}
				
				throw err;
			}
			return _constraint.eval(propertyValue);
		}

		public override function get message():String
		{
			return "property '".concat(_propertyName, "' ", _constraint.message);
		}
		
		private static const PROPERTY_NOT_FOUND_ERRORID : int = 1069;
	}
}