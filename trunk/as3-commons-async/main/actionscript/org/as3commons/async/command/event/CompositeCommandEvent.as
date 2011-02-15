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
package org.as3commons.async.command.event {

	import flash.events.Event;

	import org.as3commons.async.command.ICommand;

	/**
	 *
	 * @author Christophe Herreman
	 * @docref the_operation_api.html#composite_commands
	 */
	public class CompositeCommandEvent extends Event {

		/**
		 * Defines the value of the type property of a <code>CompositeCommandEvent.COMPLETE</code> event object.
	   * @eventType String
			   */
		public static const COMPLETE:String = "compositeCommandComplete";
		/**
		 * Defines the value of the type property of a <code>CompositeCommandEvent.ERROR</code> event object.
	   * @eventType String
			   */
		public static const ERROR:String = "compositeCommandError";
		/**
		 * Defines the value of the type property of a <code>CompositeCommandEvent.BEFORE_EXECUTE_COMMAND</code> event object.
	   * @eventType String
			   */
		public static const BEFORE_EXECUTE_COMMAND:String = "compositeCommandBeforeExecuteCommand";
		/**
		 * Defines the value of the type property of a <code>CompositeCommandEvent.AFTER_EXECUTE_COMMAND</code> event object.
	   * @eventType String
			   */
		public static const AFTER_EXECUTE_COMMAND:String = "compositeCommandAfterExecuteCommand";

		private var _command:ICommand;

		public function get command():ICommand {
			return _command;
		}

		/**
		 * Constructs a new CompositeCommandEvent
		 */
		public function CompositeCommandEvent(type:String, command:ICommand = null, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			_command = command;
		}

		/**
		 * Returns an exact copy of the current <code>CompositeCommandEvent</code> instance.
		 */
		override public function clone():Event {
			return new CompositeCommandEvent(this.type, _command, this.bubbles, this.cancelable);
		}

	}
}