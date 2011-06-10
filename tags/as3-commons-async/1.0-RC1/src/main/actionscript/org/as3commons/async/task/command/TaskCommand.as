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

	import org.as3commons.async.command.CompositeCommand;
	import org.as3commons.async.command.CompositeCommandKind;
	import org.as3commons.async.command.ICommand;
	import org.as3commons.async.operation.IOperation;
	import org.as3commons.async.task.IResetable;
	import org.as3commons.async.task.ITask;
	import org.as3commons.async.task.ITaskFlowControl;
	import org.as3commons.async.task.event.TaskFlowControlEvent;
	import org.as3commons.logging.ILogger;

	/**
	 * @author Roland Zwaga
	 */
	public class TaskCommand extends CompositeCommand implements IResetable {

		private static const LOGGER:ILogger = org.as3commons.logging.getClassLogger(TaskCommand);

		private var _stopped:Boolean = false;
		private var _finishedCommands:Array;

		/**
		 * Creates a new <code>TaskCommand</code> instance.
		 * @param kind
		 */
		public function TaskCommand(kind:CompositeCommandKind = null) {
			super(kind);
		}

		public function reset():void {
			for each (var cmd:ICommand in _finishedCommands) {
				if (cmd is IResetable) {
					IResetable(cmd).reset();
				} else if (cmd is ITask) {
					ITask(cmd).reset(true);
				}
			}
			_finishedCommands ||= [];
			setCommands(_finishedCommands.concat(commands));
			_finishedCommands = [];
		}

		override public function execute():* {
			_finishedCommands = [];
			_stopped = false;
			return super.execute();
		}

		override protected function executeNextCommand():void {
			var nextCommand:ICommand = commands.shift() as ICommand;
			if (nextCommand != null) {
				_finishedCommands[_finishedCommands.length] = nextCommand;
			}

			LOGGER.debug("Executing next command '{0}'. Remaining number of commands: '{1}'", nextCommand, commands.length);

			if (nextCommand) {
				executeCommand(nextCommand);
			} else {
				LOGGER.debug("All commands in '{0}' have been executed. Dispatching 'complete' event.", this);
				dispatchCompleteEvent();
			}

		}

		/**
		 * @inheritDoc
		 */
		override protected function addCommandListeners(asyncCommand:IOperation):void {
			var flowControl:ITaskFlowControl = asyncCommand as ITaskFlowControl;
			if (flowControl != null) {
				flowControl.addEventListener(TaskFlowControlEvent.BREAK, flowControlEvent_handler);
				flowControl.addEventListener(TaskFlowControlEvent.CONTINUE, flowControlEvent_handler);
				flowControl.addEventListener(TaskFlowControlEvent.EXIT, flowControlEvent_handler);
			}
			super.addCommandListeners(asyncCommand);
		}

		/**
		 * @inheritDoc
		 */
		override protected function removeCommandListeners(asyncCommand:IOperation):void {
			var flowControl:ITaskFlowControl = asyncCommand as ITaskFlowControl;
			if (flowControl != null) {
				flowControl.removeEventListener(TaskFlowControlEvent.BREAK, flowControlEvent_handler);
				flowControl.removeEventListener(TaskFlowControlEvent.CONTINUE, flowControlEvent_handler);
				flowControl.removeEventListener(TaskFlowControlEvent.EXIT, flowControlEvent_handler);
			}
			super.removeCommandListeners(asyncCommand);
		}

		protected function flowControlEvent_handler(event:TaskFlowControlEvent):void {
			_stopped = true;
			dispatchEvent(event.clone());
		}

	}
}
