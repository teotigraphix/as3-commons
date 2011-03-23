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
package org.as3commons.async.task.command {
	import flash.events.EventDispatcher;

	import org.as3commons.async.command.ICommand;
	import org.as3commons.async.task.ITaskFlowControl;
	import org.as3commons.async.task.TaskFlowControlKind;
	import org.as3commons.async.task.event.TaskFlowControlEvent;
	import org.as3commons.lang.Assert;

	/**
	 *
	 * @author Roland Zwaga
	 * @docref the_operation_api.html#tasks
	 */
	public class TaskFlowControlCommand extends EventDispatcher implements ICommand, ITaskFlowControl {
		private var _kind:TaskFlowControlKind;

		/**
		 * Creates a new <code>TaskFlowControlCommand</code> instance.
		 * @param kind
		 */
		public function TaskFlowControlCommand(kind:TaskFlowControlKind) {
			Assert.notNull(kind, "The kind argument must not be null");
			super();
			_kind = kind;
		}

		public function execute():* {
			dispatchEvent(new TaskFlowControlEvent(this.kind));
			return this.kind;
		}

		public function get kind():TaskFlowControlKind {
			return _kind;
		}

	}
}