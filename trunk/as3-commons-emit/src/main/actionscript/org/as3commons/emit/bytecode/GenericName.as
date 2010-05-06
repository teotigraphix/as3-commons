package org.as3commons.emit.bytecode
{
	
	public class GenericName extends AbstractMultiname
	{
		private var _typeDefinition : AbstractMultiname;
		private var _genericParameters : Array;
		
		public function GenericName(typeDefinition : AbstractMultiname, genericParameters : Array, kind : uint = 0x1D)
		{
			super(kind);
			
			_typeDefinition = typeDefinition;
			_genericParameters = new Array().concat(genericParameters);
		}
		
		public function get typeDefinition() : AbstractMultiname { return _typeDefinition; }
		public function get genericParameters() : Array { return _genericParameters; }
		
		public override function equals(object:Object):Boolean
		{
			var gn : GenericName = object as GenericName;
			
			if (gn != null)
			{
				if (!gn._typeDefinition.equals(_typeDefinition) ||
					gn._genericParameters.length != _genericParameters.length)
				{
					return false;
				}
				
				for (var i:int=0; i<_genericParameters.length; i++)
				{
					if (!gn._genericParameters[i].equals(_genericParameters[i]))
					{
						return false;
					}
				}
				
				return true;
			}
			
			return false;
		}
	}
}