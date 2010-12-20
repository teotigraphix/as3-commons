package org.as3commons.bytecode.testclasses {
	import flash.events.IEventDispatcher;

	import org.as3commons.bytecode.as3commons_bytecode_proxy;
	import org.as3commons.bytecode.interception.IMethodInvocationInterceptor;

	public class ProxySubClass extends TestProxiedClass {

		as3commons_bytecode_proxy var methodInvocationInterceptor:IMethodInvocationInterceptor;

		public function ProxySubClass(interceptor:IMethodInvocationInterceptor, target:IEventDispatcher = null) {
			as3commons_bytecode_proxy::methodInvocationInterceptor = interceptor;
			var params:Array = [target];
			interceptor.intercept(this, "constructor", null, params);
			super(params[0])
		}

		override public function returnString():String {
			return as3commons_bytecode_proxy::methodInvocationInterceptor.intercept(this, "returnString", super.returnString);
		}

		override public function returnStringWithParameters(param:String):String {
			return as3commons_bytecode_proxy::methodInvocationInterceptor.intercept(this, "returnStringWithParameters", super.returnStringWithParameters, [param]);
		}

		override public function voidWithParameters(param:String):void {
			as3commons_bytecode_proxy::methodInvocationInterceptor.intercept(this, "voidWithParameters", super.voidWithParameters, [param]);
		}

	}
}