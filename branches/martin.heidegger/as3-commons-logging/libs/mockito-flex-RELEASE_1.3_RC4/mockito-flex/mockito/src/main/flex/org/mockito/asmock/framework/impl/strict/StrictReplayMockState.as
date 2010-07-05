package org.mockito.asmock.framework.impl.strict
{
	import org.mockito.asmock.framework.impl.IMockState;
	import org.mockito.asmock.framework.impl.IRecordMockState;
	import org.mockito.asmock.framework.ExpectationViolationError;
	import org.mockito.asmock.framework.IMethodOptions;
	import org.mockito.asmock.framework.MockRepository;
	import org.mockito.asmock.framework.expectations.IExpectation;
	import org.mockito.asmock.framework.proxy.IInvocation;
	import org.mockito.asmock.reflection.MethodInfo;
	import org.mockito.asmock.util.StringBuilder;
	
	import flash.errors.IllegalOperationError;
	
	import org.mockito.asmock.framework.asmock_internal;
	
	[ExcludeClass]
	public class StrictReplayMockState implements IMockState
	{
		private var _errorToThrowOnVerify : Error;
		protected var _proxy : Object;
		protected var _repository : MockRepository;
		
		public function StrictReplayMockState(previousState : IRecordMockState)
		{
			_repository = previousState.repository;
			_proxy = previousState.proxy;
		}
		
		public function getLastMethodOptions() : IMethodOptions
		{
			throw invalidActionOnReplay();
		}
		
		public function backToRecord() : IMockState
		{
			return new StrictRecordMockState(_proxy, _repository);
		}
		
		public final function get canReplay() : Boolean
		{
			return false;
		}
		
		public function replay() : IMockState
		{
			throw invalidActionOnReplay(); 
		}
		
		public final function methodCall(invocation : IInvocation, method : MethodInfo, args : Array) : Object
		{
			var expectation : IExpectation = _repository.asmock_internal::replayer.getRepeatableExpectation(_proxy, method, args);
			
			if (expectation != null)
			{
				return expectation.returnOrThrow(invocation, args);
			}
			
			return doMethodCall(invocation, method, args);
		}
		
		protected function doMethodCall(invocation : IInvocation, method : MethodInfo, args : Array) : Object
		{
			var expectation : IExpectation = _repository.asmock_internal::replayer.getRecordedExpectation(invocation, _proxy, method, args);
			
			return expectation.returnOrThrow(invocation, args);
		}
		
		public function get canVerify() : Boolean
		{
			return true;
		}
		
		public function verify() : void
		{
			if (_errorToThrowOnVerify != null)
			{
				throw _errorToThrowOnVerify;
			}
			
			var expectations : Array = _repository.asmock_internal::recorder.getAllExpectationsForProxy(_proxy);
			
			var message : StringBuilder = new StringBuilder();
			var first : Boolean = true;
			
			for each(var expectation : IExpectation in expectations)
			{
				if (!expectation.expectationSatisfied)
				{
					if (!first)
					{
						message.append('\n');						
					}
					
					message.append(expectation.buildVerificationFailureMessage());
					first = false;
				}
			}
			
			if (message.length > 0)
			{
				throw new ExpectationViolationError(message.toString());
			}
		}
		
		public function get verifyState() : IMockState
		{
			return new StrictVerifiedMockState(this);
		}
		
		public function setVerifyError(error : Error) : void
		{
			this._errorToThrowOnVerify = error;
		}
		
		private function invalidActionOnReplay() : Error
		{
			return new IllegalOperationError("Action is illegal when object is in replay state");
		}
	}
}