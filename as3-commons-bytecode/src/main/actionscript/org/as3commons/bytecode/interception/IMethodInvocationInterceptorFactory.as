package org.as3commons.bytecode.interception {
	import org.as3commons.bytecode.interception.IMethodInvocationInterceptor;

	public interface IMethodInvocationInterceptorFactory {
		function newInstance():IMethodInvocationInterceptor;
	}
}