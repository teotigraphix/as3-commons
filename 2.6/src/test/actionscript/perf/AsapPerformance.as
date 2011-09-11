package perf {
	import org.asaplibrary.util.debug.Log;
	import flash.utils.getTimer;
	/**
	 * @author mh
	 */
	public final class AsapPerformance implements IPerformance {
		
		
		public function simple( count:int ):Number {
			Log.showTrace(false);
			var t: Number = getTimer();
			for( var i:int = 0; i<count; ++i ) {
				Log.debug("AsapPerformance", "Hello World");
			}
			return getTimer()-t;
		}
		
		public function nullLogger( count: int ): Number {
			Log.showTrace(false);
			var nullFnc: Function = function():void{};
			Log.addLogListener(nullFnc);
			var t: Number = getTimer();
			for( var i:int = 0; i<count; ++i ) {
				Log.debug("AsapPerformance", "Hello World");
			}
			t = getTimer()-t;
			Log.removeLogListener(nullFnc);
			return t;
		}
		
		public function get name() : String {
			return "asap";
		}
	}
}
