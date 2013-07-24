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
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import org.as3commons.lang.Assert;
	
	/**
	 * An <code>IOperation</code> implementation that can load SWF's and images from a specified URL.
	 * @author Roland Zwaga
	 */
	public class LoaderOperation extends AbstractProgressOperation {
		
		/**
		 * Creates a new <code>LoaderOperation</code> instance.
		 * @param url The specified URL from which the data will be loaded.
		 */
		public function LoaderOperation(url:String="", request:URLRequest=null) {
			super();
			timeOutToken = setTimeout(createLoader, 1, url, request);
		}
		
		protected var timeOutToken:uint;
		
		/**
		 * Internal <code>URLLoader</code> instance that is used to do the actual loading of the data.
		 */
		protected var loader:Loader;
		
		private var _url:String;
		
		public function get url():String {
			return _url;
		}
		
		protected function createLoader(url:String, request:URLRequest):void {
			_url = url;
			
			clearTimeout(timeOutToken);
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderErrorHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler);
			request ||= new URLRequest(url);
			loader.load(request);
		}
		
		/**
		 * Handles the <code>ProgressEvent.PROGRESS</code> event of the internally created <code>URLLoader</code>.
		 * @param event The specified <code>ProgressEvent.PROGRESS</code> event.
		 */
		protected function progressHandler(event:ProgressEvent):void {
			progress = event.bytesLoaded;
			total = event.bytesTotal;
			dispatchProgressEvent();
		}
		
		/**
		 * Removes all the registered event handlers from the internally created <code>URLLoader</code> and
		 * sets it to <code>null</code> afterwards.
		 */
		protected function removeEventListeners():void {
			if (loader != null) {
				loader.removeEventListener(Event.COMPLETE, completeHandler);
				loader.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
				loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
				loader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				loader = null;
			}
		}
		
		/**
		 * Handles the <code>Event.COMPLETE</code> event of the internally created <code>URLLoader</code>.
		 * @param event The specified <code>Event.COMPLETE</code> event.
		 */
		protected function loaderCompleteHandler(event:Event):void {
			result = loader.content;
			removeEventListeners();
			dispatchCompleteEvent();
		}
		
		/**
		 * Handles the <code>SecurityErrorEvent.SECURITY_ERROR</code> and <code>IOErrorEvent.IO_ERROR</code> events of the internally created <code>URLLoader</code>.
		 * @param event The specified <code>SecurityErrorEvent.SECURITY_ERROR</code> or <code>IOErrorEvent.IO_ERROR</code> event.
		 */
		protected function loaderErrorHandler(event:ErrorEvent):void {
			removeEventListeners();
			dispatchErrorEvent(event.text);
		}
		
		public override function toString():String {
			return "[LoaderOperation(url:'" + _url + "')]";
		}
		
	}
}
