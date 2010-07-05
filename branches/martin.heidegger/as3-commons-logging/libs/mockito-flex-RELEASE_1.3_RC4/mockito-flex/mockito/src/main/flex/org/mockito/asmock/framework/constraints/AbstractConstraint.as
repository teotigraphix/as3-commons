package org.mockito.asmock.framework.constraints
{
	import flash.errors.IllegalOperationError;
	
	public class AbstractConstraint
	{
		public function AbstractConstraint()
		{
		}
		
		public function get message() : String
		{
			throw new IllegalOperationError("This property is abstract");
		}
		
		public function eval(obj : Object) : Boolean
		{
			throw new IllegalOperationError("eval method must be overidden");
		}

	}
}