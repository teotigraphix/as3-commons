package org.as3commons.logging.setup.target {
	import org.asaplibrary.util.debug.Log;
	import org.as3commons.logging.level.DEBUG;
	import org.as3commons.logging.level.ERROR;
	import org.as3commons.logging.level.FATAL;
	import org.as3commons.logging.level.INFO;
	import org.as3commons.logging.level.WARN;
	import org.as3commons.logging.util.LogMessageFormatter;
	/**
	 * @author mh
	 */
	public class ASAPTarget implements IFormattingLogTarget {
		
		public static const DEFAULT_FORMAT:String = "{message}";
		
		private var _formatter: LogMessageFormatter;
		
		public function ASAPTarget( format:String=null ) {
			this.format = format;
		}
		
		public function set format( format:String ): void {
			_formatter = new LogMessageFormatter( format||DEFAULT_FORMAT );
		}
		
		public function log( name: String, shortName: String, level: int,
							 timeStamp: Number, message: *, parameters: Array,
							 person: String = null ): void {
			message = _formatter.format(name, shortName, level, timeStamp,
										message, parameters, person);
			switch( level ) {
				case INFO:
					Log.info( message, name );
					break;
				case DEBUG:
					Log.debug( message, name );
					break;
				case ERROR:
					Log.error( message, name );
					break;
				case WARN:
					Log.warn( message, name );
					break;
				case FATAL:
					Log.fatal( message, name );
					break;
			}
		}
	}
}
