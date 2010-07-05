package org.mockito.asmock.framework.impl
{
	import org.mockito.asmock.framework.IMethodOptions;
	import org.mockito.asmock.framework.proxy.IInvocation;
	import org.mockito.asmock.reflection.MethodInfo;
	
	[ExcludeClass]
	public interface IMockState
	{
		function backToRecord() : IMockState;
		function replay() : IMockState;
		function verify() : void;
		function get verifyState() : IMockState;
		
		function get canVerify() : Boolean;
		function get canReplay() : Boolean;
		
		function methodCall(invocation : IInvocation, method : MethodInfo, args : Array) : Object;
		function setVerifyError(error : Error) : void;
		function getLastMethodOptions() : IMethodOptions;
	}
}