package org.as3commons.logging {
	import org.as3commons.logging.util.LEVEL_NAMES;
	import flexunit.framework.Assert;
	import org.as3commons.logging.level.DEBUG;
	import org.as3commons.logging.level.ERROR;
	import org.as3commons.logging.level.FATAL;
	import org.as3commons.logging.level.INFO;
	import org.as3commons.logging.level.WARN;
	import org.as3commons.logging.util.levelToName;


	/**
	 * @author Martin
	 */
	public class LogLevelTest extends Assert {
		
		[Test]
		public function testDebug():void {
			var level: int = DEBUG;
			assertEquals( levelToName(level), "DEBUG" );
			assertEquals( LEVEL_NAMES[level], "DEBUG" );
			assertEquals( level, 0x20 );
		}
		
		[Test]
		public function testInfo():void {
			var level: int = INFO;
			assertEquals( levelToName(level), "INFO" );
			assertEquals( LEVEL_NAMES[level], "INFO" );
			assertEquals( level, 0x10 );
		}
		
		[Test]
		public function testWarn():void {
			var level: int = WARN;
			assertEquals( levelToName(level), "WARN" );
			assertEquals( LEVEL_NAMES[level], "WARN" );
			assertEquals( level, 0x08 );
		}
		
		[Test]
		public function testError():void {
			var level: int = ERROR;
			assertEquals( levelToName(level), "ERROR" );
			assertEquals( LEVEL_NAMES[level], "ERROR" );
			assertEquals( level, 0x04 );
		}
		
		[Test]
		public function testFatal():void {
			var level: int = FATAL;
			assertEquals( levelToName(level), "FATAL" );
			assertEquals( LEVEL_NAMES[level], "FATAL" );
			assertEquals( level, 0x02 );
		}
	}
}
