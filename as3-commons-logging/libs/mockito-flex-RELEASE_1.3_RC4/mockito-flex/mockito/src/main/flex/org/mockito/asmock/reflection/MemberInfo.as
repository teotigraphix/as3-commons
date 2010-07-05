package org.mockito.asmock.reflection
{
	import org.mockito.flemit.framework.bytecode.BCNamespace;
	import org.mockito.flemit.framework.bytecode.Multiname;
	import org.mockito.flemit.framework.bytecode.NamespaceKind;
	import org.mockito.flemit.framework.bytecode.QualifiedName;
	
	[ExcludeClass]
	public class MemberInfo
	{
		private var _owner : Type;
		private var _name : String;
		private var _fullName : String;
		private var _visibility : uint;
		private var _qname : QualifiedName;
		private var _isStatic : Boolean;
		private var _isOverride : Boolean;
		
		public function MemberInfo(owner : Type, name : String, fullName : String, visibility : uint, isStatic : Boolean, isOverride : Boolean, ns : String)
		{
			_name = name;
			_visibility= visibility;
			_owner = owner;
			_isStatic = isStatic;
			_isOverride = isOverride;
			
			ns = ns || "";
			
			_qname = (_visibility == MemberVisibility.PUBLIC)
				? new QualifiedName(new BCNamespace(ns, NamespaceKind.PACKAGE_NAMESPACE), name)
				: new QualifiedName(new BCNamespace(owner.packageName + ':' + owner.name, _visibility), name);
			
			_fullName = (fullName != null)
				? fullName
				: (owner.isInterface)
					? owner.fullName.concat('/', owner.fullName, ':', name)
					: owner.fullName.concat('/', name);
			
		}
		
		public function get name() : String
		{
			return _name;
		}
		
		public function get fullName() : String
		{
			return _fullName;
		}
		
		public function get visibility() : uint
		{
			return _visibility;
		}
		
		public function get isStatic() : Boolean
		{
			return _isStatic;
		}
		
		public function get isOverride() : Boolean
		{
			return _isOverride;
		}
		
		public function get qname() : QualifiedName
		{
			return _qname;
		}
		
		public function get owner() : Type
		{
			return _owner;
		}
	}
}