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
package org.as3commons.async.operation.impl {

	import flash.events.TimerEvent;
	import flash.system.ApplicationDomain;
	import flash.system.SecurityDomain;
	import flash.utils.Timer;

	import mx.events.ModuleEvent;
	import mx.modules.IModuleInfo;
	import mx.modules.ModuleManager;

	import org.as3commons.async.operation.AbstractProgressOperation;
	import org.as3commons.lang.Assert;

	/**
	 * Asynchronous operation that loads a Flex module from a specified URL. When the <code>LoadModuleOperation</code> completes the
	 * <code>IModuleInfo</code> instance created by the <code>ModuleManager.getModule()</code> method is returned as the result.
	 * @author Roland Zwaga
	 */
	public class LoadModuleOperation extends AbstractProgressOperation {

		/**
		 * The <code>IModuleInfo</code> instance that is used to listen for <code>ModuleEvent.READY</code>, <code>ModuleEvent.ERROR</code>
		 * and <code>ModuleEvent.PROGRESS</code> events.
		 */
		protected var moduleInfo:IModuleInfo;

		/**
		 * Creates a new <code>LoadModuleOperation</code> instance.
		 * @param moduleURL The specified URL for the Flex module.
		 * @param applicationDomain An optional <code>ApplicationDomain</code> for the loaded Flex module.
		 * @param securityDomain An optional <code>SecurityDomain</code> for the loaded Flex module.
		 */
		public function LoadModuleOperation(moduleURL:String, applicationDomain:ApplicationDomain = null, securityDomain:SecurityDomain = null) {
			Assert.hasText(moduleURL, "The moduleURL argument must not be null or empty");
			super();
			init(moduleURL, applicationDomain, securityDomain);
		}

		/**
		 * Creates a <code>IModuleInfo</code> instance by invoking <code>ModuleManager.getModule()</code> and adds appropriate event handlers.
		 */
		protected function init(moduleURL:String, applicationDomain:ApplicationDomain, securityDomain:SecurityDomain):void {
			moduleInfo = ModuleManager.getModule(moduleURL);
			moduleInfo.addEventListener(ModuleEvent.READY, readyHandler, false, 0, true);
			moduleInfo.addEventListener(ModuleEvent.ERROR, moduleErrorHandler, false, 0, true);
			moduleInfo.addEventListener(ModuleEvent.PROGRESS, progressHandler, false, 0, true);
			var timer:Timer = new Timer(0);
			var timerHandler:Function = function(event:TimerEvent):void {
				timer.removeEventListener(TimerEvent.TIMER, timerHandler);
				timer.stop();
				timer = null;
				moduleInfo.load(applicationDomain, securityDomain);
			}
			timer.addEventListener(TimerEvent.TIMER, timerHandler);
			timer.start();
		}

		/**
		 * Handles the <code>ModuleEvent.READY</code> event.
		 */
		protected function readyHandler(event:ModuleEvent):void {
			removeEventListeners();
			dispatchCompleteEvent(moduleInfo);
		}

		/**
		 * Handles the <code>ModuleEvent.ERROR</code> event.
		 */
		protected function moduleErrorHandler(event:ModuleEvent):void {
			removeEventListeners();
			dispatchErrorEvent(event.errorText);
		}

		/**
		 * Handles the <code>ModuleEvent.PROGRESS</code> event.
		 */
		protected function progressHandler(event:ModuleEvent):void {
			progress = event.bytesLoaded;
			total = event.bytesTotal;
			dispatchProgressEvent();
		}

		/**
		 * Removes the <code>ModuleEvent.READY</code>, <code>ModuleEvent.ERROR</code>
		 * and <code>ModuleEvent.PROGRESS</code> event listeners.
		 */
		protected function removeEventListeners():void {
			if (moduleInfo != null) {
				moduleInfo.removeEventListener(ModuleEvent.READY, readyHandler);
				moduleInfo.removeEventListener(ModuleEvent.ERROR, errorHandler);
				moduleInfo.removeEventListener(ModuleEvent.PROGRESS, progressHandler);
			}

		}

	}
}
