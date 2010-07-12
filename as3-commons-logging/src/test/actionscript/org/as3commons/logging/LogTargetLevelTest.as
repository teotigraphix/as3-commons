package org.as3commons.logging {
	import flexunit.framework.Assert;

	import org.as3commons.logging.level.DEBUG;
	import org.as3commons.logging.level.ERROR;
	import org.as3commons.logging.level.FATAL;
	import org.as3commons.logging.level.INFO;
	import org.as3commons.logging.level.WARN;

	/**
	 * @author mh
	 */
	public class LogTargetLevelTest extends Assert {
		
		[Test]
		public function testDebug():void {
			var level: LogSetupLevel = LogSetupLevel.DEBUG;
			assertEquals( level.value, 0x3F );
			assertStrictlyEquals( level, LogSetupLevel.getLevelByValue( level.value ) );
			assertStrictlyEquals( level, LogSetupLevel.ALL);
			assertStrictlyEquals( level.or( LogSetupLevel.ERROR ), level );
			assertStrictlyEquals( level.or( level ), level );
			assertTrue( level.matches( DEBUG ) );
			assertTrue( level.matches( INFO ) );
			assertTrue( level.matches( WARN ) );
			assertTrue( level.matches( ERROR ) );
			assertTrue( level.matches( FATAL ) );
		}
		
		[Test]
		public function testDebugOnly():void {
			var level: LogSetupLevel = LogSetupLevel.DEBUG_ONLY;
			assertEquals( level.value, 0x20 );
			assertStrictlyEquals( level, LogSetupLevel.getLevelByValue( level.value ) );
			assertStrictlyEquals( level.or( LogSetupLevel.ERROR ), LogSetupLevel.getLevelByValue( level.value | LogSetupLevel.ERROR.value ) );
			assertStrictlyEquals( level.or( level ), level );
			assertTrue( level.matches( DEBUG ) );
			assertFalse( level.matches( INFO ) );
			assertFalse( level.matches( WARN ) );
			assertFalse( level.matches( ERROR ) );
			assertFalse( level.matches( FATAL ) );
		}
		
		[Test]
		public function testInfo():void {
			var level: LogSetupLevel = LogSetupLevel.INFO;
			assertEquals( level.value, 0x1F );
			assertStrictlyEquals( level, LogSetupLevel.getLevelByValue( level.value ) );
			assertStrictlyEquals( level.or( LogSetupLevel.DEBUG ), LogSetupLevel.DEBUG );
			assertStrictlyEquals( level.or( LogSetupLevel.WARN), level );
			assertStrictlyEquals( level.or( level ), level );
			assertFalse( level.matches( DEBUG ) );
			assertTrue( level.matches( INFO ) );
			assertTrue( level.matches( WARN ) );
			assertTrue( level.matches( ERROR ) );
			assertTrue( level.matches( FATAL ) );
		}
		
		[Test]
		public function testInfoOnly():void {
			var level: LogSetupLevel = LogSetupLevel.INFO_ONLY;
			assertEquals( level.value, 0x10 );
			assertStrictlyEquals( level, LogSetupLevel.getLevelByValue( level.value ) );
			assertStrictlyEquals( level.or( level ), level );
			assertFalse( level.matches( DEBUG ) );
			assertTrue( level.matches( INFO ) );
			assertFalse( level.matches( WARN ) );
			assertFalse( level.matches( ERROR ) );
			assertFalse( level.matches( FATAL ) );
		}
		
		[Test]
		public function testWarn():void {
			var level: LogSetupLevel = LogSetupLevel.WARN;
			assertEquals( level.value, 0x0F );
			assertStrictlyEquals( level, LogSetupLevel.getLevelByValue( level.value ) );
			assertStrictlyEquals( level.or( LogSetupLevel.INFO ), LogSetupLevel.INFO );
			assertStrictlyEquals( level.or( LogSetupLevel.ERROR), level );
			assertStrictlyEquals( level.or( level ), level );
			assertFalse( level.matches( DEBUG ) );
			assertFalse( level.matches( INFO ) );
			assertTrue( level.matches( WARN ) );
			assertTrue( level.matches( ERROR ) );
			assertTrue( level.matches( FATAL ) );
		}
		
		[Test]
		public function testWarnOnly():void {
			var level: LogSetupLevel = LogSetupLevel.WARN_ONLY;
			assertEquals( level.value, 0x08 );
			assertStrictlyEquals( level, LogSetupLevel.getLevelByValue( level.value ) );
			assertStrictlyEquals( level.or( level ), level );
			assertFalse( level.matches( DEBUG ) );
			assertFalse( level.matches( INFO ) );
			assertTrue( level.matches( WARN ) );
			assertFalse( level.matches( ERROR ) );
			assertFalse( level.matches( FATAL ) );
		}
		
		[Test]
		public function testError():void {
			var level: LogSetupLevel = LogSetupLevel.ERROR;
			assertEquals( level.value, 0x07 );
			assertStrictlyEquals( level, LogSetupLevel.getLevelByValue( level.value ) );
			assertStrictlyEquals( level.or( LogSetupLevel.WARN ), LogSetupLevel.WARN );
			assertStrictlyEquals( level.or( LogSetupLevel.FATAL), level );
			assertStrictlyEquals( level.or( level ), level );
			assertFalse( level.matches( DEBUG ) );
			assertFalse( level.matches( INFO ) );
			assertFalse( level.matches( WARN ) );
			assertTrue( level.matches( ERROR ) );
			assertTrue( level.matches( FATAL ) );
		}
		
		[Test]
		public function testErrorOnly():void {
			var level: LogSetupLevel = LogSetupLevel.ERROR_ONLY;
			assertEquals( level.value, 0x04 );
			assertStrictlyEquals( level, LogSetupLevel.getLevelByValue( level.value ) );
			assertStrictlyEquals( level.or( level ), level );
			assertFalse( level.matches( DEBUG ) );
			assertFalse( level.matches( INFO ) );
			assertFalse( level.matches( WARN ) );
			assertTrue( level.matches( ERROR ) );
			assertFalse( level.matches( FATAL ) );
		}
		
		[Test]
		public function testFatal():void {
			var level: LogSetupLevel = LogSetupLevel.FATAL;
			assertEquals( level.value, 0x03 );
			assertStrictlyEquals( level, LogSetupLevel.getLevelByValue( level.value ) );
			assertStrictlyEquals( level.or( LogSetupLevel.ERROR ), LogSetupLevel.ERROR );
			assertStrictlyEquals( level.or( LogSetupLevel.NONE), level );
			assertStrictlyEquals( level.or( level ), level );
			assertFalse( level.matches( DEBUG ) );
			assertFalse( level.matches( INFO ) );
			assertFalse( level.matches( WARN ) );
			assertFalse( level.matches( ERROR ) );
			assertTrue( level.matches( FATAL ) );
		}
		
		[Test]
		public function testFatalOnly():void {
			var level: LogSetupLevel = LogSetupLevel.FATAL_ONLY;
			assertEquals( level.value, 0x02 );
			assertStrictlyEquals( level, LogSetupLevel.getLevelByValue( level.value ) );
			assertStrictlyEquals( level.or( level ), level );
			assertFalse( level.matches( DEBUG ) );
			assertFalse( level.matches( INFO ) );
			assertFalse( level.matches( WARN ) );
			assertFalse( level.matches( ERROR ) );
			assertTrue( level.matches( FATAL ) );
		}
		
		[Test]
		public function testNone():void {
			var level: LogSetupLevel = LogSetupLevel.NONE;
			assertEquals( level.value, 0x01 );
			assertStrictlyEquals( level, LogSetupLevel.getLevelByValue( level.value ) );
			assertStrictlyEquals( level.or( LogSetupLevel.FATAL ), LogSetupLevel.FATAL );
			assertStrictlyEquals( level.or( level ), level );
			assertFalse( level.matches( DEBUG ) );
			assertFalse( level.matches( INFO ) );
			assertFalse( level.matches( WARN ) );
			assertFalse( level.matches( ERROR ) );
			assertFalse( level.matches( FATAL ) );
		}
	}
}
