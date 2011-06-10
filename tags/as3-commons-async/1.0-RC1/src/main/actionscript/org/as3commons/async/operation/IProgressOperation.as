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
	 * Dispatched after the current <code>IProgressOperation</code> received a progress update.
	 * @eventType org.as3commons.async.operation.OperationEvent.PROGRESS OperationEvent.PROGRESS
	 */
	[Event(name = "operationProgress", type = "org.as3commons.async.operation.OperationEvent")]
	/**
	 * Subinterface of <code>IOperation</code> that contains information about the progress of an operation.
	 *
	 * @author Christophe Herreman
	 */
	public interface IProgressOperation extends IOperation {

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		/**
		 * The progress of this operation.
		 *
		 * @return the progress of this operation
		 */
		function get progress():uint;

		/**
		 * The total amount of progress this operation should make before being done.
		 *
		 * @return the total amount of progress this operation should make before being done
		 */
		function get total():uint;

		// --------------------------------------------------------------------
		//
		// Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Convenience method for adding a listener to the OperationEvent.PROGRESS event.
		 *
		 * @param listener the event handler function
		 */
		function addProgressListener(listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void;

		/**
		 * Convenience method for removing a listener from the OperationEvent.PROGRESS event.
		 *
		 * @param listener the event handler function
		 */
		function removeProgressListener(listener:Function, useCapture:Boolean = false):void;
	}
}
