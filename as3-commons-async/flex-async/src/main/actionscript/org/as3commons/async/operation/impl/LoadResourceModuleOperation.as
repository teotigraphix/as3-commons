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

	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.system.ApplicationDomain;
	import flash.system.SecurityDomain;
	import flash.utils.Timer;

	import mx.events.ResourceEvent;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;

	import org.as3commons.async.operation.AbstractProgressOperation;
	import org.as3commons.lang.Assert;

	/**
	 * An <code>IOperation</code> implementation that loads a resource module from a specified URL.
	 * @author Roland Zwaga
	 */
	public class LoadResourceModuleOperation extends AbstractProgressOperation {

		/**
		 * The <code>IEventDispatcher</code> returned from the <code>loadResourceModule()</code> call
		 * and that is used to listen for <code>ResourceEvent.COMPLETE</code>, <code>ResourceEvent.ERROR</code>
		 * and <code>ResourceEvent.PROGRESS</code> events.
		 */
		protected var eventDispatcher:IEventDispatcher;

		protected var resourceManager:IResourceManager = ResourceManager.getInstance();

		/**
		 * The specified URL for the resource module.
		 */
		protected var resourceModuleURL:String;

		/**
		 * Creates a new <code>LoadResourceModuleOperation</code> instance.
		 * @param resourceModuleURL The specified URL for the resource module.
		 * @param update
		 * @param applicationDomain
		 * @param securityDomain
		 */
		public function LoadResourceModuleOperation(resourceModuleURL:String, update:Boolean = true, applicationDomain:ApplicationDomain = null, securityDomain:SecurityDomain = null) {
			Assert.hasText(resourceModuleURL, "The resourceModuleURL argument must not be null or empty");
			super();
			init(resourceModuleURL, update, applicationDomain, securityDomain);
		}

		protected function init(resourceModuleURL:String, update:Boolean, applicationDomain:ApplicationDomain, securityDomain:SecurityDomain):void {
			this.resourceModuleURL = resourceModuleURL;
			var timer:Timer = new Timer(1);
			var timerHandler:Function = function(event:TimerEvent):void {
				timer.removeEventListener(TimerEvent.TIMER, timerHandler);
				timer.stop();
				timer = null;
				eventDispatcher = resourceManager.loadResourceModule(resourceModuleURL, update, applicationDomain, securityDomain);
				eventDispatcher.addEventListener(ResourceEvent.COMPLETE, resourceModuleCompleteHandler);
				eventDispatcher.addEventListener(ResourceEvent.ERROR, resourceModuleErrorHandler);
				eventDispatcher.addEventListener(ResourceEvent.PROGRESS, progressHandler);
			}
			timer.addEventListener(TimerEvent.TIMER, timerHandler);
			timer.start();
		}

		/**
		 * Handles the <code>ResourceEvent.COMPLETE</code> event.
		 */
		protected function resourceModuleCompleteHandler(event:ResourceEvent):void {
			removeEventListeners();
			dispatchCompleteEvent(resourceModuleURL);
		}

		/**
		 * Handles the <code>ResourceEvent.ERROR</code> event.
		 */
		protected function resourceModuleErrorHandler(event:ResourceEvent):void {
			removeEventListeners();
			dispatchErrorEvent(event.errorText);
		}

		/**
		 * Handles the <code>ResourceEvent.PROGRESS</code> event.
		 */
		protected function progressHandler(event:ResourceEvent):void {
			progress = event.bytesLoaded;
			total = event.bytesTotal;
			dispatchProgressEvent();
		}

		/**
		 * Removes the <code>ResourceEvent.COMPLETE</code>, <code>ResourceEvent.ERROR</code>
		 * and <code>ResourceEvent.PROGRESS</code> event listeners and sets the internally
		 * created <code>IEventDIspatcher</code> to <code>null</code>.
		 */
		protected function removeEventListeners():void {
			if (eventDispatcher != null) {
				eventDispatcher.removeEventListener(ResourceEvent.COMPLETE, completeHandler);
				eventDispatcher.removeEventListener(ResourceEvent.ERROR, errorHandler);
				eventDispatcher.removeEventListener(ResourceEvent.PROGRESS, progressHandler);
				eventDispatcher = null;
			}

		}

	}
}
