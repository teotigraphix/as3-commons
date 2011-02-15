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

	/**
	 * Describes an object that represents a block that can be continuously executed or interupted.
	 * @author Roland Zwaga
	 * @docref the_operation_api.html#tasks
	 */
	public interface ITaskBlock {
		/**
		 * If <code>true</code> no more <code>ICommands</code> can be added to the current <code>ITaskBlock</code>.
		 */
		function get isClosed():Boolean;
		/**
		 * Interupts the current <code>ITaskBlock</code> if its part of a loop construct.
		 * @return The current <code>ITaskBlock</code>'s parent task;
		 */
		function break_():ITask;
		/**
		 * Continues the current <code>ITaskBlock</code> if its part of a loop construct.
		 * @return The current <code>ITaskBlock</code>'s parent task;
		 */
		function continue_():ITask;
	}
}