package org.as3commons.emit.bytecode
{
	
	public class MultipleNamespaceName extends AbstractMultiname
	{
		private var _name : String;
		private var _namespaceSet : NamespaceSet;
		
		public function MultipleNamespaceName(name : String, namespaceSet : NamespaceSet, kind : uint = 0x09)
		{
			super(kind);
			
			_name = name;
			_namespaceSet = namespaceSet;
		}
		
		public function get name() : String { return _name; }
		public function get namespaceSet() : NamespaceSet { return _namespaceSet; }
		
		public override function equals(object:Object):Boolean
		{
			var mnsn : MultipleNamespaceName = object as MultipleNamespaceName;
			
			if (mnsn != null)
			{
				return mnsn.name == this.name &&
					mnsn.namespaceSet.equals(this.namespaceSet);
			}
			
			return false;
		}
		
		public function toString():String
		{
			var nsString : String = namespaceSet.toString();
			var sepChar : String = (nsString.indexOf(':') == -1)
				? ':'
				: '/';
				
			return nsString.concat(sepChar, name);
		}
	}
}