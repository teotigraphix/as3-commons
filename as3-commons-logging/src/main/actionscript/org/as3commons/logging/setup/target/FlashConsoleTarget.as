package org.as3commons.logging.setup.target {
	import com.junkbyte.console.Cc;
	import org.as3commons.logging.level.DEBUG;
	import org.as3commons.logging.level.ERROR;
	import org.as3commons.logging.level.FATAL;
	import org.as3commons.logging.level.INFO;
	import org.as3commons.logging.level.WARN;
	import org.as3commons.logging.util.LogMessageFormatter;
	
	
	/**
	 * @author mh
	 */
	public class FlashConsoleTarget implements IFormattingLogTarget {
		
		private static const DEFAULT_FORMAT: String;
		
		private var _formatter: LogMessageFormatter;
		
		public function FlashConsoleTarget( format:String=null ) {
			this.format = format;
		}
		
		public function set format( format:String ): void {
			_formatter = new LogMessageFormatter( format || DEFAULT_FORMAT );
		}
		
		public function log( name: String, shortName: String, level: int,
							 timeStamp: Number, message: *, parameters: Array,
							 person: String = null ): void {
			message = _formatter.format(name, shortName, level, timeStamp, message, parameters, person);
			switch( level ) {
				case DEBUG:
					Cc.debug( message );
					break;
				case INFO:
					Cc.info( message );
					break;
				case WARN:
					Cc.info( message );
					break;
				case ERROR:
					Cc.error( message );
					break;
				case FATAL:
					Cc.fatal( message );
					break;
			}
		}
	}
}
