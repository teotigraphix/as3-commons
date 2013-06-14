/*
 * Copyright 2007-2012 the original author or authors.
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
package org.as3commons.async.operation.trigger.impl {
	import flash.errors.IllegalOperationError;

	import org.as3commons.async.operation.event.OperationEvent;
	import org.as3commons.async.operation.trigger.IOperationCompleteTrigger;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;

	public class AbstractParallelOperationCompleteTrigger extends AbstractCompositeOperationCompleteTrigger {

		private static const logger:ILogger = getClassLogger(AbstractParallelOperationCompleteTrigger);

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function AbstractParallelOperationCompleteTrigger() {
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		override public function dispose():void {
			if (!isDisposed) {
				logger.debug("Disposing");
				removeTriggerListeners();
				super.dispose();
			}
		}

		// --------------------------------------------------------------------
		//
		// Protected Methods
		//
		// --------------------------------------------------------------------

		override protected function doExecute():void {
			addTriggerListeners();
			startTriggers();
		}

		protected function trigger_completeHandler(event:OperationEvent):void {
			throw new IllegalOperationError();
		}

		protected function addTriggerListeners():void {
			for each (var trigger:IOperationCompleteTrigger in triggers) {
				trigger.addCompleteListener(trigger_completeHandler);
			}
		}

		protected function removeTriggerListeners():void {
			logger.debug("Removing trigger listeners");

			for each (var trigger:IOperationCompleteTrigger in triggers) {
				trigger.removeCompleteListener(trigger_completeHandler);
			}
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		private function startTriggers():void {
			for each (var trigger:IOperationCompleteTrigger in triggers) {
				trigger.execute();
			}
		}
	}
}
