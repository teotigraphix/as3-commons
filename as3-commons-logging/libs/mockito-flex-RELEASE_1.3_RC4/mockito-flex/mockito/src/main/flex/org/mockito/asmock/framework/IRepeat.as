package org.mockito.asmock.framework
{
	import org.mockito.asmock.framework.IMethodOptions;
	
	/**
	 * Allows selection of how many times a given method is expected to be executed 
	 * @author Richard
	 */	
	public interface IRepeat
	{
		/**
		 * Specifies that the expected method can repeat any number of times. 
		 * @return The IMethodOptions for the current expectation
		 */
		function any() : IMethodOptions;
		
		/**
		 * Specifies that the expected method must occur at least once, but has 
		 * no upper limit on the number of times it can occur
		 * @return The IMethodOptions for the current expectation
		 */
		function atLeastOnce() : IMethodOptions;
		
		/**
		 * Specifies that the expected method can never occur 
		 * @return The IMethodOptions for the current expectation
		 */
		function never() : IMethodOptions;
		
		/**
		 * Specifies that the expected method must occur once only 
		 * @return The IMethodOptions for the current expectation
		 */
		function once() : IMethodOptions;
		
		/**
		 * Specifies the number of times the expected method must repeat.
		 * @param min The minimum number of times the method must be executed
		 * @param max The maximum number of times the method must be executed 
		 * @return The IMethodOptions for the current expectation
		 */
		function times(min : uint, max : uint) : IMethodOptions;
		
		/**
		 * Specifies that the expected method must repeat twice. 
		 * @return The IMethodOptions for the current expectation
		 */
		function twice() : IMethodOptions;
	}
}