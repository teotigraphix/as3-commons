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
package org.as3commons.async.task {

	import org.as3commons.lang.Assert;
	import org.as3commons.lang.StringUtils;

	/**
	 * Enumeration that describes different kinds of flow control.
	 * @author Roland Zwaga
	 * @docref the_operation_api.html#tasks
	 */
	public final class TaskFlowControlKind {

		/**
		 * Indicates a break in the flow control.
		 */
		public static const BREAK:TaskFlowControlKind = new TaskFlowControlKind(BREAK_NAME);

		/**
		 * Indicates a continuation in the flow control.
		 */
		public static const CONTINUE:TaskFlowControlKind = new TaskFlowControlKind(CONTINUE_NAME);

		/**
		 * Indicates an exit (abort) of the flow control.
		 */
		public static const EXIT:TaskFlowControlKind = new TaskFlowControlKind(EXIT_NAME);

		private static const BREAK_NAME:String = "break";

		private static const CONTINUE_NAME:String = "continue";

		private static const EXIT_NAME:String = "exit";

		private static var _enumCreated:Boolean = false;

		private var _name:String;

		{
			_enumCreated = true;
		}

		/**
		 * Creates a new <code>TaskFlowControlKind</code> instance.
		 * @param name The name of the current <code>TaskFlowControlKind</code>
		 */
		public function TaskFlowControlKind(name:String) {
			Assert.state(!_enumCreated, "The TaskFlowControlKind enum has already been created.");
			_name = name;
		}

		/**
		 * Converts, if possible, a <code>String</code> to its <code>TaskFlowControlKind</code> equivalent.
		 * @param name the name of the requested <code>TaskFlowControlKind</code>.
		 * @return A <code>TaskFlowControlKind</code> instance whose name value is equal to the specified <code>name</code> argument.
		 * @throws flash.errors.Error Error when the specified name cannot be converted to a valid <code>TaskFlowControlKind</code> instance.
		 */
		public static function fromName(name:String):TaskFlowControlKind {
			var result:TaskFlowControlKind;

			// check if the name is a valid value in the enum
			switch (StringUtils.trim(name.toLowerCase())) {
				case BREAK_NAME.toLowerCase():
					result = BREAK;
					break;
				case CONTINUE_NAME.toLowerCase():
					result = CONTINUE;
					break;
				case EXIT_NAME.toLowerCase():
					result = EXIT;
					break;
				default:
					throw new Error("Unknown TaskFlowControlKind value: " + name);
					break;
			}
			return result;
		}

		/**
		 * @return The name of the current <code>TaskFlowControlKind</code>.
		 */
		public function get name():String {
			return _name;
		}

		/**
		 * @return A <code>String</code> representation of the current <code>TaskFlowControlKind</code>.
		 */
		public function toString():String {
			return _name;
		}

	}
}