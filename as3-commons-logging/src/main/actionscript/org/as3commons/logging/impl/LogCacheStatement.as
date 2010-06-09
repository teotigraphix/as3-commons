package org.as3commons.logging.impl {
	
	import org.as3commons.logging.LogLevel;
	
	/**
	 * @author martin.heidegger
	 */
	public class LogCacheStatement 
	{
		public var name: String;
		public var level: LogLevel;
		public var timeMs: Number;
		public var message: String;
		public var params: Array;
		public var shortName: String;
		
		public function LogCacheStatement(name: String, shortName: String, level: LogLevel, timeMs: Number, message: String, params: Array) {
			this.name = name;
			this.shortName = shortName;
			this.level = level;
			this.timeMs = timeMs;
			this.message = message;
			this.params = params;
		}
	}
}
