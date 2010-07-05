package org.mockito.asmock.framework.impl.strict
{
	import org.mockito.asmock.framework.IMethodOptions;
	import org.mockito.asmock.framework.MethodOptions;
	import org.mockito.asmock.framework.MockRepository;
	import org.mockito.asmock.framework.expectations.ArgsEqualExpectation;
	import org.mockito.asmock.framework.expectations.IExpectation;
	import org.mockito.asmock.framework.impl.IMockState;
	import org.mockito.asmock.framework.impl.IRecordMockState;
	import org.mockito.asmock.framework.proxy.IInvocation;
	import org.mockito.asmock.reflection.MethodInfo;
	
	import org.mockito.asmock.framework.asmock_internal;
	
	import flash.errors.IllegalOperationError;
	
	[ExcludeClass]
	public class StrictRecordMockState implements IRecordMockState
	{
		protected var _mockObject : Object;
		protected var _repository : MockRepository;
		
		private var _lastExpectation : IExpectation;
		
		public function StrictRecordMockState(mockObject : Object, repository : MockRepository)
		{
			_mockObject = mockObject;
			_repository = repository;
		}

		public function backToRecord() : IMockState
		{
			return new StrictRecordMockState(_mockObject, _repository);
		}
		
		public final function get canReplay() : Boolean
		{
			return true;
		}
		
		public final function replay() : IMockState
		{
			assertLastMethodIsClosed()
			
			return this.doReplay();
		}
		
		protected function doReplay() : IMockState
		{
			return new StrictReplayMockState(this);
		}
		
		public function get canVerify() : Boolean
		{
			throw invalidActionOnRecord();
		}
		
		public function verify() : void
		{
			throw invalidActionOnRecord();
		}
		
		public function get repository() : MockRepository
		{
			return _repository;
		}
		
		public function get proxy() : Object
		{
			return _mockObject;
		}
		
		public function methodCall(invocation : IInvocation, method : MethodInfo, args : Array) : Object
		{
			assertLastMethodIsClosed();
			_repository.lastMockedObject = _mockObject;
			
			MockRepository.asmock_internal::lastRepository = _repository;
			
			var expectation : IExpectation = new ArgsEqualExpectation(invocation, args);
			
			_lastExpectation = expectation;
			
			_repository.asmock_internal::recorder.record(_mockObject, method, expectation);
			
			return null;
		}
		
		public function setVerifyError(error : Error) : void
		{
		}
		
		public function get verifyState() : IMockState
		{
			throw invalidActionOnRecord();
		}
		
		public function getLastMethodOptions() : IMethodOptions
		{
			if (_lastExpectation == null)
			{
				throw new IllegalOperationError("There is no matching last call on this object. Are you sure that the last call was non-final or an interface method call?");
			}
			
			return new MethodOptions(_repository, this, _mockObject, _lastExpectation);
		}
		
		public function get lastExpectation() : IExpectation { return _lastExpectation; }
		public function set lastExpectation(value : IExpectation) : void { _lastExpectation = value; }
		
		private function invalidActionOnRecord() : Error
		{
			return new IllegalOperationError("Action is illegal when object is in record state");
		}
		
		private function assertLastMethodIsClosed() : void
		{
			if (_lastExpectation != null && !_lastExpectation.actionsSatisfied) 
			{
				throw new IllegalOperationError("Previous method " + _lastExpectation.errorMessage + " requires a return value or an exception to throw");
			}
		}
	}
}