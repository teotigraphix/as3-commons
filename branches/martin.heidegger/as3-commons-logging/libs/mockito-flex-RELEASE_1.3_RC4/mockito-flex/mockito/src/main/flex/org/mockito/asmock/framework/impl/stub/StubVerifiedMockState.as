package org.mockito.asmock.framework.impl.stub
{
	import org.mockito.asmock.framework.IMethodOptions;
	import org.mockito.asmock.framework.impl.IMockState;
	import org.mockito.asmock.framework.proxy.IInvocation;
	import org.mockito.asmock.reflection.MethodInfo;
	
	import flash.errors.IllegalOperationError;
	
	[ExcludeClass]
	public class StubVerifiedMockState implements IMockState
	{
		private var _previous : IMockState;
		
		public function StubVerifiedMockState(previous : IMockState)
		{
			_previous = previous;
		}
		
		public function getLastMethodOptions() : IMethodOptions
		{
			throw invalidInVerifiedState();
		}
		
		public function backToRecord() : IMockState
		{
			return this._previous.backToRecord();
		}
		
		public final function get canReplay() : Boolean
		{
			return false;
		}
		
		public function replay() : IMockState
		{
			throw invalidInVerifiedState();
		}
		
		public function get canVerify() : Boolean
		{
			return false;
		}
		
		public function verify() : void
		{
			throw invalidInVerifiedState();
		}
		
		public function get verifyState() : IMockState
		{
			throw invalidInVerifiedState();
		}
		
		public function methodCall(invocation : IInvocation, method : MethodInfo, args : Array) : Object
		{
			throw invalidInVerifiedState();
		}
		
		public function setVerifyError(error : Error) : void
		{
		}

		private function invalidInVerifiedState() : Error
		{
			return new IllegalOperationError("This action is invalid when the mock object is in verified state.");
		}
	}
}