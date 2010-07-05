package org.mockito.asmock.framework
{
	/*
	TODO: Does this class need to exist? void can be passed as * into Expect.call() so 
	maybe not.
	*/
	
	/**
	 * Provides access to method options for the last executed call. Generally used for situations 
	 * where another method calls the mocked method during record mode. 
	 * @author Richard 
	 */
	public class LastCall
	{
		public function LastCall()
		{
		}
		
		internal static function getOptions() : IMethodOptions
		{
			use namespace asmock_internal;
			return MockRepository.lastRepository.lastMethodCall(MockRepository.lastRepository.lastMockedObject);
		}
		
		/**
		 * Specifies that any method calls should call the original implementation  
		 * of the method. This method cannot be used if the mock represents an interface.
		 * 
		 * Should not be used with returnValue, doAction or throwError 
		 * @param option A value of OriginalCallOptions
		 * @return The IMethodOptions for the current expectation
		 * @see OriginalCallOptions
		 */
		public static function callOriginalMethod(option : uint = 0x1) : IMethodOptions
		{
			return getOptions().callOriginalMethod(option);
		}
		
		/**
		 * Allows arguments to be constrained by criterea rather than their recorded values.
		 * @param constraints Array of AbstractConstraint objects, one for each parameter. Use And and Or to combine constraints.
		 * 
		 * Use the static methods on Is, Property and Text to create the constraints.
		 * 
		 * Should not be used with ignoreArguments()
		 * @return The method options for the current method
		 * @see asmock.framework.constraints.Is
		 * @see asmock.framework.constraints.Text
		 * @see asmock.framework.constraints.Property
		 * @see asmock.framework.constraints.And
		 * @see asmock.framework.constraints.Or
		 * @includeExample IMethodOptions_constraints.as 
		 */
		public static function constraints(constraints : Array) : IMethodOptions
		{
			return getOptions().constraints(constraints);
		}
		
		/**
		 * Delegates the execution of the method to the Function supplied. The function 
		 * will be executed in the context of the mock object and should match the signature 
		 * of the method being mocked.
		 * 
		 * Should not be used with callOriginalMethod, returnValue or throwError 
		 * @param action The function to be called instead of the method
		 * @return The method options for the current method
		 */
		public static function doAction(action : Function) : IMethodOptions
		{
			return getOptions().doAction(action);
		}
		
		/**
		 * Changes the current expectation to no longer require the same parameters as 
		 * it was recorded with.
		 * 
		 * Should not be used with constraints()
		 * @return The method options for the current method
		 */
		public static function ignoreArguments() : IMethodOptions
		{
			return getOptions().ignoreArguments();
		}
		
		/**
		 * Specifies a custom message for the expected method. Any expectation related 
		 * errors will contain this message, along with the related error message.
		 * @param text The text to associate with this expectation
		 * @return The method options for the current method
		 */
		public static function message(text : String) : IMethodOptions
		{
			return getOptions().message(text);
		}
		
		/**
		 * Specifies the value to return with the expected method is called
		 * 
		 * Should not be used with callOriginalMethod, doAction or throwError
		 * @param value The value to return.
		 * @return The method options for the current method
		 */
		public static function returnValue(value : Object) : IMethodOptions
		{
			return getOptions().returnValue(value);
		}
		
		/**
		 * Sets the error to throw with the expected method is called
		 * 
		 * Should not be used with callOriginalMethod, doAction or returnValue
		 * @param error The error to throw
		 * @return The method options for the current method
		 */
		public static function throwError(error : Error) : IMethodOptions
		{
			return getOptions().throwError(error);
		}
		
		/**
		 * Returns the expectation repeat options.
		 * @return The IRepeat interface
		 */
		public static function get repeat() : IRepeat
		{
			return getOptions().repeat;
		}

	}
}