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

	import org.as3commons.async.command.ICommand;
	import org.as3commons.async.operation.IOperation;
	import org.as3commons.async.operation.OperationEvent;
	import org.as3commons.async.task.IConditionProvider;
	import org.as3commons.async.task.IWhileBlock;
	import org.as3commons.lang.Assert;

	/**
	 * @inheritDoc
	 */
	public class WhileBlock extends AbstractTaskBlock implements IWhileBlock {

		public function WhileBlock(conditionProvider:IConditionProvider) {
			Assert.notNull(conditionProvider, "The conditionProvider argument must not be null");
			super();
			_conditionProvider = conditionProvider;
		}

		private var _conditionProvider:IConditionProvider;

		public function get conditionProvider():IConditionProvider {
			return _conditionProvider;
		}

		public function set conditionProvider(value:IConditionProvider):void {
			_conditionProvider = value;
		}

		override public function execute():* {
			finishedCommandList = [];
			var async:IOperation = _conditionProvider as IOperation;
			if (async != null) {
				addConditionalListeners(async);
				if (_conditionProvider is ICommand) {
					ICommand(_conditionProvider).execute();
				}
			} else {
				executeBlock();
			}
		}

		protected function executeBlock():void {
			var result:Boolean = _conditionProvider.getResult();
			if (result) {
				executeNextCommand();
			} else {
				completeExecution();
			}
		}

		protected function onConditionalResult(event:OperationEvent):void {
			removeConditionalListeners(event.target as IOperation);
			executeBlock();
		}

		protected function onConditionalFault(event:OperationEvent):void {
			removeConditionalListeners(event.target as IOperation);
			dispatchErrorEvent(event.target as ICommand);
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

	}
}