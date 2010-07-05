package org.mockito.asmock.framework
{
	import org.mockito.asmock.Enum;
	
	/**
	 * Represents the options available when calling IMethodOptions.callOriginalMethod
	 */	
	public class OriginalCallOptions extends Enum	
	{
		/**
	 	 * Specifies that calls to the method will not be verified 
	 	 * (and arguments/constraints will not be validated)
	 	 */	
		public static const NO_EXPECTATION : uint = 0x0;
		
		/**
	 	 * Specifies that calls to the calls to the method will  
	 	 * be verified with respect to arguments/constraints and repeat settings
	 	 */
		public static const CREATE_EXPECTATION : uint = 0x1;
	}
}