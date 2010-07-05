package org.mockito.asmock.reflection
{
	[ExcludeClass]
	public class PropertyInfo extends MemberInfo
	{
		private var _type : Type;
		private var _canRead : Boolean;
		private var _canWrite : Boolean;
		
		private var _getMethod : MethodInfo;
		private var _setMethod : MethodInfo;
		
		public function PropertyInfo(owner : Type, name : String, fullName : String, visibility : uint, isStatic : Boolean, isOverride : Boolean, type : Type, canRead : Boolean, canWrite : Boolean, ns : String = null)
		{
			super(owner, name, fullName, visibility, isStatic, isOverride, ns);
			
			_type = type;
			_canRead = canRead;
			_canWrite = canWrite;
			
			// TODO: readonly? writeonly?
			_getMethod = new MethodInfo(owner, "get", this.fullName + "/get", visibility, isStatic, isOverride, type, []);
			_setMethod = new MethodInfo(owner, "set", this.fullName + "/set", visibility, isStatic, isOverride, Type.voidType, [new ParameterInfo("value", type, false)]);
		}
		
		public function get type() : Type
		{
			return _type;
		}
				
		public function get canRead() : Boolean
		{
			return _canRead;
		}
		
		public function get canWrite() : Boolean
		{
			return _canWrite;
		}
		
		public function get getMethod() : MethodInfo
		{
			return _getMethod;
		}
		
		public function get setMethod() : MethodInfo
		{
			return _setMethod;
		}

	}
}