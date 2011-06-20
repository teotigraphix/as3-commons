package org.as3commons.logging.integration {
	import org.asaplibrary.util.debug.Log;
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.getNamedLogger;
	import org.asaplibrary.util.debug.LogEvent;
	/**
	 * @author mh
	 */
	public function ASAPIntegration( event:LogEvent ):void {
		var nameStr: String = event.sender.replace("::",".");
		var logger: ILogger = _cache[ nameStr ] || ( _cache[ nameStr ] = getNamedLogger( nameStr, "asap" ) );
		switch( event.level ) {
			case Log.LEVEL_DEBUG:
				logger.debug( event.text );
				break;
			case Log.LEVEL_STATUS:
			case Log.LEVEL_INFO:
				logger.info( event.text );
				break;
			case Log.LEVEL_WARN:
				logger.warn( event.text );
				break;
			case Log.LEVEL_ERROR:
				logger.error( event.text );
				break;
			case Log.LEVEL_FATAL:
				logger.fatal( event.text );
				break;
		}
	}
}

const _cache: Object = {};