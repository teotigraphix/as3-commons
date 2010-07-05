package org.mockito.flemit.framework.bytecode
{
	[ExcludeClass]
	public class NamespaceSet implements IEqualityComparable
	{
		private var _namespaces : Array;
		
		public function NamespaceSet(namespaces : Array)
		{
			_namespaces = [].concat(namespaces);
		}
		
		public function get namespaces() : Array { return _namespaces; }
		
		public function equals(object : Object) : Boolean 
		{
			var namespaceSet : NamespaceSet = object as NamespaceSet;
			
			if (namespaceSet != null)
			{
				if (namespaceSet._namespaces.length == _namespaces.length)
				{
					for (var i:uint=0; i<_namespaces.length; i++)
					{
						if (!IEqualityComparable(namespaceSet._namespaces[i]).equals(_namespaces[i]))
							return false;
					}
					
					return true;
				}
			}
			
			return false;
		}
		
		public function toString() : String
		{
			return '[' + _namespaces.join(',') + ']';
		}
	}
}