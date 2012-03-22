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
package org.as3commons.async.command.impl {

	import flash.system.ApplicationDomain;

	import org.as3commons.async.command.IAsyncCommand;
	import org.as3commons.async.operation.IOperation;
	import org.as3commons.async.operation.IProgressOperation;
	import org.as3commons.async.operation.event.OperationEvent;
	import org.as3commons.async.operation.impl.AbstractProgressOperation;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.IApplicationDomainAware;
	import org.as3commons.lang.IllegalArgumentError;

	/**
	 * Generic <code>ICommand</code> implementation that can be used to wrap arbitrary <code>IOperation</code> or <code>IProgressOperation</code>
	 * implementations. This way immediate execution of the <code>IOperation</code> can be defered to an instance
	 * of this class.
	 * @see org.as3commons.async.operation.IOperation IOperation
	 * @see org.as3commons.async.operation.IProgressOperation IProgressOperation
	 * @author Roland Zwaga
	 */
	public class GenericOperationCommand extends AbstractProgressOperation implements IAsyncCommand, IApplicationDomainAware {

		private var _operation:IOperation;

		private var _operationClass:Class;

		/**
		 * The specified <code>IOperation</code> implementation that will be created when the current <code>GenericOperationCommand</code> is executed.
		 */
		public function get operationClass():Class {
			return _operationClass;
		}

		private var _applicationDomain:ApplicationDomain;

		/**
		 * @private
		 */
		public function set applicationDomain(value:ApplicationDomain):void {
			_applicationDomain = value;
		}

		private var _constructorArguments:Array;

		/**
		 * An array of arguments that will be passed to the constructor of the specified <code>IOperation</code> implementation.
		 */
		public function get constructorArguments():Array {
			return _constructorArguments;
		}

		/**
		 * @private
		 */
		public function set constructorArguments(value:Array):void {
			_constructorArguments = value;
		}

		/**
		 * Creates a new <code>GenericOperationCommand</code> instance.
		 * @param operationClass The specified <code>IOperation</code> implementation that will be created.
		 * @param constructorArgs An array of arguments that will be passed to the constructor of the specified <code>IOperation</code> implementation.
		 */
		public function GenericOperationCommand(operationClass:Class, ... constructorArgs) {
			super();
			initGenericOperationCommand(operationClass, constructorArgs);
		}

		protected function initGenericOperationCommand(operationClass:Class, constructorArgs:Array=null):void {
			Assert.notNull(operationClass, "operationClass argument must not be null");
			if (!ClassUtils.isImplementationOf(operationClass, IOperation, _applicationDomain)) {
				throw new IllegalArgumentError("operationClass argument must be an implementation of IOperation");
			}
			_operationClass = operationClass;
			_constructorArguments = constructorArgs;
		}

		/**
		 * Creates an instance of the specified <code>IOperation</code> with the specified constructor arguments.
		 * Adds a complete and error event listener to redispatch the <code>IOperation</code> events through the
		 * current <code>GenericOperationCommand</code>.
		 */
		public function execute():* {
			_operation = ClassUtils.newInstance(_operationClass, _constructorArguments);
			_operation.addCompleteListener(operationComplete);
			_operation.addErrorListener(operationError);
			if (_operation is IProgressOperation) {
				IProgressOperation(_operation).addProgressListener(operationProgress);
			}
		}

		/**
		 * Event handler for the specified <code>IOperation</code>'s <code>OperationEvent.COMPLETE</code> event.
		 */
		protected function operationComplete(event:OperationEvent):void {
			removeListeners();
			dispatchCompleteEvent(event.operation.result);
		}

		/**
		 * Event handler for the specified <code>IOperation</code>'s <code>OperationEvent.ERROR</code> event.
		 */
		protected function operationError(event:OperationEvent):void {
			removeListeners();
			dispatchErrorEvent(event.operation.error);
		}

		/**
		 * Event handler for the specified <code>IProgressOperation</code>'s <code>OperationEvent.PROGRESS</code> event.
		 */
		protected function operationProgress(event:OperationEvent):void {
			progress = IProgressOperation(event.operation).progress;
			total = IProgressOperation(event.operation).total;
			dispatchProgressEvent();
		}

		/**
		 * Removes the complete and error listeners from the <code>IOperation</code>'s instance.
		 */
		protected function removeListeners():void {
			if (_operation != null) {
				_operation.removeCompleteListener(operationComplete);
				_operation.removeErrorListener(operationError);
				if (_operation is IProgressOperation) {
					(_operation as IProgressOperation).removeProgressListener(operationProgress);
				}
			}
		}

		/**
		 * Static factory method to create a new <code>GenericOperationCommand</code> instance.
		 * @param clazz The specified <code>Class</code> (must be an <code>IOperation</code> implementation).
		 * @param constructorArgs An optional <code>Array</code> of constructor arguments for the specified <code>Class</code>.
		 * @return A new <code>GenericOperationCommand</code> instance.
		 */
		public static function createNew(clazz:Class, constructorArgs:Array=null):GenericOperationCommand {
			var goc:GenericOperationCommand = new GenericOperationCommand(clazz);
			if (constructorArgs != null) {
				goc.constructorArguments = constructorArgs;
			}
			return goc;
		}

	}
}
