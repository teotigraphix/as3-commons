package org.as3commons.logging {

	import flexunit.framework.Assert;
	/**
	 * @author Martin
	 */
	public class LogLevelTest extends Assert {

		[Test]
		public function testAll():void {
			var level: LogLevel = LogLevel.ALL;
			assertTrue( level.matches(LogLevel.DEBUG));
			assertTrue( level.matches(LogLevel.DEBUG_ONLY));
			assertTrue( level.matches(LogLevel.INFO));
			assertTrue( level.matches(LogLevel.INFO_ONLY));
			assertTrue( level.matches(LogLevel.WARN));
			assertTrue( level.matches(LogLevel.WARN_ONLY));
			assertTrue( level.matches(LogLevel.ERROR));
			assertTrue( level.matches(LogLevel.ERROR_ONLY));
			assertTrue( level.matches(LogLevel.FATAL));
			assertTrue( level.matches(LogLevel.FATAL_ONLY));
			assertTrue( level.matches(LogLevel.NONE));
		}
		
		[Test]
		public function testDebug():void {
			var level: LogLevel = LogLevel.DEBUG;
			assertTrue( level.matches(LogLevel.DEBUG));
			assertTrue( level.matches(LogLevel.DEBUG_ONLY));
			assertTrue( level.matches(LogLevel.INFO));
			assertTrue( level.matches(LogLevel.INFO_ONLY));
			assertTrue( level.matches(LogLevel.WARN));
			assertTrue( level.matches(LogLevel.WARN_ONLY));
			assertTrue( level.matches(LogLevel.ERROR));
			assertTrue( level.matches(LogLevel.ERROR_ONLY));
			assertTrue( level.matches(LogLevel.FATAL));
			assertTrue( level.matches(LogLevel.FATAL_ONLY));
			assertTrue( level.matches(LogLevel.NONE));
		}
		
		[Test]
		public function testInfo():void {
			var level: LogLevel = LogLevel.INFO;
			assertFalse( level.matches(LogLevel.DEBUG));
			assertFalse( level.matches(LogLevel.DEBUG_ONLY));
			assertTrue( level.matches(LogLevel.INFO));
			assertTrue( level.matches(LogLevel.INFO_ONLY));
			assertTrue( level.matches(LogLevel.WARN));
			assertTrue( level.matches(LogLevel.WARN_ONLY));
			assertTrue( level.matches(LogLevel.ERROR));
			assertTrue( level.matches(LogLevel.ERROR_ONLY));
			assertTrue( level.matches(LogLevel.FATAL));
			assertTrue( level.matches(LogLevel.FATAL_ONLY));
			assertTrue( level.matches(LogLevel.NONE));
		}
		
		[Test]
		public function testWarn():void {
			var level: LogLevel = LogLevel.WARN;
			assertFalse( level.matches(LogLevel.DEBUG));
			assertFalse( level.matches(LogLevel.DEBUG_ONLY));
			assertFalse( level.matches(LogLevel.INFO));
			assertFalse( level.matches(LogLevel.INFO_ONLY));
			assertTrue( level.matches(LogLevel.WARN));
			assertTrue( level.matches(LogLevel.WARN_ONLY));
			assertTrue( level.matches(LogLevel.ERROR));
			assertTrue( level.matches(LogLevel.ERROR_ONLY));
			assertTrue( level.matches(LogLevel.FATAL));
			assertTrue( level.matches(LogLevel.FATAL_ONLY));
			assertTrue( level.matches(LogLevel.NONE));
		}
		
		[Test]
		public function testError():void {
			var level: LogLevel = LogLevel.ERROR;
			assertFalse( level.matches(LogLevel.DEBUG));
			assertFalse( level.matches(LogLevel.DEBUG_ONLY));
			assertFalse( level.matches(LogLevel.INFO));
			assertFalse( level.matches(LogLevel.INFO_ONLY));
			assertFalse( level.matches(LogLevel.WARN));
			assertFalse( level.matches(LogLevel.WARN_ONLY));
			assertTrue( level.matches(LogLevel.ERROR));
			assertTrue( level.matches(LogLevel.ERROR_ONLY));
			assertTrue( level.matches(LogLevel.FATAL));
			assertTrue( level.matches(LogLevel.FATAL_ONLY));
			assertTrue( level.matches(LogLevel.NONE));
		}
		
		[Test]
		public function testFatal():void {
			var level: LogLevel = LogLevel.FATAL;
			assertFalse( level.matches(LogLevel.DEBUG));
			assertFalse( level.matches(LogLevel.DEBUG_ONLY));
			assertFalse( level.matches(LogLevel.INFO));
			assertFalse( level.matches(LogLevel.INFO_ONLY));
			assertFalse( level.matches(LogLevel.WARN));
			assertFalse( level.matches(LogLevel.WARN_ONLY));
			assertFalse( level.matches(LogLevel.ERROR));
			assertFalse( level.matches(LogLevel.ERROR_ONLY));
			assertTrue( level.matches(LogLevel.FATAL));
			assertTrue( level.matches(LogLevel.FATAL_ONLY));
			assertTrue( level.matches(LogLevel.NONE));
		}
		
		[Test]
		public function testNone():void {
			var level: LogLevel = LogLevel.NONE;
			assertFalse( level.matches(LogLevel.DEBUG));
			assertFalse( level.matches(LogLevel.DEBUG_ONLY));
			assertFalse( level.matches(LogLevel.INFO));
			assertFalse( level.matches(LogLevel.INFO_ONLY));
			assertFalse( level.matches(LogLevel.WARN));
			assertFalse( level.matches(LogLevel.WARN_ONLY));
			assertFalse( level.matches(LogLevel.ERROR));
			assertFalse( level.matches(LogLevel.ERROR_ONLY));
			assertFalse( level.matches(LogLevel.FATAL));
			assertFalse( level.matches(LogLevel.FATAL_ONLY));
			assertTrue( level.matches(LogLevel.NONE));
		}
	}
}
