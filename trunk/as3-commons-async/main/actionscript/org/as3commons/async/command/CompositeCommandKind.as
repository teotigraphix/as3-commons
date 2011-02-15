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
package org.as3commons.async.command {
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.StringUtils;

	/**
	 * Enumeration that defines the different ways an <code>ICompositeCommand</code> can execute its collection
	 * of <code>ICommands</code>
	 * @author Roland Zwaga
	 * @see org.springextensions.actionscript.core.command.CompositeCommand CompositeCommand
	 * @see org.springextensions.actionscript.core.command.ICommand ICommand
	 * @docref the_operation_api.html#composite_commands
	 */
	public final class CompositeCommandKind {

		/**
		 * Determines that the <code>ICompositeCommand</code> will execute its collection of command one after the other.
		 */
		public static const SEQUENCE:CompositeCommandKind = new CompositeCommandKind(SEQUENCE_NAME);

		/**
		 * Determines that the <code>ICompositeCommand</code> will execute its collection of command all at the same time.
		 */
		public static const PARALLEL:CompositeCommandKind = new CompositeCommandKind(PARALLEL_NAME);

		private static const SEQUENCE_NAME:String = "sequence";

		private static const PARALLEL_NAME:String = "parallel";

		private static var _enumCreated:Boolean = false;

		private var _name:String;

		{
			_enumCreated = true;
		}

		/**
		 * Creates a new <code>ComposeiteCommandKind</code> instance. Do not call this constructor
		 * directly, it is only used internally the create the appropriate instances.
		 * @param name The string representation of the current <code>ComposeiteCommandKind</code> instance.
		 */
		public function CompositeCommandKind(name:String) {
			Assert.state(!_enumCreated, "The ComposeiteCommandKind enum has already been created.");
			_name = name;
		}

		/**
		 * Returns the <code>ComposeiteCommandKind</code> instance whose <code>name</code> property is equivalent
		 * to the specified <code>name</code> argument, or null if the name doesn't exist.
		 * @param name the specified <code>name</code>.
		 * @return The <code>ComposeiteCommandKind</code> instance whose <code>name</code> property is equivalent
		 * to the specified <code>name</code> argument, or null if the name doesn't exist.
		 */
		public static function fromName(name:String):CompositeCommandKind {
			var result:CompositeCommandKind;

			// check if the name is a valid value in the enum
			switch (StringUtils.trim(name.toLowerCase())) {
				case SEQUENCE_NAME:
					result = SEQUENCE;
					break;
				case PARALLEL_NAME:
					result = PARALLEL;
					break;
				default:
					result = SEQUENCE;
			}
			return result;
		}

		/**
		 * Returns the name of the current <code>ComposeiteCommandKind</code>.
		 * @return The name of the current <code>ComposeiteCommandKind</code>.
		 */
		public function get name():String {
			return _name;
		}

		/**
		 * Returns a string representation of the current <code>ComposeiteCommandKind</code>.
		 * @return A string representation of the current <code>ComposeiteCommandKind</code>.
		 */
		public function toString():String {
			return _name;
		}

	}
}