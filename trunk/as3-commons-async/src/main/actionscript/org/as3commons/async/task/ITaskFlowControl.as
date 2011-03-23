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

	import flash.events.IEventDispatcher;

	/**
	 * Dispatched when the current <code>ITaskFlowControl</code> wants to break out of a loop construct.
	 * @eventType org.springextensions.actionscript.core.task.event.TaskFlowControlEvent#BREAK TaskFlowControlEvent.BREAK
	 */
	[Event(name="break", type="org.springextensions.actionscript.core.task.event.TaskFlowControlEvent")]
	/**
	 * Dispatched when the current <code>ITaskFlowControl</code> wants to continue a loop construct.
	 * @eventType org.springextensions.actionscript.core.task.event.TaskFlowControlEvent#CONTINUE TaskFlowControlEvent.CONTINUE
	 */
	[Event(name="continue", type="org.springextensions.actionscript.core.task.event.TaskFlowControlEvent")]
	/**
	 * Dispatched when the current <code>ITaskFlowControl</code> wants to exit a block construct completely.
	 * @eventType org.springextensions.actionscript.core.task.event.TaskFlowControlEvent#EXIT TaskFlowControlEvent.EXIT
	 */
	[Event(name="exit", type="org.springextensions.actionscript.core.task.event.TaskFlowControlEvent")]
	/**
	 * Describes an object that can influence the flow of control within a task.
	 * @author Roland Zwaga
	 * @docref the_operation_api.html#tasks
	 */
	public interface ITaskFlowControl extends IEventDispatcher {
		/**
		 * An <code>TaskFlowControlKind</code> instance that determines the kind of flow change the current
		 * <code>ITaskFlowControl</code> can establish.
		 * @return The specified <code>TaskFlowControlKind</code>.
		 */
		function get kind():TaskFlowControlKind;
	}
}