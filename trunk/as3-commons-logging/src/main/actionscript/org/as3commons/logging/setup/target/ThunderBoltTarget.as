package org.as3commons.logging.setup.target {
	import org.as3commons.logging.util.LogMessageFormatter;
	import org.as3commons.logging.level.DEBUG;
	import org.as3commons.logging.level.ERROR;
	import org.as3commons.logging.level.FATAL;
	import org.as3commons.logging.level.INFO;
	import org.as3commons.logging.level.WARN;
	import org.as3commons.logging.setup.ILogTarget;
	import org.osflash.thunderbolt.Logger;
	
	/**
	 * @author Martin Heidegger
	 */
	public class ThunderBoltTarget implements ILogTarget {
		
		public static const DEFAULT_FORMAT:String = "{logTime} {name}{atPerson}: {message}";
		
		private var _formatter : LogMessageFormatter;
		
		public function ThunderBoltTarget( format:String=null ) {
			// Exclude time, the time of our logger is more accurate
			Logger.includeTime = false;
			// It will use the wrong caller, so just disable it
			Logger.showCaller = false;
			this.format = format;
		}
		
		public function set format( format:String ): void {
			_formatter = new LogMessageFormatter( format||DEFAULT_FORMAT );
		}
		
		public function log( name:String, shortName:String, level:int,
							 timeStamp:Number, message:*, parameters:Array,
							 person:String=null): void {
			if( message is String || parameters.length != 0 ) {
				message = _formatter.format(name, shortName, level, timeStamp, message, parameters );
			}
			switch( level ) {
				case DEBUG:
					Logger.debug(message);
					break;
				case INFO:
					Logger.info(message);
					break;
				case WARN:
					Logger.warn(message);
					break;
				case ERROR:
					Logger.error(message);
					break;
				case FATAL:
					Logger.error(message);
					break;
			}
		}
	}
}
