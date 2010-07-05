package org.mockito.asmock.framework.impl
{
	import org.mockito.asmock.framework.MockRepository;
	import org.mockito.asmock.framework.expectations.IExpectation;

	[ExcludeClass]	
	public interface IRecordMockState extends IMockState
	{
		function get lastExpectation() : IExpectation;
		function set lastExpectation(value : IExpectation) : void;
		
		function get repository() : MockRepository;
		function get proxy() : Object;
	}
}