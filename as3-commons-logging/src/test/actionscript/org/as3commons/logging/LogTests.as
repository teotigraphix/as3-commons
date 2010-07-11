package org.as3commons.logging {
	import org.as3commons.logging.integration.FlexIntegrationTest;
	import org.as3commons.logging.setup.ComplexSetupTest;
	import org.as3commons.logging.setup.FlexSetupTest;
	import org.as3commons.logging.setup.TargetSetupTest;
	import org.as3commons.logging.setup.target.BufferTest;
	import org.as3commons.logging.setup.target.FrameBufferTest;
	import org.as3commons.logging.setup.target.MergedTest;
	import org.as3commons.logging.setup.target.TextFieldTest;
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
				new LogSetupTest(),
				new LogMessageFormatterTest(),
				new FlexIntegrationTest(),
				new ComplexSetupTest(),
				new TargetSetupTest(),
				new FlexSetupTest(),
				new FrameBufferTest(),
				new BufferTest(),
				new MergedTest(),
				new TextFieldTest()
			]);
		}
	}
}
