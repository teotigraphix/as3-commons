package org.mockito.asmock.framework.constraints
{
	import mx.collections.IList;
	
	public class ListLength extends AbstractConstraint
	{
		private var _constraint : AbstractConstraint;
		
		public function ListLength(constraint : AbstractConstraint)
		{
			if (constraint == null)
			{
				throw new ArgumentError("constraint cannot be null");
			}
			
			_constraint = constraint;
		}
		
		public override function eval(obj:Object):Boolean	
		{
			var lst : IList = obj as IList;
			return (lst != null) && _constraint.eval(lst.length);
		}
		
		public override function get message():String
		{
			return "list length " + _constraint.message;
		}
	}
}