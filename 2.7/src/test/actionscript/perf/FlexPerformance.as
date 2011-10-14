package perf {
	import mx.logging.ILogger;
	import mx.logging.Log;

	import flash.utils.getTimer;
	
	/**
	 * @author mh
	 */
	public final class FlexPerformance implements IPerformance {
		
		public static const logger: ILogger = Log.getLogger("FlexPerformance");
		
		public function simple( count:int ):Number {
			var t: Number = getTimer();
			for( var i:int = 0; i<count; ++i ) {
				logger.debug("Hello World");
			}
			return getTimer()-t;
		}
		
		public function get name() : String {
			return "flex";
		}

		public function nullLogger(count : int) : Number {
			var target:NullTarget= new NullTarget();
			Log.addTarget( target );
			var t: Number = getTimer();
			for( var i:int = 0; i<count; ++i ) {
				logger.debug("Hello World");
			}
			t = getTimer()-t;
			Log.removeTarget( target );
			return t;
		}
	}
}
import mx.logging.LogEventLevel;
import mx.logging.LogEvent;
import mx.logging.ILogger;
import mx.logging.ILoggingTarget;

class NullTarget implements ILoggingTarget {
	public function addLogger(logger : ILogger) : void {
		logger.addEventListener(LogEvent.LOG, onLog);
	}
	
	public function removeLogger(logger : ILogger) : void {
		logger.removeEventListener(LogEvent.LOG, onLog);
	}

	private function onLog(event : LogEvent) : void {
	}

	public function get filters() : Array {
		return ["*"];
	}

	public function set filters(value : Array) : void {
	}

	public function get level() : int {
		return LogEventLevel.ALL;
	}

	public function set level(value : int) : void {
	}
}
