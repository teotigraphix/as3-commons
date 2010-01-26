package org.as3commons.logging {
	import org.flexunit.internals.TraceListener;
	import org.flexunit.runner.FlexUnitCore;

	import flash.display.Sprite;

	/**
	 * @author Martin
	 */
	public class LogTests extends Sprite
	{
		public function LogTests() {
			var core: FlexUnitCore = new FlexUnitCore();
			core.addListener( new TraceListener() );
			core.run( [
				new BasicLoggingTest(),
				new LogLevelTest(),
				new LoggerFactoryTest()
			]);
		}
	}
}
