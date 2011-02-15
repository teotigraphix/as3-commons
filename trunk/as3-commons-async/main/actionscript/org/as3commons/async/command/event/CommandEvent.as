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
	 * @docref the_operation_api.html#commands
	 */
	public class CommandEvent extends Event {

		/**
		 * Defines the value of the type property of a <code>CommandEvent.EXECUTE</code> event object.
	   * @eventType String
			   */
		public static const EXECUTE:String = "executeCommand";

		private var _command:ICommand;

		/**
		 * Creates a new <code>CompositeCommandEvent</code> instance.
		 */
		public function CommandEvent(type:String, command:ICommand, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			_command = command;
		}

		public function get command():ICommand {
			return _command;
		}

		/**
		 * Returns an exact copy of the current <code>CommandEvent</code> instance.
		 */
		override public function clone():Event {
			return new CommandEvent(type, command, bubbles, cancelable);
		}

	}
}