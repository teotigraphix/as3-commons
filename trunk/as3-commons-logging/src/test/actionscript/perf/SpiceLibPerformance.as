package perf {
	import org.spicefactory.lib.flash.logging.impl.DefaultLogFactory;
	import org.spicefactory.lib.logging.LogContext;
	import org.spicefactory.lib.logging.Logger;
	import flash.utils.getTimer;

	/**
	 * @author mh
	 */
	public class SpiceLibPerformance implements IPerformance {
		public static const logger: Logger = LogContext.getLogger(SpiceLibPerformance);
		
		public function simple(count : int) : Number {
			LogContext.factory = new DefaultLogFactory();
			var t: Number = getTimer();
			for( var i:int = 0; i<count; ++i ) {
				logger.debug("Hello World");
			}
			return getTimer()-t;
		}
		
		public function nullLogger(count : int) : Number {
			var factory: DefaultLogFactory = new DefaultLogFactory();
			factory.addAppender( new NullAppender() );
			LogContext.factory = factory;
			var t: Number = getTimer();
			for( var i:int = 0; i<count; ++i ) {
				logger.debug("Hello World");
			}
			return getTimer()-t;
		}
		
		public function get name() : String {
			return "spicelib";
		}
	}
}
import org.spicefactory.lib.flash.logging.LogEvent;
import org.spicefactory.lib.flash.logging.impl.AbstractAppender;

class NullAppender extends AbstractAppender {
	
	override protected function handleLogEvent(event : LogEvent) : void {
		super.handleLogEvent(event);
	}
}