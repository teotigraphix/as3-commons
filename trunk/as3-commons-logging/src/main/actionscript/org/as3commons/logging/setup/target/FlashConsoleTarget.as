package org.as3commons.logging.setup.target {

	import com.junkbyte.console.Cc;
	
	import org.as3commons.logging.level.DEBUG;
	import org.as3commons.logging.level.ERROR;
	import org.as3commons.logging.level.FATAL;
	import org.as3commons.logging.level.INFO;
	import org.as3commons.logging.level.WARN;
	import org.as3commons.logging.setup.target.IFormattingLogTarget;
	import org.as3commons.logging.util.LogMessageFormatter;
	
	/**
	 * <p>Built on Version 2.5</p>
	 * 
	 * @author Martin Heidegger
	 * @since 2.1
	 * @see https://code.google.com/p/flash-console/
	 */
	public final class FlashConsoleTarget implements IFormattingLogTarget {
		
		/** Formatter that renders the log statements via MonsterDebugger.log(). */
		private static const DEFAULT_FORMAT: String = "{time} {shortName}{atPerson} {message}";
		
		/** Formatter that formats the log statements. */
		private var _formatter: LogMessageFormatter;
		
		public function FlashConsoleTarget( format:String=null ) {
			this.format = format;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set format( format:String ): void {
			_formatter = new LogMessageFormatter( format || DEFAULT_FORMAT );
		}
		
		/**
		 * @inheritDoc
		 */
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

