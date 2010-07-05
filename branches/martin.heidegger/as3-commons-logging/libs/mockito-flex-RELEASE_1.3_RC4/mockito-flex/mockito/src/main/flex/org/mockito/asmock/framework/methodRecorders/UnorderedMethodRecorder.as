package org.mockito.asmock.framework.methodRecorders
{
	import org.mockito.asmock.framework.ExpectationViolationError;
	import org.mockito.asmock.framework.MockRepository;
	import org.mockito.asmock.framework.expectations.IExpectation;
	import org.mockito.asmock.framework.impl.IMethodRecorder;
	import org.mockito.asmock.framework.proxy.IInvocation;
	import org.mockito.asmock.framework.util.MethodUtil;
	import org.mockito.asmock.reflection.MethodInfo;
	import org.mockito.asmock.util.StringBuilder;
	
	import org.mockito.asmock.framework.asmock_internal;

	[ExcludeClass]
	public class UnorderedMethodRecorder extends MethodRecorderBase
	{
		protected var parentRecorderRedirection : IMethodRecorder;
		
		public function UnorderedMethodRecorder(repeatableMethods : ProxyMethodExpectationsDictionary, parentRecorder : IMethodRecorder = null)
		{
			super(repeatableMethods, parentRecorder);
		}
		
		protected override function doAddRecorder(recorder:IMethodRecorder):void
		{
			super.recordedActions.push(recorder);
		}
		
		protected override function doGetAllExpectationsForProxy(proxy:Object):Array
		{
			var triplet : ProxyMethodExpectationTriplet = null;
			
			var expectations : Array = new Array();
			
			for each(var recordedObject : Object in super.recordedActions)
			{
				triplet = recordedObject as ProxyMethodExpectationTriplet;
				
				if (triplet != null)
				{
					if (triplet.proxy == proxy)
					{
						expectations.push(triplet.expectation);
					}
				}
				else
				{
					var subRecorderExpectations : Array = 
						IMethodRecorder(recordedObject).getAllExpectationsForProxy(proxy);
						
					expectations.push.apply(expectations, subRecorderExpectations);
				}
			}
			
			return expectations;
		}
		
		protected override function doGetRecordedExpectation(invocation:IInvocation, proxy:Object, method:MethodInfo, args:Array):IExpectation
		{
			var expectation : IExpectation = super.getRecordedExpectationOrNull(proxy, method, args);
			
			if (expectation == null)
			{
				var error : ExpectationViolationError = unexpectedMethodCall(invocation, proxy, method, args);
				MockRepository.asmock_internal::setVerifyError(proxy, error);
				throw error;
			}
			
			return expectation;
		}
		
		protected override function doGetRecordedExpectationOrNull(proxy:Object, method:MethodInfo, args:Array):IExpectation
		{
			var expectedObjects : Array = new Array().concat(super.recordedActions);
			
			var allSatisfied : Boolean = true;
			
			for each(var expectedObject : Object in expectedObjects)
			{
				var triplet : ProxyMethodExpectationTriplet = expectedObject as ProxyMethodExpectationTriplet;
				
				if (triplet != null)
				{
					if (triplet.proxy == proxy && triplet.method == method && 
						triplet.expectation.canAcceptCalls && triplet.expectation.isExpected(args))
					{
						triplet.expectation.addActualCall();
						
						return triplet.expectation;
					}
					
					if (!triplet.expectation.expectationSatisfied)
					{
						allSatisfied = false;
					}
				}
				else
				{
					var replayer : IMethodRecorder = IMethodRecorder(expectedObject);
					
					if (!shouldConsiderThisReplayer(replayer))
					{
						continue;
					}
					
					var subExpectation : IExpectation = replayer.getRecordedExpectationOrNull(proxy, method, args);
					
					if (subExpectation != null)
					{
						super.replayerToCall = replayer;
						return subExpectation;
					}
					
					if (replayer.hasExpectations)
					{
						allSatisfied = false;
					}
				}
			}
			
			// if (!(allSatisfied && (parentRecorder != null))
			if (!allSatisfied || parentRecorder == null)
			{
				return null;
			}
			
			super.parentRecorder.clearReplayerToCall(this);
			
			this.parentRecorderRedirection = super.parentRecorder;
			
			return super.parentRecorder.getRecordedExpectationOrNull(proxy, method, args);
		}
		
		protected override function doRecord(proxy:Object, method:MethodInfo, expectation:IExpectation):void
		{
			var triplet : ProxyMethodExpectationTriplet = new ProxyMethodExpectationTriplet(proxy, method, expectation);
			
			super.recordedActions.push(triplet);
		}
		
		protected override function doRemoveExpectation(expectation:IExpectation):void
		{
			for (var i:int =0; i<recordedActions.length; i++)
			{
				var triplet : ProxyMethodExpectationTriplet = recordedActions[i] as ProxyMethodExpectationTriplet;
				
				if (triplet != null && triplet.expectation == expectation)
				{
					recordedActions.splice(i, 1);
					i--; // TODO: This bugfix is not in Rhino Mocks - tell Ayende
				}
			}
		}
		
		protected override function doReplaceExpectation(proxy:Object, method:MethodInfo, oldExpectation:IExpectation, newExpectation:IExpectation):void
		{
			for each(var recordedObject : Object in recordedActions)
			{
				var triplet : ProxyMethodExpectationTriplet = recordedObject as ProxyMethodExpectationTriplet;
				
				if (triplet != null && triplet.expectation == oldExpectation &&
					triplet.proxy == proxy && triplet.method == method)
				{
					triplet.expectation = newExpectation;
				}
			}
		}
		
		public override function getAllExpectationsForProxyAndMethod(proxy:Object, method:MethodInfo):Array
		{
			var expectations : Array = new Array();
			
			for each(var expectedObject : Object in recordedActions)
			{
				var triplet : ProxyMethodExpectationTriplet = expectedObject as ProxyMethodExpectationTriplet;
				
				if (triplet != null)
				{
					if (triplet.proxy == proxy && triplet.method == method)
					{
						expectations.push(triplet.expectation);
					}
				}
				else
				{
					var recorder : IMethodRecorder = IMethodRecorder(expectedObject);
					
					expectations.push.apply(expectations, recorder.getAllExpectationsForProxyAndMethod(proxy, method));
				}
			}
			
			return expectations;
		}
		
		public override function getExpectedCallsMessage():String
		{
			var sb : StringBuilder = new StringBuilder();
			
			sb.append("Unordered: { ");
			
			for each(var expectedObject : Object in recordedActions)
			{
				var triplet : ProxyMethodExpectationTriplet = expectedObject as ProxyMethodExpectationTriplet;
				
				if (triplet != null)
				{
					sb.append(triplet.expectation.errorMessage);
				}
				else
				{
					var recorder : IMethodRecorder = IMethodRecorder(expectedObject);
					
					sb.append(recorder.getExpectedCallsMessage());
				}
			} 
			
			sb.append(" }");
			
			return sb.toString();
		}
		
		public override function unexpectedMethodCall(invocation : IInvocation, proxy : Object, method : MethodInfo, args : Array) : ExpectationViolationError
		{
			if (parentRecorderRedirection != null)
			{
				return this.parentRecorderRedirection.unexpectedMethodCall(invocation, proxy, method, args); 
			}
			
			var sb : StringBuilder = new StringBuilder();
			
			var actual : CalcExpectedAndActual = new CalcExpectedAndActual(this, proxy, method, args);
			
			sb.append(MethodUtil.formatMethod(method, args));
			
			sb.append(" Expected #");
			
			if (actual.expectedMin == actual.expectedMax)
			{
				sb.append(actual.expectedMin.toString());
			}
			else
			{
				sb.appendFormat("{0} - {1}", actual.expectedMin, actual.expectedMax);
			}
			
			sb.appendFormat(", Actual #{0}.", actual.actual);
			
			var expectations : Array = getAllExpectationsForProxyAndMethod(proxy, method);
			
			if (expectations.length > 0)
			{
				var message : String = expectations[0].message;
				
				if (message != null)
				{
					sb.appendLine();
					sb.appendFormat("Message: {0}", message);
					sb.appendLine();
				}
				
				appendNextExpected(expectations[0], sb);
			}
			
			return new ExpectationViolationError(sb.toString());
		}
		
		private function appendNextExpected(expectation : IExpectation, sb : StringBuilder) : void
		{
			if (!expectation.expectationSatisfied)
			{
				sb.append("\n");
				sb.append(expectation.errorMessage).append(" Expected #");
				sb.append(expectation.expected.toString()).append(", Actual #");
				sb.append(expectation.actualCallsCount.toString()).append(".");
			}
		}
		
		protected override function get doHasExpectations():Boolean
		{
			var triplet : ProxyMethodExpectationTriplet;
			
			for each(var recordedObject : Object in super.recordedActions)
			{
				triplet = recordedObject as ProxyMethodExpectationTriplet;
				
				if (triplet != null)
				{
					if (triplet.expectation.canAcceptCalls)
					{
						return true;
					}
				}
				else
				{
					var recorder : IMethodRecorder = IMethodRecorder(recordedObject);
						
					if (recorder.hasExpectations)
					{
						return true;
					}
				}
			}
			
			return false;
		}
	}
}
	import org.mockito.asmock.framework.methodRecorders.UnorderedMethodRecorder;
	import org.mockito.asmock.framework.expectations.IExpectation;
	import org.mockito.asmock.reflection.MethodInfo;
	

class CalcExpectedAndActual
{
	private var _actual : uint;
	private var _expectedMin : uint;
	private var _expectedMax : uint;
	private var _parent : UnorderedMethodRecorder;
	
	public function CalcExpectedAndActual(parent : UnorderedMethodRecorder, proxy : Object, method : MethodInfo, args : Array)
	{
		this._actual = 1;
		this._expectedMin = 0;
		this._parent = parent;
		this.calculate(proxy, method, args);
	}
	
	private function calculate(proxy : Object, method : MethodInfo, args : Array) : void
	{
		var expectations : Array = _parent.getAllExpectationsForProxyAndMethod(proxy, method);
		
		for each(var expectation : IExpectation in expectations)
		{
			if (expectation.isExpected(args))
			{
				_expectedMin += expectation.expected.min;
				_expectedMax += expectation.expected.max;
				_actual += expectation.actualCallsCount;
			}
		}
	}
	
	public function get actual() : uint { return _actual; }
	public function get expectedMin() : uint { return _expectedMin; }
	public function get expectedMax() : uint { return _expectedMax; }
}