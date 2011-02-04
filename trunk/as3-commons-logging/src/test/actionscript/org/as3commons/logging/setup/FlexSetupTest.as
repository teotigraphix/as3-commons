/*
 * Copyright (c) 2008-2009 the original author or authors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package org.as3commons.logging.setup {
	
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.LoggerFactory;
	import org.as3commons.logging.Logger;
	import org.as3commons.logging.level.DEBUG;
	import org.as3commons.logging.level.ERROR;
	import org.as3commons.logging.level.FATAL;
	import org.as3commons.logging.level.INFO;
	import org.as3commons.logging.level.WARN;
	import org.as3commons.logging.setup.target.FlexLogTarget;
	import org.mockito.integrations.flexunit3.MockitoTestCase;

	import mx.logging.ILoggingTarget;
	import mx.logging.Log;
	import mx.logging.LogEvent;
	import mx.logging.LogEventLevel;
	import mx.logging.LogLogger;

	/**
	 * @author Martin Heidegger
	 */
	public class FlexSetupTest extends MockitoTestCase {
		public function FlexSetupTest() {
			super([ILoggingTarget]);
		}
		
		public function testDirectFallback(): void {
			
			var flexTarget: TestLoggingTarget = new TestLoggingTarget();
			
			Log.addTarget( flexTarget );
			
			var factory: LoggerFactory = new LoggerFactory(new SimpleTargetSetup( new FlexLogTarget() ));
			var loggerA: Logger = factory.getNamedLogger( "com.mux" ) as Logger;
			var loggerB: Logger = factory.getNamedLogger( "com.me.Example" ) as Logger;
			var loggerC: Logger = factory.getNamedLogger( "com.ma.rup" ) as Logger;
			var loggerD: Logger = factory.getNamedLogger( "com.ma.sup" ) as Logger;
			loggerA.debugTarget.log( "com.mux", "mux", DEBUG, 123, "hello {0}", ["world"]);
			loggerB.infoTarget.log( "com.me.Example", "Example", INFO, 123, "{0} {1}", ["hello","world"] );
			loggerC.warnTarget.log( "com.ma.rup", "rup", WARN, 123, "{0} world", ["hello"] );
			loggerD.errorTarget.log( "com.ma.sup", "sup", ERROR, 123, "{1} {0}", ["world","hello"] );
			loggerC.fatalTarget.log( "com.ma.rup", "rup", FATAL, 123, "hello world", [] );
			
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
	
	public function TestLoggingTarget() {}
	
	override public function logEvent(event:LogEvent):void {
		events.push( event );
	}
}