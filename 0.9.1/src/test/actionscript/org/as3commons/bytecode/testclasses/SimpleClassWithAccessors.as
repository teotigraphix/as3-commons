package org.as3commons.bytecode.testclasses {

	public class SimpleClassWithAccessors {

		private var _getter:int = 10;
		private var _setter:int = 10;

		public function SimpleClassWithAccessors() {
			super();
		}

		public function get getter():int {
			return _getter;
		}

		public function set setter(value:int):void {
			_setter = value;
		}

		public function checkSetter():int {
			return _setter;
		}

	}
}