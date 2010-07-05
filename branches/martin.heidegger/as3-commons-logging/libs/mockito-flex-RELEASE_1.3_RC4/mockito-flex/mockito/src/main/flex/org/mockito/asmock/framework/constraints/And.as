package org.mockito.asmock.framework.constraints
{
	import org.mockito.asmock.util.*;
	
	public class And extends AbstractConstraint
	{
		private var _constraints : Array;
		
		public function And(constraints : Array)
		{
			if (constraints == null || constraints.length < 2)
			{
				throw new ArgumentError("At least two constraints are required for the And constraint");
			}
			
			for each(var constraint : Object in constraints)
			{
				if ((constraint as AbstractConstraint) == null)
				{
					throw new ArgumentError("Invalid constraint");
				}
			}
			
			_constraints = constraints;
		}
		
		public override function eval(obj:Object):Boolean
		{
			for each(var constraint : AbstractConstraint in _constraints)
			{
				if (!constraint.eval(obj))
				{
					return false;
				}
			}
			
			return true;
		}
		
		public override function get message():String
		{
			var sb : StringBuilder = new StringBuilder();
			
			sb.append("(");
			
			for (var i:uint=0;i<_constraints.length;i++)
			{
				if (i>0)
				{
					sb.append(") and (");
				}
				
				sb.append(_constraints[i].message);
			}
			
			sb.append(")");
			
			return sb.toString();
		}
	}
}