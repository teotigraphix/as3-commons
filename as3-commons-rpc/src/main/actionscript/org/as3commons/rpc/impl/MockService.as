package org.as3commons.rpc.impl {

	import flash.events.IEventDispatcher;
	
	import org.as3commons.rpc.AbstractService;
	import org.as3commons.rpc.impl.AsyncOperationToken;
	import org.as3commons.rpc.impl.MockAsyncOperationToken;

	[Event(name="result", type="org.as3commons.rpc.exec.event.AsyncOperationResultEvent")]
	[Event(name="fault", type="org.as3commons.rpc.exec.event.AsyncOperationFaultEvent")]

	/**
	 * Mock Service implementation.
	 *
	 * @author Jan Van Coppenolle
	 */
	public class MockService extends AbstractService {
		
		/**
		 * @private
		 */
		public function MockService(target:IEventDispatcher=null) {
			super(target);
		}

		////////////////////////////////////////////////////////////////////////

		/**
		 * Triggers an async result.
		 */
		public function asyncResult(data:Object, operation:String=null):AsyncOperationToken {
			var token:MockAsyncOperationToken = new MockAsyncOperationToken(operation);
			token.asyncResult(data);
			token.addResponder(this);
			return token;
		}

		/**
		 * Triggers an async fault.
		 */
		public function asyncFault(data:Object, operation:String=null):AsyncOperationToken {
			var token:MockAsyncOperationToken = new MockAsyncOperationToken(operation);
			token.asyncFault(data);
			token.addResponder(this);
			return token;
		}
	}
}
