package org.as3commons.emit.bytecode
{
	
	public class MultipleNamespaceNameLate extends AbstractMultiname
	{
		private var _namespaceSet : NamespaceSet;
		
		public function MultipleNamespaceNameLate(namespaceSet : NamespaceSet, kind : uint = 0x1B)
		{
			super(kind);
			
			_namespaceSet = namespaceSet;
		}
		
		public function get namespaceSet() : NamespaceSet { return _namespaceSet; }

	}
}