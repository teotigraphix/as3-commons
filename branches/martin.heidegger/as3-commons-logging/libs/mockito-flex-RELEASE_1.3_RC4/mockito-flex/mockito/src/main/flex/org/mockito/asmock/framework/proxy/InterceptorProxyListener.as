package org.mockito.asmock.framework.proxy
{
	import org.mockito.asmock.reflection.*;
	
	[ExcludeClass]
	public class InterceptorProxyListener implements IProxyListener
	{
		private var _constructed : Boolean = false;
		
		private var _interceptor : IInterceptor;
		
		public function InterceptorProxyListener(interceptor : IInterceptor)
		{
			_interceptor = interceptor;
		}
		
		public function methodExecuted(target : Object, methodType : uint, methodName : String, arguments : Array, baseMethod : Function) : *
		{
			if (methodType == MethodType.CONSTRUCTOR)
			{
				_constructed = true;
				return;
			}
			
			if (!_constructed)
			{
				if (baseMethod != null)
				{
					baseMethod.apply(NaN, arguments);
				}
				
				return;
			}
			
			var targetType : Type = Type.getType(target);
			
			var method : MethodInfo;
			var property : PropertyInfo;
			
			switch(methodType)
			{
				case MethodType.METHOD:
					method = targetType.getMethod(methodName);
					break;				
				case MethodType.PROPERTY_GET:
					property = targetType.getProperty(methodName);
					method = property.getMethod;
					break;
				case MethodType.PROPERTY_SET:
					property = targetType.getProperty(methodName);
					method = property.setMethod;
					break;
			}
			
			var invocation : IInvocation = new SimpleInvocation(target, property, method, arguments, baseMethod);
			
			_interceptor.intercept(invocation);
			
			return invocation.returnValue;
		}
	}
}