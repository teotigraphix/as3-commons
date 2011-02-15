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

	import org.as3commons.async.task.TaskFlowControlKind;

	/**
	 *
	 * @author Roland Zwaga
	 * @docref the_operation_api.html#tasks
	 */
	public class TaskFlowControlEvent extends Event {

		/**
		 * Indicates a break in the flow control.
		 */
		public static const BREAK:String = TaskFlowControlKind.BREAK.name;
		/**
		 * Indicates a continuation in the flow control.
		 */
		public static const CONTINUE:String = TaskFlowControlKind.CONTINUE.name;
		/**
		 * Indicates an exit (abort) of the flow control.
		 */
		public static const EXIT:String = TaskFlowControlKind.EXIT.name;

		/**
		 * Creates a new <code>TaskFlowControlEvent</code> instance.
		 * @param kind
		 * @param bubbles
		 * @param cancelable
		 */
		public function TaskFlowControlEvent(kind:TaskFlowControlKind, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(kind.name, bubbles, cancelable);
		}

		/**
		 * @return An exact copy of the current <code>TaskFlowControlEvent</code>.
		 */
		override public function clone():Event {
			return new TaskFlowControlEvent(TaskFlowControlKind.fromName(this.type), this.bubbles, this.cancelable);
		}

	}
}