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
	import org.as3commons.async.command.ICommand;
	import org.as3commons.async.operation.IOperation;
	import org.as3commons.async.operation.OperationEvent;
	import org.as3commons.async.task.ICountProvider;
	import org.as3commons.async.task.IForBlock;
	import org.as3commons.async.task.ITaskFlowControl;
	import org.as3commons.async.task.event.TaskEvent;
	import org.as3commons.async.task.event.TaskFlowControlEvent;
	import org.as3commons.lang.Assert;

	/**
	 * @inheritDoc
	 */
	public class ForBlock extends AbstractTaskBlock implements IForBlock {

		/**
		 * Creates a new <code>ForBlock</code> instance.
		 * @param countProvider an <code>ICountProvider</code> that will determine whether the current <code>ForBlock</code>'s logic will be executed or not.
		 */
		public function ForBlock(countProvider:ICountProvider) {
			Assert.notNull(countProvider, "countProvider argument must not be null");
			super(this);
			_countProvider = countProvider;
		}

		private var _countProvider:ICountProvider;

		public function get countProvider():ICountProvider {
			return _countProvider;
		}

		public function set countProvider(value:ICountProvider):void {
			_countProvider = value;
		}

		override public function execute():* {
			finishedCommandList = new Vector.<ICommand>();
			var async:IOperation = _countProvider as IOperation;
			if (async != null) {
				if (async.result == null) {
					addCountListeners(async);
				}
				if (_countProvider is ICommand) {
					ICommand(_countProvider).execute();
				} else {
					startExecution();
				}
			} else {
				startExecution();
			}
		}

		protected function startExecution():void {
			_count = _countProvider.getCount();
			executeBlock();
		}

		private var _count:uint;

		protected function executeBlock():void {
			if (_count > 0) {
				finishedCommandList = new Vector.<ICommand>();
				executeNextCommand();
			} else {
				completeExecution();
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

		override protected function restartExecution():void {
			resetCommandList();
			_count--;
			executeBlock();
		}

		protected function onCountResult(event:OperationEvent):void {
			removeCountListeners(event.target as IOperation);
			startExecution();
		}

		protected function onCountFault(event:OperationEvent):void {
			removeCountListeners(event.target as IOperation);
			dispatchErrorEvent(event.target as IOperation);
		}

		protected function addCountListeners(asyncCommand:IOperation):void {
			if (asyncCommand != null) {
				asyncCommand.addCompleteListener(onCountResult);
				asyncCommand.addErrorListener(onCountFault);
			}
		}

		protected function removeCountListeners(asyncCommand:IOperation):void {
			if (asyncCommand != null) {
				asyncCommand.removeCompleteListener(onCountResult);
				asyncCommand.removeErrorListener(onCountFault);
			}
		}

		override protected function TaskFlowControlEvent_handler(event:TaskFlowControlEvent):void {
			switch (event.type) {
				case TaskFlowControlEvent.BREAK:
					resetCommandList();
					completeExecution();
					break;
				case TaskFlowControlEvent.CONTINUE:
					restartExecution();
					break;
				case TaskFlowControlEvent.EXIT:
					exitExecution();
					break;
				default:
					break;
			}
		}

	}
}
