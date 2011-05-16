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
package org.as3commons.async.task.support {
	import flash.events.Event;

	import org.as3commons.async.command.GenericOperationCommand;
	import org.as3commons.async.command.ICommand;
	import org.as3commons.async.operation.AbstractOperation;
	import org.as3commons.async.operation.IOperation;
	import org.as3commons.async.operation.OperationEvent;
	import org.as3commons.async.task.IConditionProvider;
	import org.as3commons.async.task.ICountProvider;
	import org.as3commons.async.task.IForBlock;
	import org.as3commons.async.task.IIfElseBlock;
	import org.as3commons.async.task.ITask;
	import org.as3commons.async.task.IWhileBlock;
	import org.as3commons.async.task.event.TaskEvent;
	import org.as3commons.async.task.event.TaskFlowControlEvent;
	import org.as3commons.lang.Assert;

	/**
	 * @inheritDoc
	 */
	public class IfElseBlock extends AbstractOperation implements IIfElseBlock {

		private var _ifBlock:ITask;
		private var _elseBlock:ITask;
		private var _currentBlock:ITask;

		private var _context:Object;

		/**
		 * @inheritDoc
		 */
		public function get context():Object {
			return _context;
		}

		/**
		 * @private
		 */
		public function set context(value:Object):void {
			_context = value;
		}

		private var _parent:ITask;

		public function get parent():ITask {
			return _parent;
		}

		public function set parent(value:ITask):void {
			_parent = value;
			_ifBlock.parent = value;
		}

		/**
		 * Creates a new <code>IfElseBlock</code> instance.
		 * @param conditionProvider An <code>IConditionProvider</code> instance that determines which block will be executed.
		 */
		public function IfElseBlock(conditionProvider:IConditionProvider) {
			Assert.notNull(conditionProvider, "conditionProvider argument must not be null");
			super();
			_conditionProvider = conditionProvider;
			_ifBlock = new Task();
			_currentBlock = _ifBlock;
		}

		private var _conditionProvider:IConditionProvider;

		public function get conditionProvider():IConditionProvider {
			return _conditionProvider;
		}

		public function set conditionProvider(value:IConditionProvider):void {
			_conditionProvider = value;
		}

		private var _isClosed:Boolean;

		/**
		 * @inheritDoc
		 */
		public function get isClosed():Boolean {
			return _isClosed;
		}

		public function switchToElseBlock():void {
			_elseBlock = new Task();
			_elseBlock.parent = parent;
			_currentBlock = _elseBlock;
		}

		public function execute():* {
			var async:IOperation = _conditionProvider as IOperation;
			if (async != null) {
				addConditionalListeners(async);
				if (_conditionProvider is ICommand) {
					ICommand(_conditionProvider).execute();
				}
			} else {
				executeBlocks();
			}
		}

		protected function executeBlocks():void {
			var result:Boolean = _conditionProvider.getResult();
			if (result) {
				addBlockListeners(_ifBlock);
				_ifBlock.execute();
			} else if ((!result) && (_elseBlock != null)) {
				addBlockListeners(_elseBlock);
				_elseBlock.execute();
			} else {
				dispatchCompleteEvent(null);
			}
		}

		protected function onConditionalResult(event:OperationEvent):void {
			removeConditionalListeners(event.target as IOperation);
			executeBlocks();
		}

		protected function onBlockComplete(event:TaskEvent):void {
			removeBlockListeners(event.target as IOperation);
			dispatchCompleteEvent(null);
		}

		protected function onCommandFault(event:OperationEvent):void {
			removeBlockListeners(event.target as IOperation);
			dispatchErrorEvent(event.target as IOperation);
		}

		protected function onConditionalFault(event:OperationEvent):void {
			removeConditionalListeners(event.target as IOperation);
			dispatchErrorEvent(event.target as IOperation);
		}

		protected function addConditionalListeners(asyncCommand:IOperation):void {
			if (asyncCommand != null) {
				asyncCommand.addCompleteListener(onConditionalResult);
				asyncCommand.addErrorListener(onConditionalFault);
			}
		}

		protected function removeConditionalListeners(asyncCommand:IOperation):void {
			if (asyncCommand != null) {
				asyncCommand.removeCompleteListener(onConditionalResult);
				asyncCommand.removeErrorListener(onConditionalFault);
			}
		}

		protected function addBlockListeners(asyncCommand:IOperation):void {
			if (asyncCommand != null) {
				asyncCommand.addEventListener(TaskEvent.TASK_COMPLETE, onBlockComplete);
				asyncCommand.addEventListener(TaskEvent.BEFORE_EXECUTE_COMMAND, redispatch);
				asyncCommand.addEventListener(TaskEvent.AFTER_EXECUTE_COMMAND, redispatch);
				asyncCommand.addEventListener(TaskFlowControlEvent.BREAK, redispatch);
				asyncCommand.addEventListener(TaskFlowControlEvent.CONTINUE, redispatch);
				asyncCommand.addErrorListener(onCommandFault);
			}
		}

		protected function removeBlockListeners(asyncCommand:IOperation):void {
			if (asyncCommand != null) {
				asyncCommand.removeEventListener(TaskEvent.TASK_COMPLETE, onBlockComplete);
				asyncCommand.removeEventListener(TaskEvent.BEFORE_EXECUTE_COMMAND, redispatch);
				asyncCommand.removeEventListener(TaskEvent.AFTER_EXECUTE_COMMAND, redispatch);
				asyncCommand.removeEventListener(TaskFlowControlEvent.BREAK, redispatch);
				asyncCommand.removeEventListener(TaskFlowControlEvent.CONTINUE, redispatch);
				asyncCommand.removeErrorListener(onCommandFault);
			}
		}

		protected function redispatch(event:Event):void {
			dispatchEvent(event.clone());
		}

		public function reset(doHardReset:Boolean = false):ITask {
			if (!isClosed) {
				_currentBlock.reset(doHardReset);
			}
			return this;
		}

		public function next(item:Object, ... constructorArgs):ITask {
			if (!isClosed) {
				var command:ICommand = (item is ICommand) ? ICommand(item) : new GenericOperationCommand(Class(item), constructorArgs);
				_currentBlock.next(command);
			}
			return this;
		}

		public function and(item:Object, ... constructorArgs):ITask {
			if (!isClosed) {
				var command:ICommand = (item is ICommand) ? ICommand(item) : new GenericOperationCommand(Class(item), constructorArgs);
				_currentBlock.and(command);
			}
			return this;
		}

		public function if_(condition:IConditionProvider = null, ifElseBlock:IIfElseBlock = null):IIfElseBlock {
			if (!isClosed) {
				_currentBlock.if_(condition, ifElseBlock);
			}
			return this;
		}

		public function else_():IIfElseBlock {
			if (!isClosed) {
				switchToElseBlock();
			}
			return this;
		}

		public function while_(condition:IConditionProvider = null, whileBlock:IWhileBlock = null):IWhileBlock {
			if (!isClosed) {
				return _currentBlock.while_(condition, whileBlock);
			}
			return null;
		}

		public function for_(count:uint, countProvider:ICountProvider = null, forBlock:IForBlock = null):IForBlock {
			if (!isClosed) {
				return _currentBlock.for_(count, countProvider, forBlock);
			}
			return null;
		}

		public function end():ITask {
			_isClosed = true;
			return (this.parent != null) ? this.parent : this;
		}

		public function exit():ITask {
			if (!isClosed) {
				_currentBlock.exit();
			}
			return this;
		}

		public function pause(duration:uint, pauseCommand:ICommand = null):ITask {
			if (!isClosed) {
				return _currentBlock.pause(duration, pauseCommand);
			}
			return this;
		}

		public function break_():ITask {
			return this;
		}

		public function continue_():ITask {
			return this;
		}

	}
}