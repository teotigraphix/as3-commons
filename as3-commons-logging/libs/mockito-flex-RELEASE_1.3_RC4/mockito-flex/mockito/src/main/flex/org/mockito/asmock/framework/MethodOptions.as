package org.mockito.asmock.framework
{
	import org.mockito.asmock.framework.expectations.AnyArgsExpectation;
	import org.mockito.asmock.framework.expectations.ConstraintsExpectation;
	import org.mockito.asmock.framework.expectations.IExpectation;
	import org.mockito.asmock.framework.impl.IEventRaiser;
	import org.mockito.asmock.framework.OriginalCallOptions;
	import org.mockito.asmock.framework.impl.IRecordMockState;
	import org.mockito.asmock.framework.impl.RepeatableOption;
	
	import org.mockito.asmock.framework.asmock_internal;
	
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	[ExcludeClass]
	public class MethodOptions implements IMethodOptions, IRepeat
	{
		private var _repository : MockRepository;
		private var _record : IRecordMockState;
		private var _proxy : Object;
		private var _expectation : IExpectation;
		private var _expectationReplaced : Boolean;
		
		public function MethodOptions(repository : MockRepository, record : IRecordMockState, proxy : Object, expectation : IExpectation)
		{
			_repository = repository;
			_record = record;
			_proxy = proxy;
			_expectation = expectation;
			_expectationReplaced = false;
		}
		
		public function any() : IMethodOptions
		{
			_expectation.expected = new Range(0x0, 0x7FFFFF);
			_expectation.repeatableOption = RepeatableOption.ANY;

			this._repository.asmock_internal::replayer.addToRepeatableMethods(_proxy, _expectation.method, _expectation);
			
			return this;
		}
		
		public function atLeastOnce() : IMethodOptions
		{
			_expectation.expected = new Range(1, 0x7FFFFFF);
			
			return this;
		}
		
		public function callOriginalMethod(option : uint = 0x0) : IMethodOptions
		{
			if (option == OriginalCallOptions.NO_EXPECTATION)
			{
				this._expectation.repeatableOption = RepeatableOption.ORIGINAL_CALL_BYPASSING_MOCKING;
			}
			else
			{
				this._expectation.repeatableOption = RepeatableOption.ORIGINAL_CALL;
			}
			
			return this;
		}
		
		public function constraints(constraints : Array) : IMethodOptions
		{
			if (_expectation is ConstraintsExpectation)
			{
				throw new IllegalOperationError("You have already specified constraints for this method: " + _expectation.errorMessage);
			}
			
			var constraintsExpectation : ConstraintsExpectation = new ConstraintsExpectation(constraints, null, _expectation);
			this.replaceExpectation(constraintsExpectation);
			
			return this;
		}
		
		public function doAction(action : Function) : IMethodOptions 
		{
			_expectation.actionToExecute = action;
			return this;
		}
		
		// TODO: Is this functionality even required?
		public function getEventRaiser() : IEventRaiser
		{
			assertLastMethodWasEventAddOrRemove();
			
			throw new IllegalOperationError("Not supported");
			//return new EventRaiser(_proxy as IEventDispatcher, _expectation
		}
		
		public function ignoreArguments() : IMethodOptions
		{
			var anyArgsExpectation : AnyArgsExpectation = new AnyArgsExpectation(_expectation);
			
			this.replaceExpectation(anyArgsExpectation);
			
			return this;
		}
		
		public function message(text : String) : IMethodOptions
		{
			_expectation.message = text;
			
			return this;
		}
		
		public function never() : IMethodOptions
		{
			_expectation.expected = new Range(0, 0);
			_expectation.errorToThrow = new IllegalOperationError("This method should not be called");
			_expectation.repeatableOption = RepeatableOption.NEVER;
			
			// repository.replayer.addToRepeatableMethods
			
			return this;			
		}
		
		public function once() : IMethodOptions
		{
			_expectation.expected = new Range(1, 1);
			return this;
		}
		
		public function propertyBehavior() : IMethodOptions	
		{
			throw new IllegalOperationError("Not supported");
		}
		
		public function returnValue(value : Object) : IMethodOptions
		{
			_expectation.returnValue = value;
			
			return this;
		}
		
		public function throwError(error : Error) : IMethodOptions
		{
			_expectation.errorToThrow = error;
			
			return this;
		}
		
		public function dispatchEvent(event : Event) : IMethodOptions
		{
			_expectation.eventToDispatch = event;
			
			return this;
		}
		
		public function times(min : uint, max : uint) : IMethodOptions
		{
			_expectation.expected = new Range(min, max);
			
			return this;
		}
		
		public function twice() : IMethodOptions
		{
			_expectation.expected = new Range(2, 2);
			
			return this;
		}
		
		public function get repeat() : IRepeat
		{
			return this;
		}
		
		private function assertLastMethodWasEventAddOrRemove() : void
		{
			if (!(_expectation.method.name == "addEventListener" || _expectation.method.name == "removeEventListener"))
			{
				throw new IllegalOperationError("The last method call " + _expectation.method + " was not an event add/remove method");
			}
		}
		
		private function replaceExpectation(expectation : IExpectation) : void
		{
			if (!(!_expectationReplaced || _expectation is AnyArgsExpectation))
			{
				throw new IllegalOperationError("This method has already been set to " + getQualifiedClassName(_expectation));
			}
			
			_repository.asmock_internal::recorder.replaceExpectation(_proxy, _expectation.method, _expectation, expectation);
			_expectation = expectation;
			_record.lastExpectation = expectation;
			_expectationReplaced = true;
		}
	}
}