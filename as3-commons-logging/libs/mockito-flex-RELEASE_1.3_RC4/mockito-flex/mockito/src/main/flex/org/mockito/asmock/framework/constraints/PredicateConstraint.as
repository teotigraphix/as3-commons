package org.mockito.asmock.framework.constraints
{
	import flash.errors.IllegalOperationError;
	
	public class PredicateConstraint extends AbstractConstraint
	{
		private var _func : Function;
		
		public function PredicateConstraint(func : Function)
		{
			if (func == null)
			{
				throw new ArgumentError("func cannot be null");
			}
			
			_func = func;
		}
		
		public override function eval(obj:Object):Boolean
		{
			return _func(obj) as Boolean;
		}
		
		public override function get message():String
		{
			return "predicate";
		}
	}
}