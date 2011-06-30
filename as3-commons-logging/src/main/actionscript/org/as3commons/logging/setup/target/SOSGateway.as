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
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.XMLSocket;
	
	/**
	 * <code>SOSGateway</code> acts as gateway to channel all requests from <code>
	 * SOSTarget</code> instances to the same server.
	 * 
	 * <p>There is the chance that one might want to use differently formatted
	 * messages in the configuration for the same SOS target. This Gateway is the
	 * separation between "how to access" and "what to send".</p>
	 * 
	 * <p>The Gateway contains fall-back mechanisms if its was temporarily not possible to send
	 * log statements to the targets. (i.e. If the SOS console wasnt started at
	 * the time of the start of the swf)</p>
	 * 
	 * @author Martin Heidegger
	 * @since 2.0
	 */
	public final class SOSGateway {
		
		/** Default host to be used if none is defined */
		public static const DEFAULT_HOST: String = "localhost";
		 
		private var _host: String;
		private var _port: uint;
		
		private var _socket: XMLSocket;
		
		private var _ready: Boolean;
		private var _broken: Boolean;
		
		private var _cache: Array;
		
		/**
		 * Constructs a new <code>SOSGateway</code>
		 * 
		 * @param host Host on which the SOS console is running (default: localhost)
		 * @param port Port on which the SOS console is running (default: 4444)
		 */
		public function SOSGateway(host: String = null, port: uint = 4444) {
			_host = host || DEFAULT_HOST;
			_port = port;
			_cache = [];
			_ready = false;
		}
		
		/**
		 * Logs a Statement to the SOS Console.
		 * 
		 * @param key
		 * @param message 
		 */
		public function log(key:String, message: String): void {
			if( !_ready ) {
				if( !_broken ) {
					if( !_socket ) {
						_socket = new XMLSocket();
						_socket.addEventListener( Event.CLOSE, onConnectionClosed );
						_socket.addEventListener( Event.CONNECT, onConnectionToSOSestablished );
						_socket.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
						_socket.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
						try {
							_socket.connect( _host, _port );
						} catch ( e: SecurityError ) {
							markAsBroken( "Connection to SOS was not allowed due to Security Error @"+_host+":"+_port+"]: " + e.message );
						}
					}
					_cache.push( new SOSCacheStatement(key,message) );
				}
			} else {
				_socket.send("!SOS<showMessage key=\"" + key + "\"><![CDATA[" + message.replace(/\<\!\[CDATA\[/gi, "").replace(/]]\>/gi,"") + "]]></showMessage>\n");
			}
		}
		
		private function onConnectionToSOSestablished( event:Event ): void {
			_ready = true;
			var i: int = _cache.length;
			while( --i-(-1) ) {
				var statement: SOSCacheStatement = _cache.shift();
				log( statement.key, statement.message );
			}
			_cache = null;
		}

		private function onConnectionClosed(event: Event): void {
			close();
		}
		
		private function onIOError(event: IOErrorEvent): void {
			close();
		}
		
		private function close(): void {
			try {
				_socket.close();
			} catch( e: Error ) {}
			_socket = null;
			_ready = false;
			if( !_cache ) {
				_cache = [];
			}
		}
		
		private function onSecurityError(event: SecurityErrorEvent): void {
			markAsBroken( "A security error prevented the connection to SOS @" + _host + ":" + _port );
		}
		
		private function markAsBroken( string: String): void {
			// Give the least of help for the developer
			trace( string );
			_broken = true;
			_ready = false;
			_socket.removeEventListener( Event.CLOSE, onConnectionClosed );
			_socket.removeEventListener( Event.CONNECT, onConnectionToSOSestablished );
			_socket.removeEventListener( IOErrorEvent.IO_ERROR, onIOError );
			_socket.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
			_socket.close();
			_socket = null;
			_cache = null;
		}
	}
}

final class SOSCacheStatement {
	
	internal var key:String;
	internal var message:String;
	
	public function SOSCacheStatement( key: String, message: String ) {
		this.key = key;
		this.message = message;
	}
}
