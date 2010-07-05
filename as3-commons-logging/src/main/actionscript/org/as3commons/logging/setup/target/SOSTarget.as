package org.as3commons.logging.setup.target {
	
	
	import org.as3commons.logging.LogLevel;
	import org.as3commons.logging.setup.ILogTarget;
	import org.as3commons.logging.util.LogMessageFormatter;
	
	/**
	 * @author martin.heidegger
	 */
	public final class SOSTarget implements ILogTarget {
		
		public static const DEFAULT_FORMAT: String = "{shortSWF}({time}) {shortName}: {message}";
		public static const INSTANCE: SOSTarget = new SOSTarget();
		
		private var _formatter:LogMessageFormatter;
		private var _gateway:SOSGateway;
		
		public function SOSTarget( format: String = null, gateway: SOSGateway = null ) {
			_formatter = new LogMessageFormatter( format || DEFAULT_FORMAT );
			_gateway = gateway || SOSGateway.INSTANCE;
		}
		
		public function log( name: String, shortName: String, level: LogLevel, timeStamp: Number, message: String, params: Array ): void {
			_gateway.log( level.name, _formatter.format( name, shortName, level, timeStamp, message, params) );
		}
	}
}
