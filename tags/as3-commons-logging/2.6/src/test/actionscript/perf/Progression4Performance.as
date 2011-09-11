package perf {
	import jp.nium.core.debug.Logger;
	import flash.utils.getTimer;
	import perf.IPerformance;

	/**
	 * @author mh
	 */
	public final class Progression4Performance implements IPerformance {
		public function simple(count : int) : Number {
			Logger.enabled = false;
			var t: Number = getTimer();
			for( var i:int = 0; i<count; ++i ) {
				Logger.info("Hello World");
			}
			return getTimer()-t;
		}

		public function nullLogger(count : int) : Number {
			Logger.enabled = true;
			Logger.loggingFunction = nullFnc;
			var t: Number = getTimer();
			for( var i:int = 0; i<count; ++i ) {
				Logger.info("Hello World");
			}
			t = getTimer()-t;
			Logger.loggingFunction = null; 
			return t;
		}
		
		public function nullFnc(...rest): void {
			
		}

		public function get name() : String {
			return "progression4";
		}
	}
}
