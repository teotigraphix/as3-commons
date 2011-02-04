package org.as3commons.logging {
	import flexunit.framework.Assert;

	import org.as3commons.logging.level.DEBUG;
	import org.as3commons.logging.level.ERROR;
	import org.as3commons.logging.level.FATAL;
	import org.as3commons.logging.level.INFO;
	import org.as3commons.logging.level.WARN;

	/**
	 * @author Martin
	 */
	public class LogLevelTest extends Assert {
		
		[Test]
		public function testDebug():void {
			var level: LogLevel = DEBUG;
			assertEquals( level.name, "DEBUG" );
			assertEquals( level.valueOf(), 0x20 );
		}
		
		[Test]
		public function testInfo():void {
			var level: LogLevel = INFO;
			assertEquals( level.name, "INFO" );
			assertEquals( level.valueOf(), 0x10 );
		}
		
		[Test]
		public function testWarn():void {
			var level: LogLevel = WARN;
			assertEquals( level.name, "WARN" );
			assertEquals( level.valueOf(), 0x08 );
		}
		
		[Test]
		public function testError():void {
			var level: LogLevel = ERROR;
			assertEquals( level.name, "ERROR" );
			assertEquals( level.valueOf(), 0x04 );
		}
		
		[Test]
		public function testFatal():void {
			var level: LogLevel = FATAL;
			assertEquals( level.name, "FATAL" );
			assertEquals( level.valueOf(), 0x02 );
		}
	}
}
