package org.mockito.asmock.framework.methodRecorders
{
	import org.mockito.asmock.framework.ExpectationViolationError;
	import org.mockito.asmock.framework.expectations.IExpectation;
	import org.mockito.asmock.framework.impl.IMethodRecorder;
	import org.mockito.asmock.framework.proxy.IInvocation;
	import org.mockito.asmock.reflection.MethodInfo;
	import org.mockito.asmock.util.*;
	import org.mockito.asmock.framework.util.*;

	[ExcludeClass]
	public class OrderedMethodRecorder extends UnorderedMethodRecorder
	{
		public function OrderedMethodRecorder(repeatableMethods:ProxyMethodExpectationsDictionary, parentRecorder:IMethodRecorder=null)
		{
			super(repeatableMethods, parentRecorder);
		}
		
		protected override function doGetRecordedExpectationOrNull(proxy:Object, method:MethodInfo, args:Array):IExpectation
		{
			for (var i : int = 0; i<recordedActions.length; )
			{
				var triplet : ProxyMethodExpectationTriplet = recordedActions[i] as ProxyMethodExpectationTriplet;
				
				if (triplet != null)
				{
					if (triplet.proxy == proxy && triplet.method == method &&
						triplet.expectation.canAcceptCalls && triplet.expectation.isExpected(args))
					{
						while(i > 0)
						{
							recordedActions.splice(0, 1);
							i--;
						}
						
						triplet.expectation.addActualCall();
						
						if (!triplet.expectation.canAcceptCalls)
						{
							recordedActions.splice(0, 1);
						}
						
						return triplet.expectation;
					}
					
					if (!triplet.expectation.expectationSatisfied)
					{
						return null;
					}
					
					i++;
				}
				else
				{
					var replayer : IMethodRecorder = IMethodRecorder(recordedActions[i]);
					
					if (!replayer.hasExpectations)
					{
						i++;
						continue;
					}
					
					if (!shouldConsiderThisReplayer(replayer))
					{
						break;
					}
					
					var subExpectation : IExpectation = replayer.getRecordedExpectationOrNull(proxy, method, args);
					
					if (subExpectation == null)
					{
						break;
					}
					
					while(i > 0)
					{
						recordedActions.splice(0, 1);
						i--;
					}
					
					super.replayerToCall = replayer;
					super.recordedActions.splice(0, 1);
					
					return subExpectation;
				}
				
				if (super.parentRecorder == null)
				{
					return null;
				}
				
				super.parentRecorder.clearReplayerToCall(this);
				super.parentRecorderRedirection = super.parentRecorder;
				
				return super.getRecordedExpectationOrNull(proxy, method, args);
			}
			
			return null;
		}
		
		public override function getExpectedCallsMessage():String
		{
			var sb : StringBuilder = new StringBuilder();
			
			sb.append("Ordered: { ");
			
			if (recordedActions.length > 0)
			{
				var triplet : ProxyMethodExpectationTriplet = recordedActions[0] as ProxyMethodExpectationTriplet;
				
				if (triplet != null)
				{
					sb.append(triplet.expectation.errorMessage);
				}
				else
				{
					sb.append(IMethodRecorder(recordedActions[0]).getExpectedCallsMessage());
				}
			}
			else
			{
				sb.append("No method call is expected");
			}
			
			sb.append(" }");
			
			return sb.toString();
		}
		
		public override function unexpectedMethodCall(invocation:IInvocation, proxy:Object, method:MethodInfo, args:Array):ExpectationViolationError
		{
			if (super.parentRecorderRedirection != null)
			{
				return super.parentRecorderRedirection.unexpectedMethodCall(invocation, proxy, method, args);
			}
			
			var sb : StringBuilder = new StringBuilder();
			sb.append("Unordered method call! The expected call is: '");
			sb.append(getExpectedCallsMessage());
			sb.append("' but was: '");
			sb.append(MethodUtil.formatMethod(method, args));
			sb.append("'");
			
			return new ExpectationViolationError(sb.toString());
		}
	}
}