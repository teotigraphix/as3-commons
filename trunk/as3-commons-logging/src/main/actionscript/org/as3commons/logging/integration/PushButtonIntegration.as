package org.as3commons.logging.integration {
	import com.pblabs.engine.debug.LogEntry;
	import org.as3commons.logging.getNamedLogger;
	import org.as3commons.logging.ILogger;
	import com.pblabs.engine.debug.ILogAppender;
	/**
	 * @author mh
	 */
	public class PushButtonIntegration implements ILogAppender {
		
		private static const _cache: Object = {};
		
		public function addLogMessage(level:String, loggerName:String, message:String):void {
			var logger: ILogger = _cache[ loggerName ] || ( _cache[ loggerName ] = getNamedLogger( loggerName.replace("::", "."), "pushbutton" ) );
			switch( level ) {
				case LogEntry.DEBUG:
					logger.debug(message);
					break;
				case LogEntry.INFO:
					logger.info(message);
					break;
				case LogEntry.WARNING:
					logger.warn(message);
					break;
				case LogEntry.ERROR:
					logger.error(message);
					break;
				default:
					logger.debug(message);
					break;
			}
		}
	}
}
