package org.mockito.asmock.framework
{
	import flash.errors.IllegalOperationError;
	
	/**
	 * Creates an expectation on a mock object 
	 * @author Richard
	 */	
	public class Expect
	{
		[Exclude]
		public function Expect()
		{
			throw new IllegalOperationError("This class is static");
		}
		
		/**
		 * Creates an expectation on the method executed 
		 * @param ignored
		 * @return The IMethodOptions for the expectation
		 * @see IMethodOptions
		 * @includeExample Expect_call.as
		 */
		public static function call(ignored : *) : IMethodOptions
		{
			return LastCall.getOptions();
		}
		
		/**
		 * Creates an expectation that the executed method will never be called. 
		 * @param ignored
		 * @return The IMethodOptions for the expectation
		 * @see IMethodOptions
		 * @includeExample Expect_call.as
		 */		
		public static function notCalled(ignored : *) : IMethodOptions
		{
			return LastCall.getOptions().repeat.never();
		}
	}
}