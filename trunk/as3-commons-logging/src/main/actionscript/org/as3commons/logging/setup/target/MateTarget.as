package org.as3commons.logging.setup.target {
	import com.asfusion.mate.core.MateManager;
	import com.asfusion.mate.utils.debug.IMateLogger;

	import org.as3commons.logging.level.DEBUG;
	import org.as3commons.logging.level.ERROR;
	import org.as3commons.logging.level.FATAL;
	import org.as3commons.logging.level.INFO;
	import org.as3commons.logging.level.WARN;
	import org.as3commons.logging.util.LogMessageFormatter;
	
	/**
	 * @author mh
	 */
	public class MateTarget implements IFormattingLogTarget {
		
		public static const DEFAULT_FORMAT:String = "{message}";
		
		private var _formatter : LogMessageFormatter;
		private var _logger: IMateLogger;
		
		public function MateTarget( format:String=null ) {
			_logger = MateManager.instance.getLogger(true);
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
					_logger.info( message );
					break;
				case DEBUG:
					_logger.debug( message );
					break;
				case ERROR:
					_logger.error( message );
					break;
				case WARN:
					_logger.warn( message );
					break;
				case FATAL:
					_logger.fatal( message );
					break;
			}
		}
	}
}
