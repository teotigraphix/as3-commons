package org.mockito.asmock.framework
{
	/**
	 * The base class for all ASMock related errors.
	 */	
	public class MockError extends Error
	{
		public function MockError(message : String = "", id : int = 0)
		{
			super(message, id);
		}
	}
}