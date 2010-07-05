package org.as3commons.logging.setup.target {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.XMLSocket;

	/**
	 * @author mh
	 */
	public final class SOSGateway {
		
		public static const DEFAULT_HOST: String = "localhost";
		public static const INSTANCE: SOSGateway = new SOSGateway();
		
		private var _host: String;
		private var _port: uint;
		
		private var _socket: XMLSocket;
		
		private var _ready: Boolean;
		private var _broken: Boolean;
		
		private var _cache: Array;
		
		public function SOSGateway(host: String = null, port: uint = 4444) {
			_host = host || DEFAULT_HOST;
			_port = port;
			_cache = [];
			_ready = false;
		}
		
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
