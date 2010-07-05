package org.mockito.asmock.reflection
{
	[ExcludeClass]
	public class FieldInfo extends MemberInfo
	{
		private var _type : Type;
		
		public function FieldInfo(owner : Type, name : String, fullName : String, visibility : uint, isStatic : Boolean, type : Type)
		{
			super(owner, name, fullName, visibility, isStatic, false, null);
			
			_type = type;
		}
		
		public function get type() : Type
		{
			return _type;
		}
	}
}