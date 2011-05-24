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

	/**
	 * Dispatched when the current <code>AbstractOperation</code> has new progress information to report.
	 * @eventType org.as3commons.async.operation.OperationEvent#PROGRESS OperationEvent.PROGRESS
	 */
	[Event(name = "operationComplete", type = "org.as3commons.async.operation.OperationEvent")]
	/**
	 * Abstract base class for <code>IProgressOperation</code> implementations.
	 * @author Roland Zwaga
	 */
	public class AbstractProgressOperation extends AbstractOperation implements IProgressOperation {

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new <code>AbstractProgressOperation</code> instance.
		 */
		public function AbstractProgressOperation(timeoutInMilliseconds:uint = 0, autoStartTimeout:Boolean = true) {
			super(timeoutInMilliseconds, autoStartTimeout);
		}

		// --------------------------------------------------------------------
		//
		// Implementation: IProgressOperation: Properties
		//
		// --------------------------------------------------------------------

		/**
		 * @inheritDoc
		 */
		public function get progress():uint {
			return _progress;
		}

		/**
		 * @inheritDoc
		 */
		public function get total():uint {
			return _total;
		}

		// --------------------------------------------------------------------
		//
		// Implementation: IProgressOperation: Methods
		//
		// --------------------------------------------------------------------

		/**
		 * @inheritDoc
		 */
		public function addProgressListener(listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			addEventListener(OperationEvent.PROGRESS, listener, useCapture, priority, useWeakReference);
		}

		/**
		 * @inheritDoc
		 */
		public function removeProgressListener(listener:Function, useCapture:Boolean = false):void {
			removeEventListener(OperationEvent.PROGRESS, listener, useCapture);
		}

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		// ----------------------------
		// progress
		// ----------------------------

		private var _progress:uint;

		/**
		 * Sets the progress of this operation.
		 *
		 * @param value the progress of this operation
		 */
		public function set progress(value:*):void {
			if (value !== progress) {
				_progress = value;
			}
		}

		// ----------------------------
		// total
		// ----------------------------

		private var _total:uint;

		/**
		 * Sets the total amount of progress this operation should make before being done.
		 *
		 * @param value the total amount of progress this operation should make before being done
		 */
		public function set total(value:*):void {
			if (value !== total) {
				_total = value;
			}
		}

		// --------------------------------------------------------------------
		//
		// Protected Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Convenience method for dispatching a <code>OperationEvent.PROGRESS</code> event.
		 * @return true if the event was dispatched; false if not
		 */
		protected function dispatchProgressEvent():void {
			dispatchEvent(OperationEvent.createProgressEvent(this));
		}

	}
}
