/*
 * Copyright 2007-2011 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.as3commons.async.operation {

	import flash.utils.setTimeout;

	import org.as3commons.lang.ArrayUtils;

	/**
	 * Dispatched when all the operations in the current <code>OperationQueue</code> have received a result.
	 * @eventType org.springextensions.actionscript.core.event.OperationEvent#COMPLETE OperationEvent.COMPLETE
	 */
	[Event(name = "operationComplete", type = "org.springextensions.actionscript.core.operation.OperationEvent")]
	/**
	 * A queue of <code>IOperation</code> objects that dispatches an <code>OperationEvent.COMPLETE</code> event when
	 * all operations in the queue have completed (and dispatched a corresponding <code>OperationEvent.COMPLETE</code>
	 * event). Useful for invoking multiple operations and getting informed when all operations are finished without
	 * the need to keep track of each individual instance.
	 * @see org.springextensions.actionscript.core.operation.OperationEvent OperationEvent
	 * @author Christophe Herreman
	 */
	public class OperationQueue extends AbstractProgressOperation {

		/** A static counter of queues. */
		private static var _queueCounter:uint = 0;

		/** The name of the queue. */
		private var _name:String;

		/** The operations in this queue. */
		private var _operations:Array = [];

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new <code>OperationQueue</code> instance.
		 * @param name the name of the queue; if no name is given, one will be generated.
		 */
		public function OperationQueue(name:String = "") {
			_queueCounter++;
			_name = (!name) ? "queue_" + _queueCounter.toString() : name;
		}

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		/**
		 * The name of the queue, or the generated name if none was passed into the constructor.
		 */
		public function get name():String {
			return _name;
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Adds an operation to the queue. The operation will not be added if it was previously added to the queue.
		 * @param operation The <code>IOperation</code> that needs to be added to the current queue.
		 * @return true if the operation was added; false if not
		 */
		public function addOperation(operation:IOperation):Boolean {
			if (_operations.indexOf(operation) == -1) {
				_operations.push(operation);
				addOperationListeners(operation);
				total++;
				return true;
			}
			return false;
		}

		/**
		 * @return A <code>String</code> representation of the current <code>OperationQueue</code>.
		 */
		override public function toString():String {
			return "[OperationQueue(name='" + name + "',operations:'" + _operations.length + "', total:'" + total.toString() + "', progress:'" + progress.toString() + "')]";
		}

		// --------------------------------------------------------------------
		//
		// Protected Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Handles the completion of an operation in this queue. An <code>OperationEvent.PROGRESS</code> event is
		 * dispatched when more operations are left in the queue, or if all operations are complete an
		 * <code>OperationEvent.COMPLETE</code> is dispatched.
		 *
		 * @param event the event of the operation that completed
		 */
		protected function operation_completeHandler(event:OperationEvent):void {
			removeOperationListeners(event.operation);
			ArrayUtils.removeItem(_operations, event.operation);
			progress++;

			if (_operations.length == 0) {
				dispatchCompleteEvent();
			} else {
				dispatchProgressEvent();
			}
		}

		/**
		 * Handles an error from an operation in this queue.
		 */
		protected function operation_errorHandler(event:OperationEvent):void {
			removeOperationListeners(event.operation);
			ArrayUtils.removeItem(_operations, event.operation);
			progress++;

			// redispatch an error from an operation in this queue
			// note: don't immediately dispatch the error if it comes from another operation queue
			// since this will cause this queue to be complete before the inner operation queue is complete

			if (event.operation is OperationQueue) {
				var queue:OperationQueue = OperationQueue(event.operation);
				var queueComplete:Boolean = (queue.progress == queue.total);

				if (queueComplete) {
					setTimeout(redispatchErrorAndContinue, 1, event.error);
					return; // quit here!
				}
			}

			redispatchErrorAndContinue(event.error);
		}

		/**
		 * Adds the <code>operation_completeHandler</code> and <code>operation_errorHandler</code> event handler to
		 * the specified <code>operation</code> instance.
		 */
		protected function addOperationListeners(operation:IOperation):void {
			if (operation) {
				operation.addCompleteListener(operation_completeHandler);
				operation.addErrorListener(operation_errorHandler);
			}
		}

		/**
		 * Removes the <code>operation_completeHandler</code> and <code>operation_errorHandler</code> event handler from
		 * the specified <code>operation</code> instance.
		 */
		protected function removeOperationListeners(operation:IOperation):void {
			if (operation) {
				operation.removeCompleteListener(operation_completeHandler);
				operation.removeErrorListener(operation_errorHandler);
			}
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		private function redispatchErrorAndContinue(error:*):void {
			dispatchErrorEvent(error);

			if (_operations.length == 0) {
				dispatchCompleteEvent();
			} else {
				dispatchProgressEvent();
			}
		}

	}
}
