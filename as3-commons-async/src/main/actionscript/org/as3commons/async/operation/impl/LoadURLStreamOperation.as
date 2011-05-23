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

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.setTimeout;

	import org.as3commons.async.operation.AbstractProgressOperation;
	import org.as3commons.lang.Assert;

	/**
	 * An <code>IOperation</code> implementation that can load a stream from the specified URL.
	 * @author Roland Zwaga
	 */
	public class LoadURLStreamOperation extends AbstractProgressOperation {

		private var _urlStream:URLStream;

		public function get urlStream():URLStream {
			return _urlStream;
		}

		/**
		 * Creates a new <code>LoadURLStreamOperation</code> instance.
		 * @param url The specified URL where the stream will be laoded from.
		 */
		public function LoadURLStreamOperation(url:String) {
			Assert.hasText(url, "url argument must not be null or empty");
			super();
			init(url);
		}

		/**
		 * Initializes the current <code>LoadURLStreamOperation</code> with the specified URL.
		 * @param url The specified URL.
		 */
		protected function init(url:String):void {
			_urlStream = new URLStream();
			_urlStream.addEventListener(Event.COMPLETE, urlStreamCompleteHandler, false, 0, true);
			_urlStream.addEventListener(ProgressEvent.PROGRESS, progressHandler, false, 0, true);
			_urlStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, urlStreamErrorHandler, false, 0, true);
			_urlStream.addEventListener(IOErrorEvent.IO_ERROR, urlStreamErrorHandler, false, 0, true);

			setTimeout(function():void {
				_urlStream.load(new URLRequest(url));
			}, 0);
		}

		protected function urlStreamCompleteHandler(event:Event):void {
			removeEventListeners();
			dispatchCompleteEvent();
		}

		/**
		 * Handles the <code>ProgressEvent.PROGRESS</code> event of the internally created <code>URLStream</code>.
		 * @param event The specified <code>ProgressEvent.PROGRESS</code> event.
		 */
		protected function progressHandler(event:ProgressEvent):void {
			progress = event.bytesLoaded;
			total = event.bytesTotal;
			dispatchProgressEvent();
		}

		/**
		 * Handles the <code>SecurityErrorEvent.SECURITY_ERROR</code> and <code>IOErrorEvent.IO_ERROR</code> events of the internally created <code>URLStream</code>.
		 * @param event The specified <code>ProgressEvent.PROGRESS</code> or <code>IOErrorEvent.IO_ERROR</code> event.
		 */
		protected function urlStreamErrorHandler(event:Event):void {
			removeEventListeners();
			dispatchErrorEvent(event['text']);
		}

		/**
		 * Removes all the registered event handlers from the internally created <code>URLStream</code> and
		 * sets it to <code>null</code> afterwards.
		 */
		protected function removeEventListeners():void {
			if (_urlStream != null) {
				_urlStream.removeEventListener(Event.COMPLETE, completeHandler);
				_urlStream.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
				_urlStream.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
				_urlStream.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				_urlStream = null;
			}
		}

	}
}
