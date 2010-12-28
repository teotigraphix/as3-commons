package org.as3commons.bytecode.testclasses {
	import org.as3commons.bytecode.as3commons_bytecode;

	public class SimpleClassWithCustomNamespaceMethod {

		public function SimpleClassWithCustomNamespaceMethod() {
			super();
		}

		as3commons_bytecode function custom():String {
			return "customValue";
		}
	}
}