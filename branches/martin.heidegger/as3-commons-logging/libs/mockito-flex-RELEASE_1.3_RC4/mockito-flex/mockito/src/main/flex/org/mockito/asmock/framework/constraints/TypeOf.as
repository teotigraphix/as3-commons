package org.mockito.asmock.framework.constraints
{
	import flash.utils.*;
	
	public class TypeOf extends AbstractConstraint
	{
		private var _class : Class;
		 
		public function TypeOf(cls : Class)
		{
			if (cls == null)
			{
				throw new ArgumentError("cls cannot be null");
			}
			
			_class = cls;
		}
		
		public override function eval(obj:Object):Boolean 
		{
			return obj is _class;
		}
		
		public override function get message():String
		{
			var className : String = getQualifiedClassName(_class);
			
			return "type of {".concat(className, "}");
		}

	}
}