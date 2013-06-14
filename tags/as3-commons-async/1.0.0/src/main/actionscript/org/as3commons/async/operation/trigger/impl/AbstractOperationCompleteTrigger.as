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

	import org.as3commons.async.operation.impl.AbstractOperation;
	import org.as3commons.async.operation.trigger.IOperationCompleteTrigger;

	public class AbstractOperationCompleteTrigger extends AbstractOperation implements IOperationCompleteTrigger {
		private var m_complete:Boolean = false;
		private var m_isDisposed:Boolean = false;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function AbstractOperationCompleteTrigger() {
		}

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		public function get isComplete():Boolean {
			return m_complete;
		}

		public function get isDisposed():Boolean {
			return m_isDisposed;
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		public function execute():* {
			throw new IllegalOperationError("execute is abstract");
		}

		public function dispose():void {
			m_isDisposed = true
		}

		override public function dispatchCompleteEvent(result:* = null):Boolean {
			var result2:Boolean = super.dispatchCompleteEvent(result);
			m_complete = true;
			return result2;
		}
	}
}
