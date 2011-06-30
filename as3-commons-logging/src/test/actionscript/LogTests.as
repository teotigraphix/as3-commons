package {
	import org.as3commons.logging.util.ByteArrayCopyTest;
	import org.as3commons.logging.ILogSetup;
	import org.as3commons.logging.LogLevelTest;
	import org.as3commons.logging.Logger;
	import org.as3commons.logging.LoggerFactory;
	import org.as3commons.logging.getLogger;
	import org.as3commons.logging.integration.ASAPIntegrationTest;
	import org.as3commons.logging.integration.FlexIntegrationTest;
	import org.as3commons.logging.integration.MateIntegrationTest;
	import org.as3commons.logging.integration.Progression4IntegrationTest;
	import org.as3commons.logging.integration.PushButtonIntegrationTest;
	import org.as3commons.logging.integration.SpiceLibIntegrationTest;
	import org.as3commons.logging.integration.SwizIntegrationTest;
	import org.as3commons.logging.level.DEBUG;
	import org.as3commons.logging.level.ERROR;
	import org.as3commons.logging.level.FATAL;
	import org.as3commons.logging.level.INFO;
	import org.as3commons.logging.level.WARN;
	import org.as3commons.logging.setup.ComplexSetupTest;
	import org.as3commons.logging.setup.FlexSetupTest;
	import org.as3commons.logging.setup.LeveledTargetSetupTest;
	import org.as3commons.logging.setup.LogSetupTest;
	import org.as3commons.logging.setup.LogTargetLevelTest;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.setup.SimpleTargetSetupTest;
	import org.as3commons.logging.setup.target.AirTargetTest;
	import org.as3commons.logging.setup.target.BufferTest;
	import org.as3commons.logging.setup.target.FrameBufferTest;
	import org.as3commons.logging.setup.target.MergedTest;
	import org.as3commons.logging.setup.target.SWFInfoTest;
	import org.as3commons.logging.setup.target.TextFieldTest;
	import org.as3commons.logging.util.LogMessageFormatter;
	import org.as3commons.logging.util.LogMessageFormatterTest;
	import org.as3commons.logging.util.SWFInfo;
	import org.as3commons.logging.util.toLogName;
	import org.flexunit.internals.TraceListener;
	import org.flexunit.runner.FlexUnitCore;

	import mx.logging.AbstractTarget;
	import mx.logging.ILoggingTarget;
	import mx.logging.Log;
	import mx.logging.LogEvent;
	import mx.logging.LogEventLevel;
	import mx.logging.LogLogger;
	import mx.logging.errors.InvalidCategoryError;
	import mx.logging.errors.InvalidFilterError;
	import mx.logging.targets.TraceTarget;

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.sampler.getSize;
	import flash.utils.getTimer;



	/**
	 * @author Martin
	 */
	public class LogTests extends Sprite
	{
		public static var STAGE: Stage;
		
		private static const debugs: int = DEBUG;
		
		private const debugp: int = DEBUG;
		
		public final function LogTests() {
			STAGE = stage;
			
			DEBUG;
			debugp;
			debugs;
			
			var i: int = 0;
			var t: Number;
			const amount: int = 30000;
			
			t = getTimer();
			i = amount;
			while( --i ) {
				debugp;
			}
			trace( getTimer() - t, "private const" );
			
			t = getTimer();
			i = amount;
			while( --i ) {
				debugs;
			}
			trace( getTimer() - t, "static const" );
			
			t = getTimer();
			i = amount;
			while( --i ) {
				DEBUG;
			}
			trace( getTimer() - t, "ext. const" );
			
			var mxLoggingSize: uint = 0
					+ getSize(mx.logging.ILogger)
					+ getSize(ILoggingTarget)
					+ getSize(Log)
					+ getSize(LogEvent)
					+ getSize(LogEventLevel)
					+ getSize(LogLogger)
					+ getSize(AbstractTarget)
					+ getSize(InvalidCategoryError)
					+ getSize(InvalidFilterError)
					+ getSize(mx.logging.targets.TraceTarget);
			
			var as3commonsSize: uint = 0
					+ getSize(org.as3commons.logging.ILogger)
					+ getSize(ILogSetup)
					+ getSize(LoggerFactory)
					+ getSize(Logger)
					+ getSize(getLogger)
					+ getSize(toLogName)
					+ getSize(SimpleTargetSetup)
					+ getSize(TraceTarget)
					+ getSize(LogMessageFormatter)
					+ getSize(SWFInfo)
					+ getSize(DEBUG)
					+ getSize(ERROR)
					+ getSize(INFO)
					+ getSize(WARN)
					+ getSize(FATAL);
			
			trace("Size of MX Logging in memory, min: " + mxLoggingSize);
			trace("Size of as3-commons-logging in memory, min: " + as3commonsSize);
			trace("Difference: " + (mxLoggingSize-as3commonsSize)  );
			
			var core: FlexUnitCore = new FlexUnitCore();
			core.addListener( new TraceListener() );
			core.run( [
				new ByteArrayCopyTest(),
				new SwizIntegrationTest(),
				new PushButtonIntegrationTest(),
				//new ASAPIntegrationTest(),
				new SpiceLibIntegrationTest(),
				new Progression4IntegrationTest(),
				new LogLevelTest(),
				new LogTargetLevelTest(),
				new LogSetupTest(),
				new LogMessageFormatterTest(),
				new SWFInfoTest(),
				new FlexIntegrationTest(),
				new ComplexSetupTest(),
				new SimpleTargetSetupTest(),
				new LeveledTargetSetupTest(),
				new FlexSetupTest(),
				new FrameBufferTest(),
				new BufferTest(),
				new MergedTest(),
				new TextFieldTest(),
				new AirTargetTest()
			]);
		}
	}
}
