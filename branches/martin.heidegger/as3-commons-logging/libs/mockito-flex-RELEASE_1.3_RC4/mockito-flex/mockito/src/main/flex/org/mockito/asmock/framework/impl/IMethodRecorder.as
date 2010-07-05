package org.mockito.asmock.framework.impl
{
	import org.mockito.asmock.framework.ExpectationViolationError;
	import org.mockito.asmock.framework.expectations.IExpectation;
	import org.mockito.asmock.framework.proxy.IInvocation;
	import org.mockito.asmock.reflection.MethodInfo;
	
	[ExcludeClass]
	public interface IMethodRecorder
	{
		function addRecorder(recorder : IMethodRecorder) : void;
		function moveToParentReplayer() : void;
		function moveToPreviousRecorder() : Boolean;
		function clearReplayerToCall(childReplayer : IMethodRecorder) : void;
		
		function record(proxy : Object, method : MethodInfo, expectation : IExpectation) : void;
		function getRecordedExpectation(invocation : IInvocation, proxy : Object, method : MethodInfo, args : Array) : IExpectation;
		function getRecordedExpectationOrNull(proxy : Object, method : MethodInfo, args : Array) : IExpectation;
		function unexpectedMethodCall(invocation : IInvocation, proxy : Object, method : MethodInfo, args : Array) : ExpectationViolationError;
		function getAllExpectationsForProxy(proxy : Object) : Array;
		function getAllExpectationsForProxyAndMethod(proxy : Object, method : MethodInfo) : Array;
		function replaceExpectation(proxy : Object, method : MethodInfo, oldExpectation : IExpectation, newExpectation : IExpectation) : void;
		function removeExpectation(expectation : IExpectation) : void;
		function get hasExpectations() : Boolean;
		
		function addToRepeatableMethods(proxy : Object, method : MethodInfo, expectation : IExpectation) : void;
		function getRepeatableExpectation(proxy : Object, method : MethodInfo, args : Array) : IExpectation;
		
		function removeAllRepeatableExpectationsForProxy(proxy : Object) : void;
		
		function getExpectedCallsMessage():String
	}
}