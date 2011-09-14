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
package org.as3commons.rpc.utils {
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * Queues loader.load(request, context) sequentially and advances on the
	 * next frame. This takes longer to load, but yields better performance
	 * (maintaining framerate) for a large number of loader instances.
	 *
	 * @author Jan Van Coppenolle
	 */
	public function queueURLLoader(loader:URLLoader, request:URLRequest):void {
		new QueuedURLLoader(loader, request);
	}
}

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;

import org.as3commons.rpc.utils.deferExec;

internal class QueuedURLLoader {
	public static const QUEUE:Array = [];

	public static function load(queuedLoader:QueuedURLLoader):void {
		deferExec(queuedLoader.loader.load, queuedLoader.request);
		addHandlers(queuedLoader.loader);
	}

	private static function addHandlers(target:URLLoader):void {
		target.addEventListener(Event.COMPLETE, loadHandler);
		target.addEventListener(IOErrorEvent.IO_ERROR, loadHandler);
		target.addEventListener(Event.CLOSE, closeHandler);
	}

	private static function closeHandler(event:Event):void {
		loadHandler(event);
	}

	private static function loadHandler(event:Event):void {
		removeHandlers(URLLoader(event.target));

		QUEUE.shift();

		if (QUEUE.length != 0)
			load(QUEUE[0] as QueuedURLLoader);
	}

	private static function removeHandlers(target:URLLoader):void {
		target.removeEventListener(Event.COMPLETE, loadHandler);
		target.removeEventListener(IOErrorEvent.IO_ERROR, loadHandler);
		target.removeEventListener(Event.CLOSE, closeHandler);
	}

	////////////////////////////////////////////////////////////////////////////
	
	public function QueuedURLLoader(loader:URLLoader, request:URLRequest) {
		this.loader = loader;
		this.request = request;

		QUEUE.push(this);

		if (QUEUE.length == 1) {
			load(this);
		}
	}

	////////////////////////////////////////////////////////////////////////////

	public var loader:URLLoader;
	public var request:URLRequest;
}
