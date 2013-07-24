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
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	import org.as3commons.lang.Assert;

	/**
	 * An <code>IOperation</code> implementation that can load arbitrary data from a specified URL.
	 * @author Roland Zwaga
	 */
	public class LoadURLOperation extends AbstractProgressOperation {

		/**
		 * Creates a new <code>LoadURLOperation</code> instance.
		 * @param url The specified URL from which the data will be loaded.
		 * @param dataFormat Optional argument that specifies the data format of the expected data. Use the <code>flash.net.URLLoaderDataFormat</code> enumeration for this.
		 * @see flash.net.URLLoaderDataFormat
		 */
		public function LoadURLOperation(url:String="", dataFormat:String=null, request:URLRequest=null) {
			super();
			dataFormat ||= URLLoaderDataFormat.TEXT;
			timeOutToken = setTimeout(createLoader, 1, url, dataFormat, request);
		}

		protected var timeOutToken:uint;

		/**
		 * Internal <code>URLLoader</code> instance that is used to do the actual loading of the data.
		 */
		protected var urlLoader:URLLoader;

		private var _url:String;

		public function get url():String {
			return _url;
		}

		protected function createLoader(url:String, dataFormat:String, request:URLRequest):void {
			_url = url;
			
			clearTimeout(timeOutToken);
			
			urlLoader = new URLLoader();
			urlLoader.dataFormat = dataFormat;
			urlLoader.addEventListener(Event.COMPLETE, urlLoaderCompleteHandler);
			urlLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, urlLoaderErrorHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, urlLoaderErrorHandler);
			var request:URLRequest = (request == null) ? new URLRequest(url) : request;
			urlLoader.load(request);
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
			if (urlLoader != null) {
				urlLoader.removeEventListener(Event.COMPLETE, completeHandler);
				urlLoader.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
				urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
				urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				urlLoader = null;
			}
		}

		/**
		 * Handles the <code>Event.COMPLETE</code> event of the internally created <code>URLLoader</code>.
		 * @param event The specified <code>Event.COMPLETE</code> event.
		 */
		protected function urlLoaderCompleteHandler(event:Event):void {
			result = urlLoader.data;
			removeEventListeners();
			dispatchCompleteEvent();
		}

		/**
		 * Handles the <code>SecurityErrorEvent.SECURITY_ERROR</code> and <code>IOErrorEvent.IO_ERROR</code> events of the internally created <code>URLLoader</code>.
		 * @param event The specified <code>SecurityErrorEvent.SECURITY_ERROR</code> or <code>IOErrorEvent.IO_ERROR</code> event.
		 */
		protected function urlLoaderErrorHandler(event:ErrorEvent):void {
			removeEventListeners();
			dispatchErrorEvent(event.text);
		}

		public override function toString():String {
			return "[LoadURLOperation(url:'" + _url + "')]";
		}

	}
}
