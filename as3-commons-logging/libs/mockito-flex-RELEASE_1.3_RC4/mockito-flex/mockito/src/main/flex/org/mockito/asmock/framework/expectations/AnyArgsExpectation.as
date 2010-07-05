package org.mockito.asmock.framework.expectations
{
	import org.mockito.asmock.framework.util.MethodUtil;
	
	[ExcludeClass]
	public class AnyArgsExpectation extends AbstractExpectation
	{
		public function AnyArgsExpectation(expectation:IExpectation=null)
		{
			super(null, expectation);
		}
		
		protected override function doIsExpected(args : Array) : Boolean
		{
			return true;
		}
		
		public override function get errorMessage():String
		{
			var derivedMessage : String = MethodUtil.formatMethod(originalInvocation.method, []);
			
			return super.createErrorMessage(derivedMessage);
		}
	}
}