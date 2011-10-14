package perf {
	import flash.utils.getTimer;
	import com.pblabs.engine.debug.Logger;
	import perf.IPerformance;

	/**
	 * @author mh
	 */
	public final class PBEPerformance implements IPerformance {
		
		public function simple(count : int) : Number {
			Logger.disable();
			var t: Number = getTimer();
			for( var i:int = 0; i<count; ++i ) {
				Logger.debug( this, "simple", "Hello World");
			}
			return getTimer()-t;
		}
		
		public function nullLogger(count : int) : Number {
			PBEFix.enable();
			Logger.registerListener(new NullLogger());
			var t: Number = getTimer();
			for( var i:int = 0; i<count; ++i ) {
				Logger.debug( this, "simple", "Hello World");
			}
			t = getTimer()-t;
			return t;
		}

		public function get name() : String {
			return "PBE";
		}
	}
}
import com.pblabs.engine.debug.ILogAppender;
import com.pblabs.engine.debug.Logger;

class PBEFix extends Logger {
	public function PBEFix() {
		super(null);
	}

	public static function enable(): void {
		pendingEntries = [];
		started = true;
		listeners = [];
		disabled = false;
	}
}

class NullLogger implements ILogAppender {
	public function addLogMessage(level : String, loggerName : String, message : String) : void {
	}
	
}
