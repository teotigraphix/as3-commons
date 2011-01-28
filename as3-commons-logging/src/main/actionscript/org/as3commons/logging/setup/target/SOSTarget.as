	package org.as3commons.logging.setup.target {
	
	
	import org.as3commons.logging.LogLevel;
	import org.as3commons.logging.util.LogMessageFormatter;
	
	/**
	 * @author martin.heidegger
	 */
	public final class SOSTarget implements IFormattingLogTarget {
		
		public static const DEFAULT_FORMAT: String = "{shortSWF}({time}) {shortName}: {message}";
		public static const INSTANCE: SOSTarget = new SOSTarget();
		
		private var _formatter:LogMessageFormatter;
		private var _gateway:SOSGateway;
		
		public function SOSTarget( format: String = null, gateway: SOSGateway = null ) {
			this.format = format;
			_gateway = gateway || SOSGateway.INSTANCE;
		}
		
		public function log( name: String, shortName: String, level: LogLevel, timeStamp: Number, message: *, params: Array ): void {
			_gateway.log( level.name, _formatter.format( name, shortName, level, timeStamp, message, params) );
		}

		public function set format( format: String ): void {
			_formatter = new LogMessageFormatter( format || DEFAULT_FORMAT );
		}
	}
}
