package org.as3commons.logging.setup.target {
	import flexunit.framework.TestCase;

	import flash.events.Event;
	/**
	 * @author mh
	 */
	public class HttpTargetTest extends TestCase {
		private var _target : BasicTarget;
		
		public function testIt() : void {
			_target = new BasicTarget("a uri");
			_target.pushInterval = 0.5;
			_target.dispatcher.addEventListener( Event.INIT, addAsync(checkSending,1000) );
			_target.log("test.debug.Debug", "Debug", 1, 1234, "Hello World", [], "");
		}
		
		private function checkSending(e:*) : void {
			var loader: TestURLLoader = _target.loaders[0];
			trace("hi");
		}
	}
}
import flash.utils.setTimeout;
import org.as3commons.logging.setup.target.HttpTarget;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;

class BasicTarget extends HttpTarget {
	
	public const dispatcher: EventDispatcher = new EventDispatcher();
	private var _loaders : Array;
	
	public function BasicTarget(uri:String) {
		super(uri);
		_loaders = [];
		createLoader();
		createLoader();
		createLoader();
		createLoader();
	}
	
	public function get loaders(): Array {
		return _loaders;
	}
	
	private function createLoader() : TestURLLoader {
		var loader:TestURLLoader = new TestURLLoader();
		loader.addEventListener(Event.COMPLETE, onPushComplete, false, 0, true);
		loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onPushHttpStatus, false, 0, true);
		loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onPushSecurityError, false, 0, true);
		loader.addEventListener(IOErrorEvent.IO_ERROR, onPushIoError, false, 0, true);
		_loaderPool.unshift(loader);
		_loaders.push(loader);
		return loader;
	}
	
	override protected function doRequest(loader : URLLoader, statements : Array) : Array {
		var result: Array = super.doRequest(loader, statements);
		setTimeout( function():void{ dispatcher.dispatchEvent( new Event(Event.INIT) ); }, 10 ); 
		return result;
	}

	override protected function onPushComplete(event : Event) : void {
		super.onPushComplete(event);
		dispatcher.dispatchEvent( new Event(Event.COMPLETE));
	}
	
	override protected function onPushHttpStatus(event : HTTPStatusEvent) : void {
		super.onPushHttpStatus(event);
		dispatcher.dispatchEvent( new HTTPStatusEvent(HTTPStatusEvent.HTTP_STATUS,false, false,event.status));
	}
	
	override protected function onPushIoError(event : IOErrorEvent) : void {
		super.onPushIoError(event);
	}
}

class TestURLLoader extends URLLoader {
	private var _request: URLRequest;
	
	override public function load(request: URLRequest): void {
		_request = request;
	}
	
	public function get request(): URLRequest {
		return _request;
	}
}