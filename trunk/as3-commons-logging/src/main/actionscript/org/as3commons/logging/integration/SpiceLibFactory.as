package org.as3commons.logging.integration {
	import org.as3commons.logging.getNamedLogger;
	import org.spicefactory.lib.logging.LogFactory;
	import org.spicefactory.lib.logging.Logger;
	
	/**
	 * @author mh
	 */
	public class SpiceLibFactory implements LogFactory {
		
		private var _cache: Object = {};
		
		public function getLogger( name: Object ): Logger {
			var nameStr: String = name.toString();
			return _cache[ nameStr ] || ( _cache[ nameStr ] = new LoggerWrapper( getNamedLogger( nameStr ) ) );
		}
	}
}

import org.as3commons.logging.ILogger;
import org.spicefactory.lib.logging.Logger;

class LoggerWrapper implements Logger {
	
	private var _logger: ILogger;
	
	public function LoggerWrapper( logger: ILogger ) {
		_logger = logger;
	}
	
	public function debug( message:String, ...args:* ):void {	
		_logger.debug.apply( null, [ message ].concat( args ) );
	}

	public function error( message:String, ...args:* ):void {	
		_logger.error.apply( null, [ message ].concat( args ) );
	}

	public function fatal( message:String, ...args:* ):void {	
		_logger.fatal.apply( null, [ message ].concat( args ) );
	}

	public function info( message:String, ...args:*):void {
		_logger.info.apply( null, [ message ].concat( args ) );
	}

	public function trace( message:String, ...args:* ):void {	
		_logger.info.apply( null, [ message ].concat( args ) );
	}

	public function warn( message:String, ...args:* ):void {	
		_logger.warn.apply( null, [ message ].concat( args ) );
	}

	public function isDebugEnabled():Boolean {
		return _logger.debugEnabled;
	}

	public function isErrorEnabled():Boolean {
		return _logger.errorEnabled;
	}

	public function isFatalEnabled():Boolean {
		return _logger.fatalEnabled;
	}

	public function isInfoEnabled():Boolean {
		return _logger.infoEnabled;
	}

	public function isTraceEnabled():Boolean {
		return _logger.infoEnabled;
	}

	public function isWarnEnabled():Boolean {
		return _logger.warnEnabled;
	}

	public function get name():String {
		return _logger.name;
	}

}