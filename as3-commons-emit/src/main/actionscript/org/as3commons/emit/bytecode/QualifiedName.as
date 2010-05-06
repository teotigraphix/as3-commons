package org.as3commons.emit.bytecode
{
	
	public class QualifiedName extends AbstractMultiname
	{
		private var _name : String;
		private var _ns : BCNamespace;
		
		public function QualifiedName(ns : BCNamespace, name : String, kind : uint = 0x07)
		{
			super(kind);
			
			_ns = ns;
			_name = name;
		}
		
		public function get ns() : BCNamespace { return _ns; }
		public function get name() : String { return _name; }
		
		public override function equals(object:Object):Boolean
		{
			var qname : QualifiedName = object as QualifiedName;
			
			if (qname != null)
			{
				return qname.ns.equals(this._ns) &&
						qname.name == this._name; 
			}
			
			return false;
		}
		
		public function toString():String
		{
			var nsString : String = ns.toString();
			var sepChar : String = (nsString.indexOf(':') == -1)
				? ':'
				: '/';
				
			return nsString.concat(sepChar, name);
		}
	}
}