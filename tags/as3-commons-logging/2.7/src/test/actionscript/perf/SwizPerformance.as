package perf {
	import org.swizframework.utils.logging.SwizLogger;

	import flash.utils.getTimer;
	/**
	 * @author mh
	 */
	public final class SwizPerformance implements IPerformance {
		
		public static const logger:SwizLogger = SwizLogger.getLogger(SwizPerformance);
		
		public function simple( count:int ):Number {
			var t: Number = getTimer();
			for( var i:int = 0; i<count; ++i ) {
				logger.debug("Hello World");
			}
			return getTimer()-t;
		}
		
		public function nullLogger(count : int) : Number {
			var nullTarget: NullLogger = new NullLogger();
			SwizLogger.addLoggingTarget(nullTarget);
			var t: Number = getTimer();
			for( var i:int = 0; i<count; ++i ) {
				logger.debug("Hello World");
			}
			t = getTimer()-t;
			SwizFix.removeTarget(nullTarget);
			return t;
		}
		
		public function get name() : String {
			return "swiz";
		}
	}
}
import org.swizframework.utils.logging.SwizLogEventLevel;
import org.swizframework.utils.logging.AbstractSwizLoggingTarget;
import org.swizframework.utils.logging.SwizLogger;

class SwizFix extends SwizLogger {
	public function SwizFix() {
		super(null);
	}

	public static function removeTarget(target:AbstractSwizLoggingTarget):void {
		var targets: Array = SwizLogger.loggingTargets;
		var index: int = targets.indexOf(target);
		if( index != -1 ) {
			targets.splice(index,1);
			for each( var logger:SwizLogger in loggers )
			{
				target.removeLogger( logger );
			}
		}
	}
}

class NullLogger extends AbstractSwizLoggingTarget {
	public function NullLogger() {
		filters = ["*"];
		level = SwizLogEventLevel.ALL;
	}
}