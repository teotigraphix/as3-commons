package {
	import org.as3commons.logging.setup.log4j.Log4JPropertiesTest;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.sampler.getSize;
	import flash.system.Capabilities;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import mx.logging.AbstractTarget;
	import mx.logging.ILogger;
	import mx.logging.ILoggingTarget;
	import mx.logging.Log;
	import mx.logging.LogEvent;
	import mx.logging.LogEventLevel;
	import mx.logging.LogLogger;
	import mx.logging.errors.InvalidCategoryError;
	import mx.logging.errors.InvalidFilterError;
	import mx.logging.targets.TraceTarget;
	import org.as3commons.logging.LogLevelTest;
	import org.as3commons.logging.api.ILogSetup;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.LOGGER_FACTORY;
	import org.as3commons.logging.api.Logger;
	import org.as3commons.logging.api.LoggerFactory;
	import org.as3commons.logging.api.LoggerTest;
	import org.as3commons.logging.api.getLogger;
	import org.as3commons.logging.integration.ASAPIntegrationTest;
	import org.as3commons.logging.integration.FlexIntegrationTest;
	import org.as3commons.logging.integration.Log5FIntegrationTest;
	import org.as3commons.logging.integration.LogMeisterIntegrationTest;
	import org.as3commons.logging.integration.MaashaackIntegrationTest;
	import org.as3commons.logging.integration.MateIntegrationTest;
	import org.as3commons.logging.integration.OSMFIntegrationTest;
	import org.as3commons.logging.integration.Progression4IntegrationTest;
	import org.as3commons.logging.integration.PushButtonIntegrationTest;
	import org.as3commons.logging.integration.SLF4ASIntegrationTest;
	import org.as3commons.logging.integration.SpiceLibIntegrationTest;
	import org.as3commons.logging.integration.SwizIntegrationTest;
	import org.as3commons.logging.integration.YUIIntegrationTest;
	import org.as3commons.logging.level.DEBUG;
	import org.as3commons.logging.setup.ComplexSetupTest;
	import org.as3commons.logging.setup.FlexSetupTest;
	import org.as3commons.logging.setup.HierarchicalSetupTest;
	import org.as3commons.logging.setup.LeveledTargetSetupTest;
	import org.as3commons.logging.setup.LogSetupTest;
	import org.as3commons.logging.setup.LogTargetLevelTest;
	import org.as3commons.logging.setup.MergedSetupTest;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.setup.SimpleTargetSetupTest;
	import org.as3commons.logging.setup.log4j.Log4JSetupTest;
	import org.as3commons.logging.setup.target.AirTargetTest;
	import org.as3commons.logging.setup.target.BufferTest;
	import org.as3commons.logging.setup.target.FrameBufferTest;
	import org.as3commons.logging.setup.target.MergedTest;
	import org.as3commons.logging.setup.target.SOSTarget;
	import org.as3commons.logging.setup.target.SWFInfoTest;
	import org.as3commons.logging.setup.target.TextFieldTest;
	import org.as3commons.logging.simple.SimpleLoggingTest;
	import org.as3commons.logging.simple.aTrace;
	import org.as3commons.logging.util.ByteArrayCopyTest;
	import org.as3commons.logging.util.HereTest;
	import org.as3commons.logging.util.JsonXifyTest;
	import org.as3commons.logging.util.LogMessageFormatter;
	import org.as3commons.logging.util.LogMessageFormatterTest;
	import org.as3commons.logging.util.SWFInfo;
	import org.as3commons.logging.util.toLogName;
	import org.as3commons.logging.util.xml.XMLRuleTest;
	import org.as3commons.logging.util.xml.XMLSetupTest;
	import org.as3commons.logging.util.xml.XMLTargetTest;
	import org.flexunit.internals.TraceListener;
	import org.flexunit.runner.FlexUnitCore;
	
	/**
	 * @author Martin
	 */
	[SWF(backgroundColor="#FF0000")]
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
			
			trace( stage.getChildAt(0) );
			
			LOGGER_FACTORY.setup = new SimpleTargetSetup( new SOSTarget() );
			
			aTrace();
			
			var i: int = 0;
			var t: Number;
			const amount: int = 3000000;
			
			var str: String = "";
			t = getTimer();
			i = amount;
			while( --i ) {
				debugp;
			}
			str += ( getTimer() - t ) + " private const\n";
			
			
			t = getTimer();
			i = amount;
			while( --i ) {
				debugs;
			}
			str += ( getTimer() - t ) + " static const\n";
			
			t = getTimer();
			i = amount;
			while( --i ) {
				DEBUG;
			}
			str += ( getTimer() - t ) + " ext. const\n";
			
			t = getTimer();
			i = amount/100;
			while( --i ) {
				Capabilities.isDebugger;
			}
			str += ( getTimer() - t ) + " Capabilities.isDebugger (1/100th!)\n";
			
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
					+ getSize(org.as3commons.logging.api.ILogger)
					+ getSize(ILogSetup)
					+ getSize(LoggerFactory)
					+ getSize(Logger)
					+ getSize(getLogger)
					+ getSize(toLogName)
					+ getSize(SimpleTargetSetup)
					+ getSize(LogMessageFormatter)
					+ getSize(SWFInfo);
			
			str += "Size of MX Logging in memory, min: " + mxLoggingSize + "\n";
			str += "Size of as3-commons-logging in memory, min: " + as3commonsSize + "\n";
			str += "Difference: " + (mxLoggingSize-as3commonsSize);
			
			
			getLogger("size").info( str );
			setTimeout( run, 80 );
		}
		private function run(): void {
			this.opaqueBackground = 0x000000;
			var core: FlexUnitCore = new FlexUnitCore();
			core.addListener( new TraceListener() );
			core.run( [
				new Log4JPropertiesTest(),
				new HierarchicalSetupTest(),
				new LoggerTest(),
				new Log4JSetupTest(),
				new MaashaackIntegrationTest(),
				new XMLSetupTest(),
				new XMLTargetTest(),
				new XMLRuleTest(),
				new Log5FIntegrationTest(),
				new SimpleLoggingTest(),
				new MergedSetupTest(),
				new MergedTest(),
				new ComplexSetupTest(),
				new JsonXifyTest(),
				new HereTest(),
				new ByteArrayCopyTest(),
				new YUIIntegrationTest(),
				new MateIntegrationTest(),
				new SwizIntegrationTest(),
				new SLF4ASIntegrationTest(),
				new PushButtonIntegrationTest(),
				new ASAPIntegrationTest(),
				new SpiceLibIntegrationTest(),
				new Progression4IntegrationTest(),
				new LogLevelTest(),
				new LogTargetLevelTest(),
				new LogSetupTest(),
				new LogMessageFormatterTest(),
				new SWFInfoTest(),
				new FlexIntegrationTest(),
				new SimpleTargetSetupTest(),
				new LeveledTargetSetupTest(),
				new FlexSetupTest(),
				new FrameBufferTest(),
				new BufferTest(),
				new TextFieldTest(),
				new AirTargetTest(),
				new OSMFIntegrationTest(),
				new LogMeisterIntegrationTest()
			]);
		}
	}
}
