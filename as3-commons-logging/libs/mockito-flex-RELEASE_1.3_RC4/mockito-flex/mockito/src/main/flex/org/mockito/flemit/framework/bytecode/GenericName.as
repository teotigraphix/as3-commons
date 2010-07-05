package org.mockito.flemit.framework.bytecode
{
	[ExcludeClass]
	public class GenericName extends Multiname
	{
		private var _typeDefinition : Multiname;
		private var _genericParameters : Array;
		
		public function GenericName(typeDefinition : Multiname, genericParameters : Array, kind : uint = MultinameKind.GENERIC)
		{
			super(kind);
			
			_typeDefinition = typeDefinition;
			_genericParameters = new Array().concat(genericParameters);
		}
		
		public function get typeDefinition() : Multiname { return _typeDefinition; }
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