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

	import flash.events.EventDispatcher;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 * Dispatched when the current <code>AbstractOperation</code> has completed its functionality successfully.
	 * @eventType org.springextensions.actionscript.core.operation.OperationEvent#COMPLETE OperationEvent.COMPLETE
	 */
	[Event(name="operationComplete", type="org.springextensions.actionscript.core.operation.OperationEvent")]

	/**
	 * Dispatched when the current <code>AbstractOperation</code> encountered an error.
	 * @eventType org.springextensions.actionscript.core.operation.OperationEvent#ERROR OperationEvent.ERROR
	 */
	[Event(name="operationError", type="org.springextensions.actionscript.core.operation.OperationEvent")]

	/**
	 * Dispatched when the current <code>AbstractOperation</code> timed out.
	 * @eventType org.springextensions.actionscript.core.operation.OperationEvent#TIMEOUT OperationEvent.TIMEOUT
	 */
	[Event(name="operationTimeout", type="org.springextensions.actionscript.core.operation.OperationEvent")]

	/**
	 * Abstract base class for <code>IOperation</code> implementations.
	 * @author Christophe Herreman
	 * @docref the_operation_api.html#operations
	 */
	public class AbstractOperation extends EventDispatcher implements IOperation {

		// --------------------------------------------------------------------
		//
		// Private Variables
		//
		// --------------------------------------------------------------------

		private var m_autoStartTimeout:Boolean = true;

		/** Identifier for the timeout so we can cancel it. */
		private var m_timeoutId:uint;

		/** Whether or not this operation timed out. */
		private var m_timedOut:Boolean = false;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new <code>AbstractOperation</code>.
		 *
		 * @param timeoutInMilliseconds
		 * @param autoStartTimeout
		 */
		public function AbstractOperation(timeoutInMilliseconds:int = 0, autoStartTimeout:Boolean = true) {
			super(this);

			m_timeout = timeoutInMilliseconds;
			m_autoStartTimeout = autoStartTimeout;

			if (autoStartTimeout) {
				startTimeout();
			}
		}

		// --------------------------------------------------------------------
		//
		// Implementation: IOperation: Properties
		//
		// --------------------------------------------------------------------

		// ----------------------------
		// result
		// ----------------------------

		/**
		 * @inheritDoc
		 */
		public function get result():* {
			return _result;
		}

		// ----------------------------
		// error
		// ----------------------------

		/**
		 * @inheritDoc
		 */
		public function get error():* {
			return _error;
		}

		// ----------------------------
		// timeout
		// ----------------------------

		private var m_timeout:int = 0;

		/**
		 * @inheritDoc
		 */
		public function get timeout():int {
			return m_timeout;
		}

		public function set timeout(value:int):void {
			if (value !== m_timeout) {
				m_timeout = value;
			}
		}

		// --------------------------------------------------------------------
		//
		// Implementation: IOperation: Methods
		//
		// --------------------------------------------------------------------

		/**
		 * @inheritDoc
		 */
		public function addCompleteListener(listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			addEventListener(OperationEvent.COMPLETE, listener, useCapture, priority, useWeakReference);
		}

		/**
		 * @inheritDoc
		 */
		public function addErrorListener(listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			addEventListener(OperationEvent.ERROR, listener, useCapture, priority, useWeakReference);
		}

		/**
		 * @inheritDoc
		 */
		public function addTimeoutListener(listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			addEventListener(OperationEvent.TIMEOUT, listener, useCapture, priority, useWeakReference);
		}

		/**
		 * @inheritDoc
		 */
		public function removeCompleteListener(listener:Function, useCapture:Boolean = false):void {
			removeEventListener(OperationEvent.COMPLETE, listener, useCapture);
		}

		/**
		 * @inheritDoc
		 */
		public function removeErrorListener(listener:Function, useCapture:Boolean = false):void {
			removeEventListener(OperationEvent.ERROR, listener, useCapture);
		}

		/**
		 * @inheritDoc
		 */
		public function removeTimeoutListener(listener:Function, useCapture:Boolean = false):void {
			removeEventListener(OperationEvent.TIMEOUT, listener, useCapture);
		}

		// --------------------------------------------------------------------
		//
		// Public Properties
		//
		// --------------------------------------------------------------------

		// ----------------------------
		// result
		// ----------------------------

		private var _result:*;

		/**
		 * Sets the result of this operation.
		 *
		 * @param value the result of this operation
		 */
		public function set result(value:*):void {
			if (value !== result) {
				_result = value;
			}
		}

		// ----------------------------
		// error
		// ----------------------------

		private var _error:*;

		/**
		 * Sets the error of this operation
		 *
		 * @param value the error of this operation
		 */
		public function set error(value:*):void {
			if (value !== error) {
				_error = value;
			}
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Convenience method for dispatching a <code>OperationEvent.COMPLETE</code> event.
		 *
		 * @return true if the event was dispatched; false if not
		 */
		public function dispatchCompleteEvent(result:* = null):Boolean {
			if (m_timedOut) {
				return false;
			}

			if (result != null) {
				this.result = result;
			}
			return dispatchEvent(OperationEvent.createCompleteEvent(this));
		}

		/**
		 * Convenience method for dispatching a <code>OperationEvent.ERROR</code> event.
		 *
		 * @return true if the event was dispatched; false if not
		 */
		public function dispatchErrorEvent(error:* = null):Boolean {
			if (m_timedOut) {
				return false;
			}

			if (error) {
				this.error = error;
			}
			return dispatchEvent(OperationEvent.createErrorEvent(this));
		}

		/**
		 * Convenience method for dispatching a <code>OperationEvent.TIMEOUT</code> event.
		 *
		 * @return true if the event was dispatched; false if not
		 */
		public function dispatchTimeoutEvent():Boolean {
			return dispatchEvent(OperationEvent.createTimeoutEvent(this));
		}

		// --------------------------------------------------------------------
		//
		// Protected Methods
		//
		// --------------------------------------------------------------------

		protected function startTimeout():void {
			if (timeout > 0) {
				// listen for the complete and error events so we can cancel the timeout
				addCompleteListener(completeHandler);
				addErrorListener(errorHandler);

				// start the timeout
				m_timeoutId = setTimeout(timeoutHandler, timeout);
			}
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		private function completeHandler(event:OperationEvent):void {
			stopTimeout();
		}

		private function errorHandler(event:OperationEvent):void {
			stopTimeout();
		}

		private function timeoutHandler():void {
			m_timedOut = true;
			dispatchTimeoutEvent();
		}

		private function stopTimeout():void {
			clearTimeout(m_timeoutId);
		}
	}
}