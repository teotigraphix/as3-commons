package org.as3commons.logging.impl 
{
	import org.as3commons.logging.ILogTarget;
	import org.as3commons.logging.ILogTargetFactory;
	import org.as3commons.logging.util.LogMessageFormatter;
	import flash.events.SecurityErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import flash.net.XMLSocket;
	import org.as3commons.logging.LogLevel;

	
	/**
	 * @author martin.heidegger
	 */
	public class SOSLogTarget extends AbstractLogTarget implements ILogTargetFactory
	{
		public static const DEFAULT_HOST: String = "localhost";
		public static const DEFAULT_FORMAT: String = "{shortSWF}({time}) {shortName}: {message}";
		public static const INSTANCE: SOSLogTarget = new SOSLogTarget();
		
		private var _host: String;
		private var _port: uint;
		private var _cache: Array;
		private var _socket: XMLSocket;
		private var _ready: Boolean;
		private var _format: String;
		private var _broken: Boolean;
		
		public function SOSLogTarget( format: String = null, host: String = null, port: uint = 4444 ) {
			if( !format ) {
				_format = DEFAULT_FORMAT;
			} else {
				_format = format;
			}
			if( !host ) {
				_host = DEFAULT_HOST;
			} else {
				_host = host;
			}
			_port = port;
			_cache = [];
			_ready = false;
		}
		
		override public function log( name: String, shortName: String, level: LogLevel, timeStamp: Number, message: String, params: Array ): void {
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
							markAsBroken( "Connection to SOS was not allowed due to Security Error: " + e.message );
						}
					}
					_cache.push( new LogCacheStatement(name, shortName, level, timeStamp, message, params) );
				}
			} else {
				_socket.send("!SOS<showMessage key=\"" + level.name + "\"><![CDATA[" + LogMessageFormatter.format( _format, name, shortName, level, timeStamp, message, params).replace(/\<\!\[CDATA\[/gi, "").replace(/]]\>/gi,"") + "]]></showMessage>\n");
			}
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
		
		private function onConnectionToSOSestablished( event:Event ): void {
			_ready = true;
			var i: int = _cache.length;
			while( --i-(-1) ) {
				var statement: LogCacheStatement = _cache.shift();
				log( statement.name, statement.shortName, statement.level, statement.timeMs, statement.message, statement.params );
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
			markAsBroken( "A security error prevented the connection to SOS" );
		}
		
		public function getLogTarget(name: String): ILogTarget {
			return this;
		}
	}
}
