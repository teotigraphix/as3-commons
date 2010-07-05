package org.as3commons.logging.setup.target {
	import org.as3commons.logging.LogLevel;

	/**
	 * @author mh
	 */
	public final class BufferStatement {
		
		public var name: String;
		public var level: LogLevel;
		public var timeStamp: Number;
		public var message: String;
		public var parameters: Array;
		public var shortName: String;
		
		public function BufferStatement(name: String, shortName: String, level: LogLevel, timeStamp: Number, message: String, parameters: Array) {
			this.name = name;
			this.shortName = shortName;
			this.level = level;
			this.timeStamp = timeStamp;
			this.message = message;
			this.parameters = parameters;
		}
	}
}
