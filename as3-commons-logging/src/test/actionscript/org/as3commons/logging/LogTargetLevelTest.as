package org.as3commons.logging {
	import flexunit.framework.Assert;

	/**
	 * @author mh
	 */
	public class LogTargetLevelTest extends Assert {
		
		[Test]
		public function testDebug():void {
			var level: LogTargetLevel = LogTargetLevel.DEBUG;
			assertEquals( level.value, 0x3F );
			assertStrictlyEquals( level, LogTargetLevel.getLevelByValue( level.value ) );
			assertStrictlyEquals( level, LogTargetLevel.ALL);
			assertStrictlyEquals( level.or( LogTargetLevel.ERROR ), level );
			assertStrictlyEquals( level.or( level ), level );
			assertTrue( level.matches( LogLevel.DEBUG ) );
			assertTrue( level.matches( LogLevel.INFO ) );
			assertTrue( level.matches( LogLevel.WARN ) );
			assertTrue( level.matches( LogLevel.ERROR ) );
			assertTrue( level.matches( LogLevel.FATAL ) );
		}
		
		[Test]
		public function testDebugOnly():void {
			var level: LogTargetLevel = LogTargetLevel.DEBUG_ONLY;
			assertEquals( level.value, 0x20 );
			assertStrictlyEquals( level, LogTargetLevel.getLevelByValue( level.value ) );
			assertStrictlyEquals( level.or( LogTargetLevel.ERROR ), LogTargetLevel.getLevelByValue( level.value | LogTargetLevel.ERROR.value ) );
			assertStrictlyEquals( level.or( level ), level );
			assertTrue( level.matches( LogLevel.DEBUG ) );
			assertFalse( level.matches( LogLevel.INFO ) );
			assertFalse( level.matches( LogLevel.WARN ) );
			assertFalse( level.matches( LogLevel.ERROR ) );
			assertFalse( level.matches( LogLevel.FATAL ) );
		}
		
		[Test]
		public function testInfo():void {
			var level: LogTargetLevel = LogTargetLevel.INFO;
			assertEquals( level.value, 0x1F );
			assertStrictlyEquals( level, LogTargetLevel.getLevelByValue( level.value ) );
			assertStrictlyEquals( level.or( LogTargetLevel.DEBUG ), LogTargetLevel.DEBUG );
			assertStrictlyEquals( level.or( LogTargetLevel.WARN), level );
			assertStrictlyEquals( level.or( level ), level );
			assertFalse( level.matches( LogLevel.DEBUG ) );
			assertTrue( level.matches( LogLevel.INFO ) );
			assertTrue( level.matches( LogLevel.WARN ) );
			assertTrue( level.matches( LogLevel.ERROR ) );
			assertTrue( level.matches( LogLevel.FATAL ) );
		}
		
		[Test]
		public function testInfoOnly():void {
			var level: LogTargetLevel = LogTargetLevel.INFO_ONLY;
			assertEquals( level.value, 0x10 );
			assertStrictlyEquals( level, LogTargetLevel.getLevelByValue( level.value ) );
			assertStrictlyEquals( level.or( level ), level );
			assertFalse( level.matches( LogLevel.DEBUG ) );
			assertTrue( level.matches( LogLevel.INFO ) );
			assertFalse( level.matches( LogLevel.WARN ) );
			assertFalse( level.matches( LogLevel.ERROR ) );
			assertFalse( level.matches( LogLevel.FATAL ) );
		}
		
		[Test]
		public function testWarn():void {
			var level: LogTargetLevel = LogTargetLevel.WARN;
			assertEquals( level.value, 0x0F );
			assertStrictlyEquals( level, LogTargetLevel.getLevelByValue( level.value ) );
			assertStrictlyEquals( level.or( LogTargetLevel.INFO ), LogTargetLevel.INFO );
			assertStrictlyEquals( level.or( LogTargetLevel.ERROR), level );
			assertStrictlyEquals( level.or( level ), level );
			assertFalse( level.matches( LogLevel.DEBUG ) );
			assertFalse( level.matches( LogLevel.INFO ) );
			assertTrue( level.matches( LogLevel.WARN ) );
			assertTrue( level.matches( LogLevel.ERROR ) );
			assertTrue( level.matches( LogLevel.FATAL ) );
		}
		
		[Test]
		public function testWarnOnly():void {
			var level: LogTargetLevel = LogTargetLevel.WARN_ONLY;
			assertEquals( level.value, 0x08 );
			assertStrictlyEquals( level, LogTargetLevel.getLevelByValue( level.value ) );
			assertStrictlyEquals( level.or( level ), level );
			assertFalse( level.matches( LogLevel.DEBUG ) );
			assertFalse( level.matches( LogLevel.INFO ) );
			assertTrue( level.matches( LogLevel.WARN ) );
			assertFalse( level.matches( LogLevel.ERROR ) );
			assertFalse( level.matches( LogLevel.FATAL ) );
		}
		
		[Test]
		public function testError():void {
			var level: LogTargetLevel = LogTargetLevel.ERROR;
			assertEquals( level.value, 0x07 );
			assertStrictlyEquals( level, LogTargetLevel.getLevelByValue( level.value ) );
			assertStrictlyEquals( level.or( LogTargetLevel.WARN ), LogTargetLevel.WARN );
			assertStrictlyEquals( level.or( LogTargetLevel.FATAL), level );
			assertStrictlyEquals( level.or( level ), level );
			assertFalse( level.matches( LogLevel.DEBUG ) );
			assertFalse( level.matches( LogLevel.INFO ) );
			assertFalse( level.matches( LogLevel.WARN ) );
			assertTrue( level.matches( LogLevel.ERROR ) );
			assertTrue( level.matches( LogLevel.FATAL ) );
		}
		
		[Test]
		public function testErrorOnly():void {
			var level: LogTargetLevel = LogTargetLevel.ERROR_ONLY;
			assertEquals( level.value, 0x04 );
			assertStrictlyEquals( level, LogTargetLevel.getLevelByValue( level.value ) );
			assertStrictlyEquals( level.or( level ), level );
			assertFalse( level.matches( LogLevel.DEBUG ) );
			assertFalse( level.matches( LogLevel.INFO ) );
			assertFalse( level.matches( LogLevel.WARN ) );
			assertTrue( level.matches( LogLevel.ERROR ) );
			assertFalse( level.matches( LogLevel.FATAL ) );
		}
		
		[Test]
		public function testFatal():void {
			var level: LogTargetLevel = LogTargetLevel.FATAL;
			assertEquals( level.value, 0x03 );
			assertStrictlyEquals( level, LogTargetLevel.getLevelByValue( level.value ) );
			assertStrictlyEquals( level.or( LogTargetLevel.ERROR ), LogTargetLevel.ERROR );
			assertStrictlyEquals( level.or( LogTargetLevel.NONE), level );
			assertStrictlyEquals( level.or( level ), level );
			assertFalse( level.matches( LogLevel.DEBUG ) );
			assertFalse( level.matches( LogLevel.INFO ) );
			assertFalse( level.matches( LogLevel.WARN ) );
			assertFalse( level.matches( LogLevel.ERROR ) );
			assertTrue( level.matches( LogLevel.FATAL ) );
		}
		
		[Test]
		public function testFatalOnly():void {
			var level: LogTargetLevel = LogTargetLevel.FATAL_ONLY;
			assertEquals( level.value, 0x02 );
			assertStrictlyEquals( level, LogTargetLevel.getLevelByValue( level.value ) );
			assertStrictlyEquals( level.or( level ), level );
			assertFalse( level.matches( LogLevel.DEBUG ) );
			assertFalse( level.matches( LogLevel.INFO ) );
			assertFalse( level.matches( LogLevel.WARN ) );
			assertFalse( level.matches( LogLevel.ERROR ) );
			assertTrue( level.matches( LogLevel.FATAL ) );
		}
		
		[Test]
		public function testNone():void {
			var level: LogTargetLevel = LogTargetLevel.NONE;
			assertEquals( level.value, 0x01 );
			assertStrictlyEquals( level, LogTargetLevel.getLevelByValue( level.value ) );
			assertStrictlyEquals( level.or( LogTargetLevel.FATAL ), LogTargetLevel.FATAL );
			assertStrictlyEquals( level.or( level ), level );
			assertFalse( level.matches( LogLevel.DEBUG ) );
			assertFalse( level.matches( LogLevel.INFO ) );
			assertFalse( level.matches( LogLevel.WARN ) );
			assertFalse( level.matches( LogLevel.ERROR ) );
			assertFalse( level.matches( LogLevel.FATAL ) );
		}
	}
}
