package org.mockito.asmock.framework
{
	/**
	 * An error thrown when a method is called in replay mode that was not expected 
	 * at the time it was called or with the arguments passed. 
	 */	
	public class ExpectationViolationError extends MockError
	{
		public function ExpectationViolationError(message:String="", id:int=0)
		{
			super(message, id);
		}
		
	}
}