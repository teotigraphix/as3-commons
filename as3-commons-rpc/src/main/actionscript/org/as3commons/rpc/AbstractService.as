package org.as3commons.rpc {
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	import org.as3commons.rpc.events.AsyncOperationFaultEvent;
	import org.as3commons.rpc.events.AsyncOperationResultEvent;

	[Event(name="result", type="org.as3commons.rpc.exec.event.AsyncOperationResultEvent")]
	[Event(name="fault", type="org.as3commons.rpc.exec.event.AsyncOperationFaultEvent")]

	/**
	 * Abstract Service.
	 *
	 * @author Jan Van Coppenolle
	 */
	public class AbstractService extends EventDispatcher implements IAsyncOperationResponder {

		/**
		 * @private
		 */
		public function AbstractService(target:IEventDispatcher=null) {
			super(target);
		}

		////////////////////////////////////////////////////////////////////////
		
		public var deserializer:IDeserializer;

		////////////////////////////////////////////////////////////////////////
		// IAsyncOperationResponder impl

		/**
		 * @private
		 */
		public function resultHandler(event:AsyncOperationResultEvent):void {
			if (deserializer != null)
				deserializer.deserialize(event);

			if (hasEventListener(AsyncOperationResultEvent.RESULT))
				dispatchEvent(event);
		}

		/**
		 * @private
		 */
		public function faultHandler(event:AsyncOperationFaultEvent):void {
			if (deserializer != null)
				deserializer.deserialize(event);

			if (hasEventListener(AsyncOperationFaultEvent.FAULT))
				dispatchEvent(event);
		}
	}
}
