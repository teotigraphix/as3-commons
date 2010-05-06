package org.as3commons.emit.bytecode
{
import org.as3commons.lang.IEquals;

	public class BCNamespace implements IEquals
	{
		private var _name : String;
		private var _kind : uint;
		
		public function BCNamespace(name : String, kind : uint)
		{
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