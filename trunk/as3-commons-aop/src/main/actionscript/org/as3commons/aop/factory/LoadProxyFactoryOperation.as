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
package org.as3commons.aop.factory {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.system.ApplicationDomain;

	import org.as3commons.async.operation.impl.AbstractOperation;
	import org.as3commons.bytecode.proxy.IProxyFactory;
	import org.as3commons.lang.Assert;

	/**
	 * Asynchronous operation that loads a proxy factory.
	 *
	 * @author Christophe Herreman
	 */
	public class LoadProxyFactoryOperation extends AbstractOperation {

		private var _proxyFactory:IProxyFactory;
		private var _applicationDomain:ApplicationDomain;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function LoadProxyFactoryOperation(proxyFactory:IProxyFactory, applicationDomain:ApplicationDomain = null) {
			Assert.notNull(proxyFactory);

			_proxyFactory = proxyFactory;
			_applicationDomain = applicationDomain;

			addEventListenersToProxyFactory();
			loadProxyFactory();
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		private function addEventListenersToProxyFactory():void {
			_proxyFactory.addEventListener(Event.COMPLETE, proxyFactory_completeHandler);
			_proxyFactory.addEventListener(IOErrorEvent.VERIFY_ERROR, proxyFactory_verifyErrorHandler);
		}

		private function removeEventListenersFromProxyFactory():void {
			_proxyFactory.removeEventListener(Event.COMPLETE, proxyFactory_completeHandler);
			_proxyFactory.removeEventListener(IOErrorEvent.VERIFY_ERROR, proxyFactory_verifyErrorHandler);
		}

		private function loadProxyFactory():void {
			_proxyFactory.loadProxyClasses(_applicationDomain);
		}

		private function proxyFactory_completeHandler(event:Event):void {
			removeEventListenersFromProxyFactory();
			dispatchCompleteEvent(_proxyFactory);
		}

		private function proxyFactory_verifyErrorHandler(event:IOErrorEvent):void {
			removeEventListenersFromProxyFactory();
			dispatchErrorEvent(event.errorID);
		}
	}
}
