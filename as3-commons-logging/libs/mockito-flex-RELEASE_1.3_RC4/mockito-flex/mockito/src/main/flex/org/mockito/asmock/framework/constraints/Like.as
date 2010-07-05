package org.mockito.asmock.framework.constraints
{
	public class Like extends AbstractConstraint
	{
		private var _expr : RegExp;
		
		public function Like(expr : RegExp)
		{
			if (expr == null)
			{
				throw new ArgumentError("expr cannot be null");
			}
			
			_expr = expr;
		}
		
		public override function eval(obj:Object):Boolean
		{
			return (obj != null) && _expr.test(obj.toString());
		}
		
		public override function get message():String
		{
			return "like \"".concat(_expr.source, "\"");
		}

	}
}