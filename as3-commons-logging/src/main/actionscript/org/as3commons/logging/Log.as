package org.as3commons.logging {
	
	import org.as3commons.logging.util.toLogName;
	
	/**
	 * @author Martin Heidegger
	 * @since 2.1
	 */
	public class Log {
		
		public static function getLogger(input:*,person:String=null):ILogger {
			if(!(input is String)) {
				input = toLogName(input);
			}
			return LOGGER_FACTORY.getNamedLogger(input,person);
		}
		
		public static function set setup( setup: ILogSetup ): void {
			LOGGER_FACTORY.setup = setup;
		}
	}
}
