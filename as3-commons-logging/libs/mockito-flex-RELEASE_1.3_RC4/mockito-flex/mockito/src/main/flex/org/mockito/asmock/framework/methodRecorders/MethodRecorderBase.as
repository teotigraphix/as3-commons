package org.mockito.asmock.framework.methodRecorders
{
	import org.mockito.asmock.framework.*;
	import org.mockito.asmock.framework.expectations.*;
	import org.mockito.asmock.framework.impl.*;
	import org.mockito.asmock.framework.proxy.*;
	import org.mockito.asmock.framework.util.*;
	import org.mockito.asmock.reflection.*;
	import org.mockito.asmock.util.*;
	
	import org.mockito.asmock.framework.asmock_internal;
	
	import flash.errors.IllegalOperationError;
	
	[ExcludeClass]
	public class MethodRecorderBase implements IMethodRecorder
	{
		private var _recursionDepth : int = 0;
		
		protected var parentRecorder : IMethodRecorder;
		
		protected var recorderToCall : IMethodRecorder;
		protected var replayerToCall : IMethodRecorder;
		
		protected var recordedActions : Array;
		protected var repeatableMethods : ProxyMethodExpectationsDictionary;
		
		private var _replayersToIgnoreForThisCall : Array;
		
		public function MethodRecorderBase(repeatableMethods : ProxyMethodExpectationsDictionary, parentRecorder : IMethodRecorder = null)
		{
			if (repeatableMethods == null) throw new ArgumentError("repeatableMethods cannot be null");
			
			this.recordedActions = new Array();
			this.repeatableMethods = repeatableMethods;
			
			this.parentRecorder = parentRecorder;
			
			this._replayersToIgnoreForThisCall = new Array();
		}
		
		public final function addRecorder(recorder : IMethodRecorder) : void
		{
			if (this.recorderToCall != null)
			{
				this.recorderToCall.addRecorder(recorder);
			}
			else
			{
				this.doAddRecorder(recorder);
				this.recorderToCall = recorder;
			}
		}
		
		protected function doAddRecorder(recorder : IMethodRecorder) : void
		{
			throw new IllegalOperationError("Abstract");
		}
		
		public function addToRepeatableMethods(proxy : Object, method : MethodInfo, expectation : IExpectation) : void
		{
			this.removeExpectation(expectation);
			
			if (!this.repeatableMethods.contains(proxy, method))
			{
				this.repeatableMethods.addExpectations(proxy, method, []);
			}
			
			var expectations : Array = this.repeatableMethods.getExpectations(proxy, method);
			expectationNotOnList(expectations, expectation);
			expectations.push(expectation);
		}
		
		private function expectationNotOnList(expecations : Array, expectation : IExpectation) : void
		{
			if (expecations.indexOf(expectation) > -1)
			{
				throw new IllegalOperationError("The result for " + expectation.errorMessage + " has already been setup.");
			}
		}
		
		public function clearReplayerToCall(childReplayer : IMethodRecorder) : void
		{
			this.replayerToCall = null;
			this._replayersToIgnoreForThisCall.push(childReplayer);
		}
		
		public function getAllExpectationsForProxy(proxy : Object) : Array
		{
			var childExpectations : Array;
			
			var expectations : Array = doGetAllExpectationsForProxy(proxy);
			
			if (this.replayerToCall != null)
			{
				childExpectations = this.replayerToCall.getAllExpectationsForProxy(proxy);
			}
			
			if (childExpectations != null)
			{
				for each(var childExpectation : IExpectation in childExpectations)
				{
					if (expectations.indexOf(childExpectation) == -1)
					{
						expectations.push(childExpectation);
					}
				}
			}
			
			return expectations;
		}
		
		protected function doGetAllExpectationsForProxy(proxy : Object) : Array
		{
			throw new IllegalOperationError("Abstract");
		}
		
		public function getAllExpectationsForProxyAndMethod(proxy : Object, method : MethodInfo) : Array
		{
			throw new IllegalOperationError("Abstract");
		}
		
		public function getExpectedCallsMessage() : String
		{
			throw new IllegalOperationError("Abstract");
		}
		
		public function getRecordedExpectation(invocation : IInvocation, proxy : Object, method : MethodInfo, args : Array) : IExpectation
		{
			if (replayerToCall != null)
			{
				return replayerToCall.getRecordedExpectation(invocation, proxy, method, args);
			}
			
			if (this.recordedActions.length == 1 && this.recordedActions[0] is IMethodRecorder)
			{
				this.replayerToCall = this.recordedActions[0] as IMethodRecorder;
				return replayerToCall.getRecordedExpectation(invocation, proxy, method, args);
			}
			
			var expectation : IExpectation = this.doGetRecordedExpectation(invocation, proxy, method, args);
			
			if (!this.hasExpectations)
			{
				this.moveToParentReplayer();
			}
			
			return expectation;
		}
		
		protected function doGetRecordedExpectation(invocation : IInvocation, proxy : Object, method : MethodInfo, args : Array) : IExpectation
		{
			throw new IllegalOperationError("Abstract");
		}
		
		public function getRecordedExpectationOrNull(proxy : Object, method : MethodInfo, args : Array) : IExpectation
		{
			_recursionDepth++;
			
			try
			{
				if (this.replayerToCall != null)
				{
					return this.replayerToCall.getRecordedExpectationOrNull(proxy, method, args);
				}
				
				return this.doGetRecordedExpectationOrNull(proxy, method, args);
			}
			finally
			{
				_recursionDepth--;
				
				if (_recursionDepth == 0)
				{
					this._replayersToIgnoreForThisCall = new Array();
				}
			}
			
			return null; 
		}
		
		protected function doGetRecordedExpectationOrNull(proxy : Object, method : MethodInfo, args : Array) : IExpectation
		{
			throw new IllegalOperationError("Abstract");
		}

		public function getRepeatableExpectation(proxy : Object, method : MethodInfo, args : Array) : IExpectation
		{
			if (this.repeatableMethods.contains(proxy, method))
			{
				var expectations : Array = repeatableMethods.getExpectations(proxy, method);
				
				for each(var expectation : IExpectation in expectations)
				{
					if (expectation.isExpected(args))
					{
						expectation.addActualCall();
						
						if (expectation.repeatableOption == RepeatableOption.NEVER)
						{
							var errorMessage : String = expectation.errorMessage + 
								" Expected #" + expectation.expected.toString() + 
								", Actual #" + expectation.actualCallsCount.toString() + ".";
							
							var error : ExpectationViolationError = new ExpectationViolationError(errorMessage);
							MockRepository.asmock_internal::setVerifyError(proxy, error);
							throw error;
						}
						
						return expectation;
					}
				}
			}
			
			return null; // ActionScript needs this
		}
		
		public function moveToParentReplayer() : void
		{
			this.replayerToCall = null;
			
			if (this.parentRecorder != null && !this.hasExpectations)
			{
				this.parentRecorder.moveToParentReplayer();
			}
		}
		
		public function moveToPreviousRecorder() : Boolean
		{
			if (this.recorderToCall == null)
			{
				return true;
			}
			
			if (this.recorderToCall.moveToPreviousRecorder())
			{
				this.recorderToCall = null;
			}
			
			return false;
		}
		
		public final function record(proxy : Object, method : MethodInfo, expectation : IExpectation) : void
		{
			if (this.recorderToCall != null)
			{
				this.recorderToCall.record(proxy, method, expectation);
			}
			else
			{
				this.doRecord(proxy, method, expectation);
			}
		}
		
		protected function doRecord(proxy : Object, method : MethodInfo, expectation : IExpectation) : void
		{
			throw new IllegalOperationError("Abstract");
		}
		
		public function removeAllRepeatableExpectationsForProxy(proxy : Object) : void 
		{
			this.repeatableMethods.remove(proxy);
		}
		
		public final function removeExpectation(expectation : IExpectation) : void
		{
			if (this.recorderToCall != null)
			{
				this.recorderToCall.removeExpectation(expectation);
			}
			else
			{
				this.doRemoveExpectation(expectation);
			}
		}
		
		protected function doRemoveExpectation(expectation : IExpectation) : void
		{
			throw new IllegalOperationError("Abstract");
		}
		
		public final function replaceExpectation(proxy : Object, method : MethodInfo, oldExpectation : IExpectation, newExpectation : IExpectation) : void
		{
			if (!tryReplaceRepeatableExpectation(proxy, method, oldExpectation, newExpectation)) 
			{
				if (this.recorderToCall	!= null)
				{
					this.recorderToCall.replaceExpectation(proxy, method, oldExpectation, newExpectation);
				}
				else
				{
					this.doReplaceExpectation(proxy, method, oldExpectation, newExpectation);
				}
			}
		}
		
		private function tryReplaceRepeatableExpectation(proxy : Object, method : MethodInfo, oldExpectation : IExpectation, newExpectation : IExpectation) : Boolean
		{
			if (this.repeatableMethods.contains(proxy, method))
			{
				var expectations : Array = this.repeatableMethods.getExpectations(proxy, method);
				
				var index : int = expectations.indexOf(oldExpectation);
				
				if (index != -1)
				{
					expectations[index] = newExpectation;
					return true;
				}
			}
			
			return false;
		}
		
		protected function doReplaceExpectation(proxy : Object, method : MethodInfo, oldExpectation : IExpectation, newExpectation : IExpectation) : void
		{
			throw new IllegalOperationError("Abstract");
		}
		
		public function shouldConsiderThisReplayer(replayer : IMethodRecorder) : Boolean
		{
			return _replayersToIgnoreForThisCall.indexOf(replayer) == -1;
		}
		
		public function unexpectedMethodCall(invocation : IInvocation, proxy : Object, method : MethodInfo, args : Array) : ExpectationViolationError
		{
			throw new IllegalOperationError("Abstract");
		}
		
		protected function get doHasExpectations() : Boolean
		{
			throw new IllegalOperationError("Abstract");
		}
		
		public function get hasExpectations() : Boolean
		{
			return (this.replayerToCall != null)
				? this.replayerToCall.hasExpectations
				: this.doHasExpectations;
		}
	}
}