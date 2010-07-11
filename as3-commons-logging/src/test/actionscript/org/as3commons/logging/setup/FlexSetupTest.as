package org.as3commons.logging.setup {
	import mx.logging.LogLogger;
	import mx.logging.LogEventLevel;
	import org.as3commons.logging.LogLevel;
	import org.mockito.integrations.flexunit3.MockitoTestCase;

	import mx.logging.ILoggingTarget;
	import mx.logging.Log;
	import mx.logging.LogEvent;

	/**
	 * @author mh
	 */
	public class FlexSetupTest extends MockitoTestCase {
		public function FlexSetupTest() {
			super([ILoggingTarget]);
		}
		
		public function testDirectFallback(): void {
			
			var flexTarget: TestLoggingTarget = new TestLoggingTarget();
			
			Log.addTarget( flexTarget );
			
			var setup: FlexSetup = new FlexSetup();
			setup.getTarget( "com.mux" ).log( "pah", "pax", LogLevel.DEBUG, 123, "hello {0}", ["world"] );
			setup.getTarget( "com.me.Example" ).log( "pah", "pax", LogLevel.INFO, 123, "{0} {1}", ["hello","world"] );
			setup.getTarget( "com.ma.rup" ).log( "pah", "pax", LogLevel.WARN, 123, "{0} world", ["hello"] );
			setup.getTarget( "com.ma.sup" ).log( "pah", "pax", LogLevel.ERROR, 123, "{1} {0}", ["world","hello"] );
			setup.getTarget( "com.ma.rup" ).log( "pah", "pax", LogLevel.FATAL, 123, "hello world", [] );
			
			var event: LogEvent;
			
			assertEquals( flexTarget.events.length, 5);
			
			event = flexTarget.events[0];
			assertEquals( event.level, LogEventLevel.DEBUG );
			assertEquals( event.message, "hello world" );
			assertEquals( LogLogger( event.target ).category, "com.mux" );
			
			event = flexTarget.events[1];
			assertEquals( event.level, LogEventLevel.INFO );
			assertEquals( event.message, "hello world" );
			assertEquals( LogLogger( event.target ).category, "com.me.Example" );
			
			event = flexTarget.events[2];
			assertEquals( event.level, LogEventLevel.WARN );
			assertEquals( event.message, "hello world" );
			assertEquals( LogLogger( event.target ).category, "com.ma.rup" );
			
			event = flexTarget.events[3];
			assertEquals( event.level, LogEventLevel.ERROR );
			assertEquals( event.message, "hello world" );
			assertEquals( LogLogger( event.target ).category, "com.ma.sup" );
			
			event = flexTarget.events[4];
			assertEquals( event.level, LogEventLevel.FATAL );
			assertEquals( event.message, "hello world" );
			assertEquals( LogLogger( event.target ).category, "com.ma.rup" );
		}
	}
}

import mx.logging.AbstractTarget;
import mx.logging.LogEvent;

class TestLoggingTarget extends AbstractTarget {
	
	public var events: Array = [];
	
	override public function logEvent(event:LogEvent):void {
		events.push( event );
	}
}