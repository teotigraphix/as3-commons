package org.as3commons.logging.setup.target {

	import org.as3commons.logging.level.DEBUG;
	import org.as3commons.logging.level.ERROR;
	import org.as3commons.logging.level.FATAL;
	import org.as3commons.logging.level.INFO;
	import org.as3commons.logging.level.WARN;
	import org.as3commons.logging.setup.target.IFormattingLogTarget;
	import org.as3commons.logging.util.LogMessageFormatter;
	import org.spicefactory.lib.logging.LogContext;
	import org.spicefactory.lib.logging.Logger;
	
	public final class SpiceLibTarget implements IFormattingLogTarget {
	
		public static const DEFAULT_FORMAT: String = "{message}";
		
		/** All the SpliceLib loggers requested for that logger */
		private const _loggers:Object = {};
		
		private var _formatter: LogMessageFormatter;
		
		public function SpiceLibTarget() {
			this.format = DEFAULT_FORMAT;
		}
		
		public function set format( format:String ): void {
			_formatter = new LogMessageFormatter( format||DEFAULT_FORMAT );
		}
		
		public function log( name: String, shortName: String, level: int,
							 timeStamp: Number, message: *, parameters: Array,
							 person: String = null ): void {
			message = _formatter.format(name, shortName, level, timeStamp, message, parameters, person);
			var logger: Logger = _loggers[ name ] || (_loggers[ name ]=LogContext.getLogger( name ));
			switch( level ) {
				case DEBUG:
					logger.debug( message );
					break;
				case INFO:
					logger.info( message );
					break;
				case WARN:
					logger.warn( message );
					break;
				case ERROR:
					logger.error( message );
					break;
				case FATAL:
					logger.fatal( message );
					break;
			}
		}
	}
}

