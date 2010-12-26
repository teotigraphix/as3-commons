package org.as3commons.bytecode.testclasses {

	[Transient(arg="classtest")]
	public class SimpleClassWithMetadata {
		public function SimpleClassWithMetadata() {
			super();
		}

		[Transient(arg="methodtest")]
		public function simpleMethod():void {

		}

		[Transient(arg="accessortest")]
		public function get getter():String {
			return "stuff";
		}
	}
}