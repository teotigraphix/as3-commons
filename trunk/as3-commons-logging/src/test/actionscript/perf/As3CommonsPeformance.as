package perf {
	import org.as3commons.logging.LOGGER_FACTORY;
	import org.as3commons.logging.Logger;
	import org.as3commons.logging.getLogger;
	import org.as3commons.logging.setup.SimpleTargetSetup;

	import flash.utils.getTimer;

	/**
	 * @author mh
	 */
	public final class As3CommonsPeformance implements IPerformance {
		public static const info: Logger = getLogger(PerformanceComparison) as Logger;
		
		public function get name() : String {
			return "as3commons";
		}
		
		public function simple( count:int ):Number {
			LOGGER_FACTORY.setup = null;
			var t: Number = getTimer();
			for( var i:int = 0; i<count; ++i ) {
				info.error( "Hello World" );
			}
			
			return getTimer()-t;
		}
		
		public function nullLogger(count : int) : Number {
			LOGGER_FACTORY.setup = new SimpleTargetSetup( new NullLogger() );
			var t: Number = getTimer();
			for( var i:int = 0; i<count; ++i ) {
				info.error( "Hello World" );
			}
			t = getTimer()-t;
			LOGGER_FACTORY.setup = null;
			return t;
		}
	}
}
import org.as3commons.logging.setup.ILogTarget;

final class Test {
	protected static var enabled: Boolean;
	
	public static function test(): void {
		if( enabled ) {
			trace("HI");
		}
	}
}

class NullLogger implements ILogTarget {
	public function log(name : String, shortName : String, level : int, timeStamp : Number, message : *, parameters : Array, person : String) : void {
	}
}