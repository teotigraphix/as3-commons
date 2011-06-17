package org.as3commons.logging.setup.target {

	import jp.nium.core.debug.Logger;
	import org.as3commons.logging.level.DEBUG;
	import org.as3commons.logging.level.ERROR;
	import org.as3commons.logging.level.FATAL;
	import org.as3commons.logging.level.INFO;
	import org.as3commons.logging.level.WARN;
	import org.as3commons.logging.setup.ILogTarget;
	import org.as3commons.logging.util.LogMessageFormatter;
	/**
	 * @author mh
	 */
	public class Progression4Target implements IFormattingLogTarget, ILogTarget {
		
		private static const DEFAULT_FORMAT: String = "{shortName} {message}";
		
		private var _formatter: LogMessageFormatter;
		
		public function Progression4Target( format:String=null ) {
			this.format = format;
		}
		
		public function set format( format:String ): void {
			_formatter = new LogMessageFormatter( format||DEFAULT_FORMAT );
		}
		
		public function log( name: String, shortName: String, level: int,
							 timeStamp: Number, message: *, parameters: Array,
							 person: String = null ): void {
			message = _formatter.format(name, shortName, level, timeStamp, message, parameters, person);
			switch( level ) {
				case DEBUG:
					Logger.info( message );
					break;
				case INFO:
					Logger.info( message );
					break;
				case WARN:
					Logger.warn( message );
					break;
				case ERROR:
					Logger.error( message );
					break;
				case FATAL:
					Logger.error( message );
					break;
			}
		}
	}
}
