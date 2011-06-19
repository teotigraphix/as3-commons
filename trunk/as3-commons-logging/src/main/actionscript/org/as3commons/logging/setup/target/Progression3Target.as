package org.as3commons.logging.setup.target {
	import jp.progression.core.debug.Verbose;
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
	public class Progression3Target implements ILogTarget {
		
		private static const DEFAULT_FORMAT: String = "{shortName} {message}";
		
		private var _formatter: LogMessageFormatter;
		
		public function Progression3Target( format:String=null ) {
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
					Verbose.log( null, message );
					break;
				case INFO:
					Verbose.log( null, message );
					break;
				case WARN:
					Verbose.warning( null, message );
					break;
				case ERROR:
					Verbose.error( null, message );
					break;
				case FATAL:
					Verbose.error( null, message );
					break;
			}
		}
	}
}
