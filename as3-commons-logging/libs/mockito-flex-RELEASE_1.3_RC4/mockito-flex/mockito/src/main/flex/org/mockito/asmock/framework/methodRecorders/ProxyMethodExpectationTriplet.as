package org.mockito.asmock.framework.methodRecorders
{
	import org.mockito.asmock.framework.expectations.IExpectation;
	import org.mockito.asmock.reflection.MethodInfo;
	
	[ExcludeClass]
	public class ProxyMethodExpectationTriplet
	{
		private var _proxy : Object;
		private var _method : MethodInfo;
		private var _expectation : IExpectation;
		
		public function ProxyMethodExpectationTriplet(proxy : Object, method : MethodInfo, expectation : IExpectation)
		{
			_proxy = proxy;
			_method = method;
			_expectation = expectation;
		}
		
		public function get proxy() : Object { return _proxy; }
		public function set proxy(value : Object) : void { _proxy = value; }
		
		public function get method() : MethodInfo { return _method; }
		public function set method(value : MethodInfo) : void { _method = value; }
		
		public function get expectation() : IExpectation { return _expectation; }
		public function set expectation(value : IExpectation) : void { _expectation = value; }
		
		

	}
}