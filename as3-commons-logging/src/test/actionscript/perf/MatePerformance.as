package perf {
	import com.asfusion.mate.core.MateManager;
	import com.asfusion.mate.utils.debug.IMateLogger;

	import flash.utils.getTimer;

	/**
	 * @author mh
	 */
	public class MatePerformance implements IPerformance {
		public function simple(count : int) : Number {
			var logger: IMateLogger = MateManager.instance.getLogger(false);
			var t: Number = getTimer();
			for( var i:int = 0; i<count; ++i ) {
				logger.debug("Hello World");
			}
			return getTimer()-t;
		}
		
		public function nullLogger(count : int) : Number {
			var nullTarget: NullTarget = new NullTarget();
			MateManager.instance.debugger = nullTarget;
			var logger: IMateLogger = MateManager.instance.getLogger(true);
			var t: Number = getTimer();
			for( var i:int = 0; i<count; ++i ) {
				logger.debug("Hello World");
			}
			t = getTimer()-t;
			MateManager.instance.debugger = null;
			return t;
		}
		
		public function get name() : String {
			return "mate";
		}
	}
}
import mx.logging.ILogger;
import mx.logging.ILoggingTarget;
import mx.logging.LogEvent;
import mx.logging.LogEventLevel;

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
