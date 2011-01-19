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
package org.as3commons.eventbus.impl {
	import flash.errors.IllegalOperationError;

	import org.as3commons.eventbus.IEventBus;
	import org.as3commons.eventbus.IEventListenerInterceptor;
	import org.as3commons.reflect.MethodInvoker;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public class AbstractEventListenerInterceptor extends AbstractEventBusAwareObject implements IEventListenerInterceptor {

		private var _blockListener:Boolean;

		/**
		 * Creates a new <code>AbstractEventListenerInterceptor</code> instance.
		 */
		public function AbstractEventListenerInterceptor() {
			super();
		}

		/**
		 * @inheritDoc
		 */
		public function get blockListener():Boolean {
			return _blockListener;
		}

		/**
		 * @private
		 */
		public function set blockListener(value:Boolean):void {
			_blockListener = value;
		}

		/**
		 * @inheritDoc
		 */
		public function interceptListener(listener:Function):void {
			throw new IllegalOperationError("interceptListener() not implemented in abstract base class");
		}

		/**
		 * @inheritDoc
		 */
		public function interceptListenerProxy(proxy:MethodInvoker):void {
			throw new IllegalOperationError("interceptListenerProxy() not implemented in abstract base class");
		}

	}
}