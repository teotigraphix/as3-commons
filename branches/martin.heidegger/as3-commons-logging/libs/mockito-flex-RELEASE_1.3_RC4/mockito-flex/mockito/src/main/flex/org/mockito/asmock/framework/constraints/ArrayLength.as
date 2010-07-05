package org.mockito.asmock.framework.constraints
{
	public class ArrayLength extends AbstractConstraint
	{
		private var _constraint : AbstractConstraint;
		
		public function ArrayLength(constraint : AbstractConstraint)
		{
			if (constraint == null)
			{
				throw new ArgumentError("constraint cannot be null");
			}
			
			_constraint = constraint;
		}
		
		public override function eval(obj:Object):Boolean	
		{
			var arr : Array = obj as Array;
			return (arr != null) && _constraint.eval(arr.length);
		}
		
		public override function get message():String
		{
			return "array length " + _constraint.message;
		}

	}
}