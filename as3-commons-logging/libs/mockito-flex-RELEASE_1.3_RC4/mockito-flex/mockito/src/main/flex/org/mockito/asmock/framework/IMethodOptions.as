package org.mockito.asmock.framework
{
	import flash.events.Event;
	
	/**
	 * Represents the available options on the current method call expectation. Either 
	 * returnValue, throwError, doAction or callOriginalMethod must be called before 
	 * the next expectation can be recorded. 
	 * @author Richard
	 */
	public interface IMethodOptions
	{
		/**
		 * Specifies that any method calls should call the original implementation  
		 * of the method. This method cannot be used if the mock represents an interface.
		 * 
		 * Should not be used with returnValue, doAction or throwError 
		 * @param option A value of OriginalCallOptions
		 * @return The IMethodOptions for the current expectation
		 * @see OriginalCallOptions
		 * @includeExample IMethodOptions_callOriginalMethod.as
		 */
		function callOriginalMethod(option : uint = 0x0) : IMethodOptions;
		
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
		function constraints(constraints : Array) : IMethodOptions;
		
		/**
		 * Delegates the execution of the method to the Function supplied. The function 
		 * will be executed in the context of the mock object and should match the signature 
		 * of the method being mocked.
		 * 
		 * Should not be used with callOriginalMethod, returnValue or throwError 
		 * @param action The function to be called instead of the method
		 * @return The method options for the current method
		 * @includeExample IMethodOptions_doAction.as
		 */
		function doAction(action : Function) : IMethodOptions;
		
		/**
		 * Changes the current expectation to no longer require the same parameters as 
		 * it was recorded with.
		 * 
		 * Should not be used with constraints()
		 * @return The method options for the current method
		 * @includeExample IMethodOptions_ignoreArguments.as
		 */
		function ignoreArguments() : IMethodOptions;
		
		/**
		 * Specifies a custom message for the expected method. Any expectation related 
		 * errors will contain this message, along with the related error message.
		 * @param text The text to associate with this expectation
		 * @return The method options for the current method
		 * @includeExample IMethodOptions_message.as
		 */
		function message(text : String) : IMethodOptions;
		
		/**
		 * Specifies the value to return with the expected method is called
		 * 
		 * Should not be used with callOriginalMethod, doAction or throwError
		 * @param value The value to return.
		 * @return The method options for the current method
		 * @includeExample IMethodOptions_returnValue.as
		 */		
		function returnValue(value : Object) : IMethodOptions;
		
		/**
		 * Sets the error to throw with the expected method is called
		 * 
		 * Should not be used with callOriginalMethod, doAction or returnValue
		 * @param error The error to throw
		 * @return The method options for the current method
		 * @includeExample IMethodOptions_throwError.as
		 */		
		function throwError(error : Error) : IMethodOptions;
		
		/**
		 * Dispatches an event when the expected method is called 
		 * @param event The event to raise
		 * @return The method options for the current method
		 * @includeExample IMethodOptions_dispatchEvent.as
		 */		
		function dispatchEvent(event : Event) : IMethodOptions;
		
		/**
		 * Returns the expectation repeat options.
		 * @return The IRepeat interface
		 * @includeExample IRepeat_times.as
		 */
		function get repeat() : IRepeat;
	}
}