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

	import org.as3commons.async.operation.trigger.ICompositeOperationCompleteTrigger;
	import org.as3commons.async.operation.trigger.IOperationCompleteTrigger;
	import org.as3commons.lang.Assert;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;

	public class AbstractCompositeOperationCompleteTrigger extends AbstractOperationCompleteTrigger implements ICompositeOperationCompleteTrigger {

		private static const logger:ILogger = getClassLogger(AbstractCompositeOperationCompleteTrigger);

		protected var triggers:Vector.<IOperationCompleteTrigger>;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function AbstractCompositeOperationCompleteTrigger() {
			triggers = new Vector.<IOperationCompleteTrigger>();
		}

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		private var m_isExecuting:Boolean = false;

		public function get isExecuting():Boolean {
			return m_isExecuting;
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		override public function dispose():void {
			if (!isDisposed) {
				disposeTriggers();
				super.dispose();
			}
		}

		public function addTrigger(trigger:IOperationCompleteTrigger):void {
			Assert.state(!isExecuting);
			triggers.push(trigger);
		}

		final override public function execute():* {
			m_isExecuting = true;
			doExecute();
			return null;
		}

		// --------------------------------------------------------------------
		//
		// Protected Methods
		//
		// --------------------------------------------------------------------

		protected function doExecute():void {
			throw new IllegalOperationError();
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		private function disposeTriggers():void {
			logger.debug("Disposing triggers");

			for each (var trigger:IOperationCompleteTrigger in triggers) {
				trigger.dispose();
			}
		}

	}
}
