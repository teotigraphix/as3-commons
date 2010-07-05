package org.mockito.flemit.framework.bytecode
{
	[ExcludeClass]
	public class RuntimeQualifiedName extends Multiname
	{
		private var _name : String;
		
		public function RuntimeQualifiedName(name : String, kind : uint = MultinameKind.RUNTIME_QUALIFIED_NAME)
		{
			super(kind);
			
			_name = name;
		}
		
		public function get name() : String { return _name; }
		
		public override function equals(object:Object):Boolean
		{
			var rtqn : RuntimeQualifiedName = object as RuntimeQualifiedName;
			
			if (rtqn != null)
			{
				return rtqn.name == this._name;
			}
			
			return false;
		}
	}
}