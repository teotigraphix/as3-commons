package org.mockito.asmock.framework.expectations
{
	import org.mockito.asmock.framework.Range;
	import org.mockito.asmock.framework.impl.RepeatableOption;
	import org.mockito.asmock.framework.proxy.IInvocation;
	import org.mockito.asmock.reflection.MethodInfo;
	import org.mockito.asmock.reflection.Type;
	import org.mockito.asmock.util.StringBuilder;
	
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	[ExcludeClass]
	public class AbstractExpectation implements IExpectation
	{
		private var _invocation : IInvocation;
		private var _expectation : IExpectation;

		private var _expected : Range;
		private var _repeatableOption : uint;
		private var _errorToThrow : Error;
		private var _eventToDispatch : Event;
		private var _message : String;
		private var _actionToExecute : Function;
		private var _actualCallsCount : uint;
		
		private var _returnValue : Object;
		private var _returnValueSet : Boolean;
		
		public function AbstractExpectation(invocation : IInvocation = null, expectation : IExpectation = null)
		{
			if (expectation != null)
			{
				_invocation = expectation.originalInvocation;
				_expectation = expectation;
				
				_returnValue = expectation.returnValue;
				_returnValueSet = expectation.hasReturnValue;
				_expected = expectation.expected;
				_actualCallsCount = expectation.actualCallsCount;
				_repeatableOption = expectation.repeatableOption;
				_errorToThrow = expectation.errorToThrow;
				_message = expectation.message;
			}
			else
			{
				_repeatableOption = RepeatableOption.NORMAL;
				_invocation = invocation;
				_expected = new Range(1, 1);
				_returnValueSet = false;
			}
		}

		public function get expected() : Range { return _expected; }
		public function set expected(value : Range) : void { _expected = value; }
		
		public function get repeatableOption() : uint { return _repeatableOption; }
		public function set repeatableOption(value : uint) : void { _repeatableOption = value; }
		
		public function get errorToThrow() : Error { return _errorToThrow; }
		public function set errorToThrow(value : Error) : void { _errorToThrow = value; }
		
		public function get eventToDispatch() : Event { return _eventToDispatch; }
		public function set eventToDispatch(value : Event) : void { proxyIsEventDispatcher(); _eventToDispatch = value; }
		
		public function get message() : String { return _message; }
		public function set message(value : String) : void { _message = value; }
		
		public function get errorMessage() : String 
		{
			throw new IllegalOperationError("This property is absract and must be overriden");
		}
		
		public function get actionToExecute() : Function { return _actionToExecute; }
		public function set actionToExecute(value : Function) : void
		{
			actionOnMethodNotSpecified();
			checkMethodSignature(value);
			_actionToExecute = value;
		}
		
		public function get actualCallsCount() : uint { return _actualCallsCount; }
		
		public function get canAcceptCalls() : Boolean
		{
			return (_repeatableOption == RepeatableOption.ANY) ||
					(_repeatableOption == RepeatableOption.ORIGINAL_CALL_BYPASSING_MOCKING) ||
				(_actualCallsCount < _expected.max);
		}
		
		public function get expectationSatisfied() : Boolean
		{
			return (_repeatableOption != RepeatableOption.NORMAL && _repeatableOption != RepeatableOption.ORIGINAL_CALL)
				|| (this._actualCallsCount >= _expected.min && _actualCallsCount <= _expected.max);
		}
		
		public function get returnValue() : Object { return _returnValue; }
		
		public function set returnValue(value : Object) : void
		{
			if (value != null)
			{			
				if (!_invocation.method.returnType.isAssignableFromInstance(value))
				{
					throw new ArgumentError("returnValue must be assignable from " + _invocation.method.returnType.fullName);
				}
			}
			
			_returnValue = value;
			_returnValueSet = true;
		}
		
		public function get hasReturnValue() : Boolean { return _returnValueSet; }
		
		public function get method() : MethodInfo { return _invocation.method; }
		
		public function isExpected(args : Array) : Boolean
		{
			return (_repeatableOption == RepeatableOption.ORIGINAL_CALL_BYPASSING_MOCKING) ||
					this.doIsExpected(args);
		}
		
		protected function doIsExpected(args : Array) : Boolean
		{
			throw new IllegalOperationError("isExpected is abstract and must be overriden");
		}
		
		public function addActualCall() : void
		{
			_actualCallsCount++;
		}
		
		public function get actionsSatisfied() : Boolean
		{
			return _invocation.method.returnType == Type.voidType ||
					_errorToThrow != null || 
					(_actionToExecute != null || _returnValueSet) ||
					(_repeatableOption == RepeatableOption.ORIGINAL_CALL ||
					_repeatableOption == RepeatableOption.ORIGINAL_CALL_BYPASSING_MOCKING ||
					_repeatableOption == RepeatableOption.PROPERTY_BEHAVIOR);					
		}
		
		public function returnOrThrow(invocation : IInvocation, args : Array) : Object
		{
			if (!actionsSatisfied)
			{
				throw new IllegalOperationError("Method " + errorMessage + " requires a return value or an error to throw");
			}
			
			if (_eventToDispatch != null)
			{
				(invocation.proxy as IEventDispatcher).dispatchEvent(_eventToDispatch);
			}
			
			if (_actionToExecute != null)
			{
				var ret : Object = _actionToExecute.apply(invocation.proxy, args);
				
				return ret;
			}
			
			if (_errorToThrow != null)
			{
				throw _errorToThrow;
			}
			
			if (_repeatableOption == RepeatableOption.ORIGINAL_CALL ||
				_repeatableOption == RepeatableOption.ORIGINAL_CALL_BYPASSING_MOCKING)
			{
				invocation.proceed();
				
				_returnValue = invocation.returnValue;
			}
			
			return _returnValue;
		}
		
		public function buildVerificationFailureMessage() : String
		{
			var sb : StringBuilder = new StringBuilder();
			
			sb.append(errorMessage);
			sb.appendFormat(" Expected #{0}", expected.toString());
			sb.appendFormat(" Actual #{0}", actualCallsCount);
			
			return sb.toString();
		}
		
		public function get originalInvocation() : IInvocation
		{
			return _invocation;
		}
		
		private function actionOnMethodNotSpecified() : void
		{
			if (_returnValueSet || _errorToThrow != null || _actionToExecute != null)
			{
				throw new IllegalOperationError("Can only set a single return value or exception to throw or action to execute on the same method call");
			}
		}
		
		private function proxyIsEventDispatcher() : void
		{
			var eventDispatcherType : Type = Type.getType(IEventDispatcher);
			var proxyType : Type = Type.getType(_invocation.proxy);
			
			if (!eventDispatcherType.isAssignableFrom(proxyType))
			{
				throw new IllegalOperationError("eventToDispatch can only be used on mocks that implement IEventDispatcher");
			}
		}
		
		private function checkMethodSignature(delegate : Function) : void
		{
			// TODO: Im not sure this is possible
		}
		
		protected function createErrorMessage(derivedMessage : String) : String
		{
			if (_message == null)
			{
				return derivedMessage;
			}
			
			return "Message: ".concat(_message ,"\n", derivedMessage);
		}
		
	}
}