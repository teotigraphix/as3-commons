package org.mockito.asmock.framework.expectations
{
	import org.mockito.asmock.framework.Range;
	import org.mockito.asmock.framework.proxy.IInvocation;
	import org.mockito.asmock.reflection.MethodInfo;
	
	import flash.events.Event;
	
	[ExcludeClass]
	public interface IExpectation
	{
		function get expected() : Range;
		function set expected(value : Range) : void;
		
		function get actualCallsCount() : uint;
		
		function get repeatableOption() : uint;
		function set repeatableOption(value : uint) : void;
		
		function get errorToThrow() : Error;
		function set errorToThrow(value : Error) : void;
		
		function get message() : String;
		function set message(value : String) : void;
		
		function get errorMessage() : String;
		
		function get actionToExecute() : Function;
		function set actionToExecute(value : Function) : void;
		
		function get expectationSatisfied() : Boolean;
		function get canAcceptCalls() : Boolean;
		
		function get returnValue() : Object;
		function set returnValue(value : Object) : void;
		
		function get eventToDispatch() : Event;
		function set eventToDispatch(value : Event) : void;
		
		function get hasReturnValue() : Boolean;
		
		function get method() : MethodInfo;
		
		function get originalInvocation() : IInvocation;
		
		function isExpected(args : Array) : Boolean;
		
		function addActualCall() : void;
		
		function get actionsSatisfied() : Boolean
		
		function returnOrThrow(invocation : IInvocation, args : Array) : Object;
		
		function buildVerificationFailureMessage() : String;
	}
}