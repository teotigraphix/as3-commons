package org.mockito.asmock.framework.expectations
{
	import org.mockito.asmock.framework.Validate;
	import org.mockito.asmock.framework.proxy.IInvocation;
	import org.mockito.asmock.framework.util.MethodUtil;
	import org.mockito.asmock.framework.asmock_internal;
	
	[ExcludeClass]
	public class ArgsEqualExpectation extends AbstractExpectation
	{
		private var _invocation : IInvocation;
		private var _args : Array;
		
		public function ArgsEqualExpectation(invocation : IInvocation, args : Array)
		{
			super(invocation);
			
			_args = args;
		}
		
		protected override function doIsExpected(args : Array) : Boolean
		{
			return org.mockito.asmock.framework.Validate.argsEqual(_args, args);
		}
		
		public override function get errorMessage():String
		{
			var derivedMessage : String = MethodUtil.formatMethod(method, _args);
			
			return super.createErrorMessage(derivedMessage);
		}
	}
}