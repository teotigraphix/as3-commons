package org.as3commons.aop {

	import org.as3commons.lang.Assert;

	public class MessageWriter {

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function MessageWriter(message:String) {
			Assert.hasText(message, "The 'message' must not be null or empty.");
			trace("MessageWriter.constructor with argument '" + message + "'");
			_message = message;
		}

		private var _message:String;

		public function get message():String {
			return _message;
		}

		public function set message(value:String):void {
			_message = value;
		}

		public function writeMessage():Boolean {
			trace("MessageWriter.writeMessage()");
			return true;
		}
		
		public function writeAnotherMessage():Boolean {
			trace("MessageWriter.writeAnotherMessage()");
			return true;
		}
		
		public function writeYetAnotherMessage():void {
			trace("MessageWriter.writeYetAnotherMessage()");
		}
		
		public function writeMessageThrowError():void {
			throw new Error("Thrown by MessageWriter");
		}
		
	}
}
