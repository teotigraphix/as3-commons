/*
 * Copyright (c) 2008-2009 the original author or authors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package org.as3commons.logging.setup.target {
	
	import org.as3commons.logging.util.jsonXify;
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.getLogger;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * <code>HttpTarget</code> sends out requests to a server.
	 * 
	 * <p></p>
	 * 
	 * @author Günter Dressel
	 * @author Martin Heidegger
	 * @since 2.1
	 */
	public class HttpTarget implements IAsyncLogTarget {
		
		/** Default interval used to wait between requests. */
		public static const DEFAULT_INTERVAL:uint = 15;
		
		/** Default depth used to introspect variables for storing them over time. */
		public static const DEFAULT_DEPTH:uint = 5;
		
		/** Default amount of tries used for requests. */
		public static const DEFAULT_MAX_TRIES:uint = 3;
		
		// Logger used to help with some problems.
		private static const logger:ILogger = getLogger(HttpTarget);
		
		// Flag used to mark the timeout as not active
		private static const IS_RESET:int = -1;
		
		/** Unused Loaders for further use */
		protected const _loaderPool:Array /* URLLoader */ = [];
		
		/** Marked <code>true</code> if the loader is broken */
		protected var _broken:Boolean = false;
		
		/** URL used to send out requests */
		protected var _url:String;
		
		// LogStatements handled by the loader currently
		private const _loaders:Dictionary /* URLLoader -> [LogStatement] */ = new Dictionary(true);
		
		// Retries for each logger
		private const _retries:Dictionary /* URLLoader -> int */= new Dictionary(true);
		
		// Buffer of logstatements to be sent
		private const _buffer:Array = [];
		
		// setTimeout identifier for the next statement.t
		private var _nextPushTimeout:int = IS_RESET;
		
		// Depth used for introspection.
		private var _introspectDepth:uint;
		
		// Interval in ms used for waiting until the next request.
		private var _pushInterval:uint;
		
		// Amount of tries per requests.
		private var _maxTries:uint;
		
		/**
		 * 
		 * @param url
		 * @param interval
		 * @param introspectDepth
		 * @param maxTries
		 */
		public function HttpTarget(url:String, introspectDepth:uint=DEFAULT_DEPTH,
									maxTries:uint=DEFAULT_MAX_TRIES,
									interval:uint=DEFAULT_INTERVAL) {
			_url = url;
			_maxTries = maxTries;
			_introspectDepth = introspectDepth;
			_pushInterval = interval*1000.0;
		}
		
		public function set maxTries(maxTries:Number):void {
			_maxTries = maxTries;
		}
		
		/**
		 * Interval in which log statements get pushed to server.
		 * 
		 * @param interval connection interval in seconds (default: 15)
		 */
		public function set pushInterval(interval:Number):void {
			interval = interval*1000.0;
			if (_pushInterval != interval) {
				_pushInterval = interval;
				
				if(_nextPushTimeout != IS_RESET) {
					clearTimeout(_nextPushTimeout);
					_nextPushTimeout = setTimeout(pushStatements, _pushInterval);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function set introspectDepth(depth:uint):void {
			_introspectDepth=depth;
		}
		
		/**
		 * @inheritDoc
		 */
		public function log(name:String, shortName:String, level:int,
							timeStamp:Number, message:*, parameters:Array,
							person:String):void {
			
			if(name!=logger.name && !_broken) {
				_buffer.push(new LogStatement(name, shortName, level, timeStamp,
									message, parameters, person, _introspectDepth) );
				
				if(_nextPushTimeout == IS_RESET) {
					_nextPushTimeout = setTimeout(pushStatements, _pushInterval);
				}
			}
		}
		
		/**
		 * 
		 */
		protected function doRequest(loader:URLLoader,statements:Array):Array {
			var processed:Array = [];
			var l:int = statements.length;
			var i:int = 0;
			while(i < l) {
				processed[i] = statements.shift();
				++i;
			}
			
			var variables:URLVariables = new URLVariables();
			variables["log"] = jsonXify(processed,5);
			
			var request:URLRequest = new URLRequest(_url);
			request.method = URLRequestMethod.POST;
			request.data = variables;
			
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.load(request);
			
			if(logger.debugEnabled) {
				logger.debug("Sending POST request with {0} statements to {1}", processed.length, _url);
			}
			
			return processed;
		}
		
		/**
		 * Triggered on complete of the request.
		 * 
		 * <p>Loader will be returned to the pool.</p>
		 * 
		 * @param event Event sent by <code>URLLoader</code>.
		 */
		protected function onPushComplete(event:Event) : void {
			// clear the loader in the dicionary;
			logger.debug("Request to servers passed properly.");
			delete _loaders[event.target];
			_loaderPool.push(event.target);
		}
		
		/**
		 * Triggered on Http status while sending the log statements.
		 * 
		 * <p>Will try to send the request again if the status was not within the 200 range.</p>
		 * 
		 * @param event Event sent by <code>URLLoader</code>.
		 */
		protected function onPushHttpStatus( event:HTTPStatusEvent ) : void {
			// In case it offers a "non-accept" status code (like 404 or 301 take it as error
			// else: ignore
			if(event.status < 200 || event.status >= 300) {
				tryAgain(event.target, "HTTP status error " + event.status);
			}
		}
		
		/**
		 * Triggered on Security error while sending the log statements.
		 * 
		 * <p>Will mark the target as broken.</p>
		 * 
		 * @param event Event sent by <code>URLLoader</code>.
		 */
		protected function onPushSecurityError(event:SecurityErrorEvent ) : void {
			// Crash this boat! - url requests might never gonna happen
			_broken = true;
			logger.fatal( "Security Error while trying to parse the request {0}. Will mark the logger as broken. Usually unfixable.", event );
		}
		
		/**
		 * Triggered on IOError while sending the log statements.
		 * 
		 * <p>Will try to send events again.</p>
		 * 
		 * @param event Event sent by <code>URLLoader</code>.
		 */
		protected function onPushIoError(event:IOErrorEvent): void {
			tryAgain(event.target,event);
		}
		
		/**
		 * Tries loading the statements once more.
		 * 
		 * @param target URLLoader used to rerequest the statements.
		 * @param error Error that occured because of which we have to retry now
		 *        (for debug purposes)
		 */
		protected function tryAgain(target:Object, error:*):void {
			var retries:int = _retries[target];
			if( retries > 0 ) {
				logger.warn("Request to server resulted in IOError {0}.  retrying {1} more times.", error, retries);
				var loader:URLLoader = URLLoader(target);
				process(_loaders[loader],loader);
				_retries[target] = retries-1;
			} else {
				logger.error("Request to server resulted in IOError {0}. Will not try to approach anymore.", error);
				delete _loaders[target];
				_loaderPool.push(target);
			}
		}
		
		/**
		 * Pushes the statements to the server.
		 */
		private function pushStatements():void {
			
			_retries[process(_buffer)] = _maxTries;
			
			if(_buffer.length > 0) {
				_nextPushTimeout = setTimeout(pushStatements, _pushInterval);
			} else {
				_nextPushTimeout = IS_RESET;
			}
		}
		
		/**
		 * Processes the passed in statements.
		 * 
		 * @param statements Statements that need to be processed.
		 * @param loader Loader used process the request, if null one from the
		 *        pool is used. If none is available one is registered.
		 */
		private function process(statements:Array, loader:URLLoader=null):URLLoader {
			if(!loader) {
				loader = _loaderPool.pop();
			}
			if(!loader) {
				loader = new URLLoader();
				loader.addEventListener(Event.COMPLETE, onPushComplete, false, 0, true);
				loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onPushHttpStatus, false, 0, true);
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onPushSecurityError, false, 0, true);
				loader.addEventListener(IOErrorEvent.IO_ERROR, onPushIoError, false, 0, true);
			}
			_loaders[loader] = doRequest(loader, statements);
			return loader;
		}
	}
}
