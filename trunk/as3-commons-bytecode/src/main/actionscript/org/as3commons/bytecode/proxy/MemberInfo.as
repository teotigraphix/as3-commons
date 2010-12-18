package org.as3commons.bytecode.proxy {

	internal class MemberInfo {

		private var _isProtected:Boolean;
		private var _qName:QName;

		public function MemberInfo(name:String, namespace:String = null, isProtected:Boolean = false) {
			super();
			_isProtected = isProtected;
			_qName = new QName(namespace, name);
		}

		public function get isProtected():Boolean {
			return _isProtected;
		}

		public function get qName():QName {
			return _qName;
		}

	}
}