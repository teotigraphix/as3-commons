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
package org.as3commons.async.task.impl {

	import flash.errors.IllegalOperationError;

	import org.as3commons.async.command.CompositeCommandKind;
	import org.as3commons.async.command.ICommand;
	import org.as3commons.async.operation.IOperation;
	import org.as3commons.async.task.ITask;
	import org.as3commons.async.task.ITaskBlock;
	import org.as3commons.async.task.TaskFlowControlKind;
	import org.as3commons.async.task.command.TaskCommand;
	import org.as3commons.async.task.command.TaskFlowControlCommand;
	import org.as3commons.async.task.event.TaskEvent;
	import org.as3commons.async.task.event.TaskFlowControlEvent;

	/**
	 * Base class for <code>ITaskBlock</code> implementations.
	 * @inheritDoc
	 */
	public class AbstractTaskBlock extends Task implements ITaskBlock {

		private static const CLASS_IS_ABSTRACT_ERROR:String = "AbstractTaskBlock class is abstract";

		/**
		 * Creates a new <code>AbstractTaskBlock</code> instance.
		 */
		public function AbstractTaskBlock(self:AbstractTaskBlock) {
			super();
			initAbstractTaskBlock(self);
		}

		protected function initAbstractTaskBlock(self:AbstractTaskBlock):void {
			if (self !== this) {
				throw new IllegalOperationError(CLASS_IS_ABSTRACT_ERROR);
			}
		}

		override protected function executeCommand(command:ICommand):void {
			currentCommand = command;
			if (command) {
				if (doFlowControlCheck(command)) {
					var async:IOperation = command as IOperation;
					addCommandListeners(async);
					dispatchTaskEvent(TaskEvent.BEFORE_EXECUTE_COMMAND, command);
					command.execute();
					if (async == null) {
						dispatchTaskEvent(TaskEvent.AFTER_EXECUTE_COMMAND, command);
						executeNextCommand();
					}
				}
			} else {
				restartExecution();
			}
		}

		protected function doFlowControlCheck(command:ICommand):Boolean {
			var tc:TaskCommand = command as TaskCommand;
			if (tc != null) {
				var flowControl:TaskFlowControlCommand = tc.commands[0] as TaskFlowControlCommand;
				if (flowControl != null) {
					return executeFlowControl(flowControl.kind);
				}
			}
			return true;
		}

		protected function executeFlowControl(kind:TaskFlowControlKind):Boolean {
			switch (kind) {
				case TaskFlowControlKind.BREAK:
					resetCommandList();
					completeExecution();
					return false;
					break;
				case TaskFlowControlKind.CONTINUE:
					restartExecution();
					return false;
					break;
				case TaskFlowControlKind.EXIT:
					exitExecution();
					return false;
					break;
				default:
					return true;
					break;
			}
		}

		protected function exitExecution():void {
			//nothing?
		}

		protected function restartExecution():void {
			resetCommandList();
			execute();
		}

		override protected function TaskFlowControlEvent_handler(event:TaskFlowControlEvent):void {
			executeFlowControl(TaskFlowControlKind.fromName(event.type));
		}

		/**
		 * @inheritDoc
		 */
		override public function end():ITask {
			setIsClosed(true);
			return (this.parent != null) ? this.parent : this;
		}

		/**
		 * @inheritDoc
		 */
		override public function break_():ITask {
			var result:ITask;
			result = addCommand(new TaskFlowControlCommand(TaskFlowControlKind.BREAK), CompositeCommandKind.SEQUENCE);
			return (result != null) ? result : this;
		}

		/**
		 * @inheritDoc
		 */
		override public function continue_():ITask {
			var result:ITask;
			result = addCommand(new TaskFlowControlCommand(TaskFlowControlKind.CONTINUE), CompositeCommandKind.SEQUENCE);
			return (result != null) ? result : this;
		}

	}
}
