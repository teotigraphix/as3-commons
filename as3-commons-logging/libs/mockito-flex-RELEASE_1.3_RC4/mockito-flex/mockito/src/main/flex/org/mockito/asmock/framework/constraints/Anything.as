package org.mockito.asmock.framework.constraints
{
	public class Anything extends AbstractConstraint
	{
		public function Anything()
		{
		}
		
		public override function eval(obj:Object):Boolean
		{
			return true;
		}
		
		public override function get message():String
		{
			return "anything";
		}

	}
}