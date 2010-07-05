package org.mockito.flemit.framework.bytecode
{
	import org.mockito.asmock.Enum;
	
	[ExcludeClass]
	public class BCNamespace implements IEqualityComparable
	{
		private var _name : String;
		private var _kind : uint;
		
		public function BCNamespace(name : String, kind : uint)
		{
			Enum.getName(NamespaceKind, kind);
			
			_name = name;
			_kind = kind;	
		}
		
		public function get name() : String { return _name; }
		public function get kind() : uint { return _kind; }

		public function equals(object:Object):Boolean
		{
			var ns : BCNamespace = object as BCNamespace;
			
			if (ns != null)
			{
				return ns.name == _name &&
						ns.kind == _kind;
			}
			
			return false;
		}
		
		public function toString() : String
		{
			return _name;
		}
		
		public static function packageNS(name : String) : BCNamespace
		{
			return new BCNamespace(name, NamespaceKind.PACKAGE_NAMESPACE);
		}
	}
}