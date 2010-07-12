package org.as3commons.logging {
	import org.as3commons.logging.integration.FlexIntegrationTest;
	import org.as3commons.logging.level.DEBUG;
	import org.as3commons.logging.setup.ComplexSetupTest;
	import org.as3commons.logging.setup.FlexSetupTest;
	import org.as3commons.logging.setup.TargetSetupTest;
	import org.as3commons.logging.setup.target.BufferTest;
	import org.as3commons.logging.setup.target.FrameBufferTest;
	import org.as3commons.logging.setup.target.MergedTest;
	import org.as3commons.logging.setup.target.SWFInfoTest;
	import org.as3commons.logging.setup.target.TextFieldTest;
	import org.as3commons.logging.setup.target.TraceTarget;
	import org.as3commons.logging.util.LogMessageFormatter;
	import org.as3commons.logging.util.LogMessageFormatterTest;
	import org.as3commons.logging.util.SWFInfo;
	import org.as3commons.logging.util.toLogName;
	import org.flexunit.internals.TraceListener;
	import org.flexunit.runner.FlexUnitCore;

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
		
		private static const debugs: LogLevel = DEBUG;
		
		private const debugp: LogLevel = DEBUG;
		
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
			
			trace(  0
					+ getSize(mx.logging.ILogger)
					+ getSize(ILoggingTarget)
					+ getSize(Log)
					+ getSize(LogEvent)
					+ getSize(LogEventLevel)
					+ getSize(LogLogger)
					+ getSize(AbstractTarget)
					+ getSize(InvalidCategoryError)
					+ getSize(InvalidFilterError)
					+ getSize(mx.logging.targets.TraceTarget)
			);
			trace(  0
					+ getSize(org.as3commons.logging.ILogger)
					+ getSize(ILogSetup)
					+ getSize(LoggerFactory)
					+ getSize(Logger)
					+ getSize(LogLevel)
					+ getSize(LogSetupLevel)
					+ getSize(getLogger)
					+ getSize(toLogName)
					+ getSize(org.as3commons.logging.setup.target.TraceTarget)
					+ getSize(LogMessageFormatter)
					+ getSize(SWFInfo)
			);
			
			var core: FlexUnitCore = new FlexUnitCore();
			core.addListener( new TraceListener() );
			core.run( [
				new LogLevelTest(),
				new LogTargetLevelTest(),
				new LogSetupTest(),
				new LogMessageFormatterTest(),
				new SWFInfoTest(),
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
