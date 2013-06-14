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
	import org.as3commons.async.command.CompositeCommandKind;
	import org.as3commons.async.command.impl.CompositeCommand;
	import org.as3commons.async.operation.event.OperationEvent;
	import org.as3commons.async.operation.trigger.IOperationCompleteTrigger;

	public class SequenceOperationCompleteTrigger extends AbstractCompositeOperationCompleteTrigger {

		private var m_commandQueue:CompositeCommand;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function SequenceOperationCompleteTrigger() {
			m_commandQueue = new CompositeCommand(CompositeCommandKind.SEQUENCE);
			m_commandQueue.addCompleteListener(commandQueue_completeHandler);
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		override public function addTrigger(trigger:IOperationCompleteTrigger):void {
			super.addTrigger(trigger);
			m_commandQueue.addCommand(trigger);
		}

		override protected function doExecute():void {
			m_commandQueue.execute();
		}

		override public function dispose():void {
			if (!isDisposed) {
				m_commandQueue.removeCompleteListener(commandQueue_completeHandler);
				m_commandQueue = null;
				super.dispose();
			}
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		private function commandQueue_completeHandler(event:OperationEvent):void {
			dispose();
			dispatchCompleteEvent();
		}
	}
}
