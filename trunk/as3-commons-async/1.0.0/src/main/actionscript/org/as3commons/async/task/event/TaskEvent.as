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
package org.as3commons.async.task.event {

	import flash.events.Event;

	import org.as3commons.async.command.ICommand;
	import org.as3commons.async.task.ITask;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public class TaskEvent extends Event {

		/**
		 * Defines the value of the type property of a <code>TaskEvent.TASK_ERROR</code> event object.
		 * @eventType String
		 */
		public static const TASK_ERROR:String = "taskError";
		/**
		 * Defines the value of the type property of a <code>TaskEvent.TASK_ABORTED</code> event object.
		 * @eventType String
		 */
		public static const TASK_ABORTED:String = "taskAborted";
		/**
		 * Defines the value of the type property of a <code>TaskEvent.TASK_COMPLETE</code> event object.
		 * @eventType String
		 */
		public static const TASK_COMPLETE:String = "taskComplete";
		/**
		 * Defines the value of the type property of a <code>TaskEvent.BEFORE_EXECUTE_COMMAND</code> event object.
		 * @eventType String
		 */
		public static const BEFORE_EXECUTE_COMMAND:String = "taskBeforeExecuteCommand";
		/**
		 * Defines the value of the type property of a <code>TaskEvent.AFTER_EXECUTE_COMMAND</code> event object.
		 * @eventType String
		 */
		public static const AFTER_EXECUTE_COMMAND:String = "taskAfterExecuteCommand";

		private var _command:ICommand;

		public function get command():ICommand {
			return _command;
		}

		private var _task:ITask;

		public function get task():ITask {
			return _task;
		}

		/**
		 * Creates a new <code>TaskEvent</code> instance.
		 */
		public function TaskEvent(type:String, task:ITask, command:ICommand, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			_command = command;
			_task = task;
		}

		/**
		 * @return An exact copy of the current <code>TaskEvent</code>.
		 */
		override public function clone():Event {
			return new TaskEvent(this.type, _task, _command, this.bubbles, this.cancelable);
		}

	}
}
