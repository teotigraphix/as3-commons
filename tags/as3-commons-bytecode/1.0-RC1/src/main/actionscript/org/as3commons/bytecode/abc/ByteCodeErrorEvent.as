package org.as3commons.bytecode.abc {
	import flash.events.Event;
	import flash.utils.ByteArray;

	public class ByteCodeErrorEvent extends Event {

		public static const BYTECODE_METHODBODY_ERROR:String = "bytecodeMethodBodyError";

		private var _bytecodeFragment:ByteArray;
		private var _position:int;

		public function ByteCodeErrorEvent(type:String, bytecodeFragment:ByteArray, position:int, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			_bytecodeFragment = bytecodeFragment;
			_position = position;
		}

		public function get position():int {
			return _position;
		}

		public function get bytecodeFragment():ByteArray {
			return _bytecodeFragment;
		}

		override public function clone():Event {
			return new ByteCodeErrorEvent(this.type, this.bytecodeFragment, this.position, this.bubbles, this.cancelable);
		}

	}
}