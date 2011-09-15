package org.as3commons.aop.intercept {
	import org.as3commons.aop.intercept.invocation.IConstructorInvocation;

	public class StringToUpperCaseConstructorInterceptor implements IConstructorInterceptor {

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function StringToUpperCaseConstructorInterceptor() {
		}

		public function interceptConstructor(constructorInvocation:IConstructorInvocation):* {
			if (constructorInvocation.args && constructorInvocation.args.length > 0) {
				if (constructorInvocation.args[0] is String) {
					constructorInvocation.args[0] = String(constructorInvocation.args[0]).toUpperCase();
					trace("* StringToUpperCaseConstructorInterceptor arguments changed '" + constructorInvocation.args + "'");
				}
			}
			return constructorInvocation.proceed();
		}
	}
}
