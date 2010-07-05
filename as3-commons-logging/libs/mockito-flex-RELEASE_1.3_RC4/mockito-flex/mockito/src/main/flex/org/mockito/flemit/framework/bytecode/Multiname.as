package org.mockito.flemit.framework.bytecode
{
	import org.mockito.asmock.Enum;
	import org.mockito.asmock.util.ClassUtility;
	
	[ExcludeClass]
	public class Multiname implements IEqualityComparable
	{
		private var _kind : uint;
		
		public function Multiname(kind : uint)
		{
			ClassUtility.assertAbstract(this, Multiname);
			
			Enum.getName(MultinameKind, kind);
			_kind = kind;
		}
		
		public function get kind() : uint
		{
			return _kind;
		}
		
		public function equals(object : Object) : Boolean
		{
			return false;
		}
	}
}