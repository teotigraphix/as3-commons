package org.mockito.asmock.framework.proxy
{
	import org.mockito.asmock.reflection.*;
	
	import flash.errors.IllegalOperationError;
	
	[ExcludeClass]
	public class SimpleInvocation implements IInvocation
	{
		private var _args : Array;
		
		private var _invocationTarget : Object;
		private var _methodInvocationTarget : MethodInfo;
		
		private var _proxy : Object;
		private var _method : MethodInfo;
		private var _property : PropertyInfo;
		
		private var _returnValue : Object;
		
		private var _baseMethod : Function;
		private var _hasProceeded : Boolean = false;
		
		public function SimpleInvocation(proxy : Object, property : PropertyInfo, method : MethodInfo, args : Array, baseMethod : Function)
		{
			_args = args;
			
			_proxy = proxy;
			_property = property;
			_method = method;
			
			_baseMethod = baseMethod;
			
			_invocationTarget = proxy;
			_method = method;
		}
		
		public function get arguments() : Array
		{
			return _args;
		}
		
		public function get targetType() : Type
		{
			return _method.owner;
		}
		
		public function get proxy() : Object
		{
			return _proxy;
		}
		
		public function get invocationTarget() : Object
		{
			return _invocationTarget;
		}
		
		public function get property() : PropertyInfo
		{
			return _property;
		}
		
		public function get method() : MethodInfo
		{
			return _method;
		}
		
		public function get methodInvocationTarget() : MethodInfo
		{
			return _methodInvocationTarget;
		}
		
		public function get returnValue() : Object
		{
			return _returnValue;
		}
		
		public function set returnValue(value : Object) : void
		{
			if (value != null)
			{			
				if (!_method.returnType.isAssignableFromInstance(value))
				{
					throw new ArgumentError("returnValue must be assignable from " + _method.returnType.fullName);
				}
			}
			
			_returnValue = value;
		}
		
		public function get canProceed() : Boolean
		{
			return (!(_hasProceeded || _baseMethod == null));
		}
		
		public function proceed() : void
		{
			if (_hasProceeded)
			{
				throw new IllegalOperationError("Invocation has already proceeded");
			}
			
			if (_baseMethod == null)
			{
				throw new IllegalOperationError("Cannot proceed on method because it is an interface method: " + _method.fullName);
			}
			
			returnValue = _baseMethod.apply(NaN, _args);
			_hasProceeded = true; 
		}
	}
}