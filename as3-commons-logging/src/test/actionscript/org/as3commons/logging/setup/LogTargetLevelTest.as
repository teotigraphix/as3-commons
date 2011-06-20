package org.as3commons.logging.setup {
	import org.as3commons.logging.setup.target.TRACE_TARGET;
	import org.as3commons.logging.setup.target.TextFieldTarget;
	import org.as3commons.logging.Logger;
	import flexunit.framework.Assert;

	/**
	 * @author mh
	 */
	public class LogTargetLevelTest extends Assert {
		
		private const testTarget : ILogTarget = TRACE_TARGET;
		
		public function LogTargetLevelTest() {}
		
		[Test]
		public function testDebug():void {
			var level: LogSetupLevel = LogSetupLevel.DEBUG;
			var logger: Logger = new Logger("");
			assertEquals( level.valueOf(), 0x3F );
			assertStrictlyEquals( level, LogSetupLevel.getLevelByValue( level.valueOf() ) );
			assertStrictlyEquals( level, LogSetupLevel.ALL);
			assertStrictlyEquals( level.or( LogSetupLevel.ERROR ), level );
			assertStrictlyEquals( level.or( level ), level );
			level.applyTo(logger, testTarget);
			assertTrue( logger.debugTarget == testTarget );
			assertTrue( logger.infoTarget == testTarget );
			assertTrue( logger.warnTarget == testTarget );
			assertTrue( logger.errorTarget == testTarget );
			assertTrue( logger.fatalTarget == testTarget );
		}
		
		[Test]
		public function testDebugOnly():void {
			var level: LogSetupLevel = LogSetupLevel.DEBUG_ONLY;
			var logger: Logger = new Logger("");
			assertEquals( level.valueOf(), 0x20 );
			assertStrictlyEquals( level, LogSetupLevel.getLevelByValue( level.valueOf() ) );
			assertStrictlyEquals( level.or( LogSetupLevel.ERROR ), LogSetupLevel.getLevelByValue( level.valueOf() | LogSetupLevel.ERROR.valueOf() ) );
			assertStrictlyEquals( level.or( level ), level );
			level.applyTo( logger, testTarget);
			assertTrue( logger.debugTarget == testTarget );
			assertTrue( logger.infoTarget != testTarget );
			assertTrue( logger.warnTarget != testTarget );
			assertTrue( logger.errorTarget != testTarget );
			assertTrue( logger.fatalTarget != testTarget );
		}
		
		[Test]
		public function testInfo():void {
			var level: LogSetupLevel = LogSetupLevel.INFO;
			var logger: Logger = new Logger("");
			assertEquals( level.valueOf(), 0x1F );
			assertStrictlyEquals( level, LogSetupLevel.getLevelByValue( level.valueOf() ) );
			assertStrictlyEquals( level.or( LogSetupLevel.DEBUG ), LogSetupLevel.DEBUG );
			assertStrictlyEquals( level.or( LogSetupLevel.WARN), level );
			assertStrictlyEquals( level.or( level ), level );
			level.applyTo( logger, testTarget);
			assertTrue( logger.debugTarget != testTarget );
			assertTrue( logger.infoTarget == testTarget );
			assertTrue( logger.warnTarget == testTarget );
			assertTrue( logger.errorTarget == testTarget );
			assertTrue( logger.fatalTarget == testTarget );
		}
		
		[Test]
		public function testInfoOnly():void {
			var level: LogSetupLevel = LogSetupLevel.INFO_ONLY;
			var logger: Logger = new Logger("");
			assertEquals( level.valueOf(), 0x10 );
			assertStrictlyEquals( level, LogSetupLevel.getLevelByValue( level.valueOf() ) );
			assertStrictlyEquals( level.or( level ), level );
			level.applyTo( logger, testTarget);
			assertTrue( logger.debugTarget != testTarget );
			assertTrue( logger.infoTarget == testTarget );
			assertTrue( logger.warnTarget != testTarget );
			assertTrue( logger.errorTarget != testTarget );
			assertTrue( logger.fatalTarget != testTarget );
		}
		
		[Test]
		public function testWarn():void {
			var level: LogSetupLevel = LogSetupLevel.WARN;
			var logger: Logger = new Logger("");
			assertEquals( level.valueOf(), 0x0F );
			assertStrictlyEquals( level, LogSetupLevel.getLevelByValue( level.valueOf() ) );
			assertStrictlyEquals( level.or( LogSetupLevel.INFO ), LogSetupLevel.INFO );
			assertStrictlyEquals( level.or( LogSetupLevel.ERROR), level );
			assertStrictlyEquals( level.or( level ), level );
			level.applyTo( logger, testTarget);
			assertTrue( logger.debugTarget != testTarget );
			assertTrue( logger.infoTarget != testTarget );
			assertTrue( logger.warnTarget == testTarget );
			assertTrue( logger.errorTarget == testTarget );
			assertTrue( logger.fatalTarget == testTarget );
		}
		
		[Test]
		public function testWarnOnly():void {
			var level: LogSetupLevel = LogSetupLevel.WARN_ONLY;
			var logger: Logger = new Logger("");
			assertEquals( level.valueOf(), 0x08 );
			assertStrictlyEquals( level, LogSetupLevel.getLevelByValue( level.valueOf() ) );
			assertStrictlyEquals( level.or( level ), level );
			level.applyTo( logger, testTarget);
			assertTrue( logger.debugTarget != testTarget );
			assertTrue( logger.infoTarget != testTarget );
			assertTrue( logger.warnTarget == testTarget );
			assertTrue( logger.errorTarget != testTarget );
			assertTrue( logger.fatalTarget != testTarget );
		}
		
		[Test]
		public function testError():void {
			var level: LogSetupLevel = LogSetupLevel.ERROR;
			var logger: Logger = new Logger("");
			assertEquals( level.valueOf(), 0x07 );
			assertStrictlyEquals( level, LogSetupLevel.getLevelByValue( level.valueOf() ) );
			assertStrictlyEquals( level.or( LogSetupLevel.WARN ), LogSetupLevel.WARN );
			assertStrictlyEquals( level.or( LogSetupLevel.FATAL), level );
			assertStrictlyEquals( level.or( level ), level );
			level.applyTo( logger, testTarget);
			assertTrue( logger.debugTarget != testTarget );
			assertTrue( logger.infoTarget != testTarget );
			assertTrue( logger.warnTarget != testTarget );
			assertTrue( logger.errorTarget == testTarget );
			assertTrue( logger.fatalTarget == testTarget );
		}
		
		[Test]
		public function testErrorOnly():void {
			var level: LogSetupLevel = LogSetupLevel.ERROR_ONLY;
			var logger: Logger = new Logger("");
			assertEquals( level.valueOf(), 0x04 );
			assertStrictlyEquals( level, LogSetupLevel.getLevelByValue( level.valueOf() ) );
			assertStrictlyEquals( level.or( level ), level );
			level.applyTo( logger, testTarget );
			assertTrue( logger.debugTarget != testTarget );
			assertTrue( logger.infoTarget != testTarget );
			assertTrue( logger.warnTarget != testTarget );
			assertTrue( logger.errorTarget == testTarget );
			assertTrue( logger.fatalTarget != testTarget );
		}
		
		[Test]
		public function testFatal():void {
			var level: LogSetupLevel = LogSetupLevel.FATAL;
			var logger: Logger = new Logger("");
			assertEquals( level.valueOf(), 0x03 );
			assertStrictlyEquals( level, LogSetupLevel.getLevelByValue( level.valueOf() ) );
			assertStrictlyEquals( level.or( LogSetupLevel.ERROR ), LogSetupLevel.ERROR );
			assertStrictlyEquals( level.or( LogSetupLevel.NONE), level );
			assertStrictlyEquals( level.or( level ), level );
			level.applyTo( logger, testTarget);
			assertTrue( logger.debugTarget != testTarget );
			assertTrue( logger.infoTarget != testTarget );
			assertTrue( logger.warnTarget != testTarget );
			assertTrue( logger.errorTarget != testTarget );
			assertTrue( logger.fatalTarget == testTarget );
		}
		
		[Test]
		public function testFatalOnly():void {
			var level: LogSetupLevel = LogSetupLevel.FATAL_ONLY;
			var logger: Logger = new Logger("");
			assertEquals( level.valueOf(), 0x02 );
			assertStrictlyEquals( level, LogSetupLevel.getLevelByValue( level.valueOf() ) );
			assertStrictlyEquals( level.or( level ), level );
			level.applyTo( logger, testTarget);
			assertTrue( logger.debugTarget != testTarget );
			assertTrue( logger.infoTarget != testTarget );
			assertTrue( logger.warnTarget != testTarget );
			assertTrue( logger.errorTarget != testTarget );
			assertTrue( logger.fatalTarget == testTarget );
		}
		
		[Test]
		public function testNone():void {
			var level: LogSetupLevel = LogSetupLevel.NONE;
			var logger: Logger = new Logger("");
			assertEquals( level.valueOf(), 0x01 );
			assertStrictlyEquals( level, LogSetupLevel.getLevelByValue( level.valueOf() ) );
			assertStrictlyEquals( level.or( LogSetupLevel.FATAL ), LogSetupLevel.FATAL );
			assertStrictlyEquals( level.or( level ), level );
			level.applyTo( logger, testTarget);
			assertTrue( logger.debugTarget != testTarget );
			assertTrue( logger.infoTarget != testTarget );
			assertTrue( logger.warnTarget != testTarget );
			assertTrue( logger.errorTarget != testTarget );
			assertTrue( logger.fatalTarget != testTarget );
		}
		
		[Test]
		public function testApply():void {
			var logger: Logger = new Logger("name");
			var targetA: ILogTarget = new TextFieldTarget;
			var targetB: ILogTarget = new TextFieldTarget;
			
			logger.allTargets = targetA;
			
			LogSetupLevel.ERROR_ONLY.applyTo(logger, targetB);
			
			assertEquals( logger.errorTarget, targetB );
			assertEquals( logger.debugTarget, targetA );
			assertEquals( logger.fatalTarget, targetA );
			assertEquals( logger.infoTarget, targetA );
			assertEquals( logger.warnTarget, targetA );
			
			logger.allTargets = targetA;
			
			LogSetupLevel.WARN_ONLY.applyTo(logger, targetB);
			
			assertEquals( logger.errorTarget, targetA );
			assertEquals( logger.debugTarget, targetA );
			assertEquals( logger.fatalTarget, targetA );
			assertEquals( logger.infoTarget, targetA );
			assertEquals( logger.warnTarget, targetB );
			
			logger.allTargets = targetA;
			
			LogSetupLevel.INFO_ONLY.applyTo(logger, targetB);
			
			assertEquals( logger.errorTarget, targetA );
			assertEquals( logger.debugTarget, targetA );
			assertEquals( logger.fatalTarget, targetA );
			assertEquals( logger.infoTarget, targetB );
			assertEquals( logger.warnTarget, targetA );
			
			logger.allTargets = targetA;
			
			LogSetupLevel.DEBUG_ONLY.applyTo(logger, targetB);
			
			assertEquals( logger.errorTarget, targetA );
			assertEquals( logger.debugTarget, targetB );
			assertEquals( logger.fatalTarget, targetA );
			assertEquals( logger.infoTarget, targetA );
			assertEquals( logger.warnTarget, targetA );
			
			logger.allTargets = targetA;
			
			LogSetupLevel.FATAL_ONLY.applyTo(logger, targetB);
			
			assertEquals( logger.errorTarget, targetA );
			assertEquals( logger.debugTarget, targetA );
			assertEquals( logger.fatalTarget, targetB );
			assertEquals( logger.infoTarget, targetA );
			assertEquals( logger.warnTarget, targetA );
		}
	}
}
