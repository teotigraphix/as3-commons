package org.as3commons.logging {
	import org.as3commons.logging.util.LogMessageFormatterTest;
	import org.flexunit.internals.TraceListener;
	import org.flexunit.runner.FlexUnitCore;

	import flash.display.Sprite;
	import flash.display.Stage;

	/**
	 * @author Martin
	 */
	public class LogTests extends Sprite
	{
		public static var STAGE: Stage;
		
		public function LogTests() {
			STAGE = stage;
			var core: FlexUnitCore = new FlexUnitCore();
			core.addListener( new TraceListener() );
			core.run( [
				new LogLevelTest(),
				new LogTargetLevelTest(),
				new LoggerFactoryTest(),
				new LogMessageFormatterTest()
			]);
		}
	}
}
