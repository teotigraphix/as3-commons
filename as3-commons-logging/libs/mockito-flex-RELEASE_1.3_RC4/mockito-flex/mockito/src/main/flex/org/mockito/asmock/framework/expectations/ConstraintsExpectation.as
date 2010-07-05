package org.mockito.asmock.framework.expectations
{
	import org.mockito.asmock.framework.constraints.AbstractConstraint;
	import org.mockito.asmock.framework.proxy.IInvocation;
	import org.mockito.asmock.framework.util.MethodUtil;
	import org.mockito.asmock.reflection.ParameterInfo;
	
	import flash.errors.IllegalOperationError;
	
	[ExcludeClass]
	public class ConstraintsExpectation extends AbstractExpectation
	{
		private var _constraints : Array;
		
		public function ConstraintsExpectation(constraints : Array, invocation : IInvocation, expectation : IExpectation = null)
		{
			super(invocation, expectation);
			
			_constraints = constraints;
			
			verifyConstraints();
		}
		
		protected override function doIsExpected(args : Array) : Boolean
		{
			verifyConstraintsCount(args);
			
			for (var i:uint = 0; i<args.length; i++)
			{
				if (!_constraints[i].eval(args[i]))
				{
					return false;
				}
			}
			
			return true;
		}
		
		public override function get errorMessage():String
		{
			var derivedMessage : String = MethodUtil.formatMethod(originalInvocation.method, originalInvocation.arguments, formatConstraint);
			
			return super.createErrorMessage(derivedMessage);
		}
		
		private function formatConstraint(args : Array, index : uint) : String
		{
			return AbstractConstraint(_constraints[index]).message;
		}
		
		private function verifyConstraintsCount(constraints : Array) : void
		{
			var requiredParams : int = getRequiredParameterCount();
			
			if (constraints.length < requiredParams  ||
				constraints.length > method.parameters.length)
		    {
		        throw new IllegalOperationError("The number of constraints is not the same as the number of the method's parameters!");
		    }
		}
		
		private function getRequiredParameterCount() : int
		{
			var paramCount : int = 0;
			
			for each(var param : ParameterInfo in method.parameters)
			{
				if (param.optional)
				{
					break;
				}
				
				paramCount++;
			}
			
			return paramCount;
		}
		
		private function verifyConstraints() : void
		{
		    verifyConstraintsCount(_constraints);
		    
		    for (var i : uint = 0; i < _constraints.length; i++)
		    {
		        if (_constraints[i] == null)
		        {
		            throw new IllegalOperationError("The constraint at index " + i.toString() + " is null! Use Is.Null() to represent null parameters.");
		        }
		    }
		}
		
		 
		
		 

	}
}