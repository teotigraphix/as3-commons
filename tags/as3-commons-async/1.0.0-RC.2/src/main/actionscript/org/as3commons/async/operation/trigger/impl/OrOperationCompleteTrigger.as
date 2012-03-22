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
	import org.as3commons.async.operation.event.OperationEvent;
	import org.as3commons.lang.builder.ToStringBuilder;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;

	public class OrOperationCompleteTrigger extends AbstractParallelOperationCompleteTrigger {

		private static const logger:ILogger = getClassLogger(OrOperationCompleteTrigger);

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function OrOperationCompleteTrigger() {
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		override public function toString():String {
			return new ToStringBuilder(this)
					.append(triggers.length, "numTriggers")
					.toString();
		}

		// --------------------------------------------------------------------
		//
		// Protected Methods
		//
		// --------------------------------------------------------------------

		override protected function trigger_completeHandler(event:OperationEvent):void {
			logger.debug("Trigger complete '{0}'", [event.operation]);
			dispose();
			dispatchCompleteEvent();
		}

	}
}
