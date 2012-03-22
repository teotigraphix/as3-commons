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
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;

	public class TimeBasedOperationCompleteTrigger extends AbstractOperationCompleteTrigger {

		private static const logger:ILogger = getClassLogger(TimeBasedOperationCompleteTrigger);

		private var m_durationInMilliseconds:uint;
		private var m_timeoutID:uint;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function TimeBasedOperationCompleteTrigger(durationInMilliseconds:uint) {
			m_durationInMilliseconds = durationInMilliseconds;
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		override public function execute():* {
			logger.debug("Executing");
			m_timeoutID = setTimeout(timeoutDispatcher, m_durationInMilliseconds);
			return null;
		}

		override public function dispose():void {
			logger.debug("Disposing");

			if (!isDisposed && m_timeoutID > 0) {
				clearTimeout(m_timeoutID);
				logger.debug("Cleared timeout");
			}
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		private function timeoutDispatcher():void {
			logger.debug(m_durationInMilliseconds + " ms elapsed. Dispatching complete event.");
			dispatchCompleteEvent();
		}

	}
}
