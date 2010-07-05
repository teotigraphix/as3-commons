package org.mockito.asmock.framework.constraints
{
	public class Not extends AbstractConstraint
	{
		private var _constraint : AbstractConstraint;
		
		public function Not(constraint : AbstractConstraint)
		{
			if (constraint == null)
			{
				throw new ArgumentError("constraint cannot be null");
			}
			
			_constraint = constraint;
		}
		
		public override function eval(obj:Object):Boolean
		{
			return !_constraint.eval(obj);
		}
		
		public override function get message():String
		{
			return "not " + _constraint.message;
		}

	}
}