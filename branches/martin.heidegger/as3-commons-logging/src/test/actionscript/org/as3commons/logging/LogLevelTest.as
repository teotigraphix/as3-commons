package org.as3commons.logging {
	import flexunit.framework.Assert;

	/**
	 * @author Martin
	 */
	public class LogLevelTest extends Assert {
		
		[Test]
		public function testDebug():void {
			var level: LogLevel = LogLevel.DEBUG;
			assertEquals( level.name, "DEBUG" );
			assertEquals( level.value, 0x20 );
		}
		
		[Test]
		public function testInfo():void {
			var level: LogLevel = LogLevel.INFO;
			assertEquals( level.name, "INFO" );
			assertEquals( level.value, 0x10 );
		}
		
		[Test]
		public function testWarn():void {
			var level: LogLevel = LogLevel.WARN;
			assertEquals( level.name, "WARN" );
			assertEquals( level.value, 0x08 );
		}
		
		[Test]
		public function testError():void {
			var level: LogLevel = LogLevel.ERROR;
			assertEquals( level.name, "ERROR" );
			assertEquals( level.value, 0x04 );
		}
		
		[Test]
		public function testFatal():void {
			var level: LogLevel = LogLevel.FATAL;
			assertEquals( level.name, "FATAL" );
			assertEquals( level.value, 0x02 );
		}
	}
}
