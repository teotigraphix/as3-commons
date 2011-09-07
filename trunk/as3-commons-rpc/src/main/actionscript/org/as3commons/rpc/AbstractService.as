package org.as3commons.rpc {
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	import org.as3commons.rpc.exec.IAsyncOperationResponder;
	import org.as3commons.rpc.exec.event.AsyncOperationFaultEvent;
	import org.as3commons.rpc.exec.event.AsyncOperationResultEvent;
	import org.as3commons.rpc.lang.IProcessor;

	[Event(name="result", type="org.as3commons.rpc.exec.event.AsyncOperationResultEvent")]
	[Event(name="fault", type="org.as3commons.rpc.exec.event.AsyncOperationFaultEvent")]

	/**
	 * Abstract Service.
	 *
	 * @author Jan Van Coppenolle
	 */
	public class AbstractService extends EventDispatcher implements IAsyncOperationResponder {
		public var responseProcessor:IProcessor;

		////////////////////////////////////////////////////////////////////////

		/**
		 * @private
		 */
		public function AbstractService(target:IEventDispatcher=null) {
			super(target);
		}

		////////////////////////////////////////////////////////////////////////

		/**
		 * @private
		 */
		public function resultHandler(event:AsyncOperationResultEvent):void {
			if (responseProcessor != null)
				responseProcessor.process(event);

			if (hasEventListener(AsyncOperationResultEvent.RESULT))
				dispatchEvent(event);
		}

		/**
		 * @private
		 */
		public function faultHandler(event:AsyncOperationFaultEvent):void {
			if (responseProcessor != null)
				responseProcessor.process(event);

			if (hasEventListener(AsyncOperationFaultEvent.FAULT))
				dispatchEvent(event);
		}
	}
}
