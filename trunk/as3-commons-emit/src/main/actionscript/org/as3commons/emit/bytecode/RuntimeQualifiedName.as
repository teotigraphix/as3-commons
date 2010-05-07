package org.as3commons.emit.bytecode
{
	
	public class RuntimeQualifiedName extends AbstractMultiname
	{
		private var _name : String;
		
		public function RuntimeQualifiedName(name : String, kind : uint = 0x0F)
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