package org.as3commons.logging.api {
	import org.as3commons.logging.level.FATAL;
	import org.as3commons.logging.level.ERROR;
	import org.as3commons.logging.level.WARN;
	import org.as3commons.logging.level.INFO;
	import flash.utils.getTimer;
	import org.as3commons.logging.level.DEBUG;
	import org.as3commons.logging.setup.target.TraceTarget;
	import flexunit.framework.TestCase;

	/**
	 * @author mh
	 */
	public class LoggerTest extends TestCase {

		public function LoggerTest() {}

		public function testLoggerConfiguration(): void {
			var logger: Logger = new Logger("a");
			assertFalse( logger.debugEnabled );
			assertFalse( logger.infoEnabled );
			assertFalse( logger.warnEnabled );
			assertFalse( logger.errorEnabled );
			assertFalse( logger.fatalEnabled );
			assertNull( logger.debugTarget );
			assertNull( logger.infoTarget );
			assertNull( logger.warnTarget );
			assertNull( logger.errorTarget );
			assertNull( logger.fatalTarget );
			assertEquals( "a", logger.name );
			assertNull( logger.person );
			assertEquals( "a", logger.shortName );
			assertEquals( "[Logger name='a']", logger.toString() );
			
			var target: TraceTarget = new TraceTarget();
			logger.allTargets = target;
			
			assertTrue( logger.debugEnabled );
			assertTrue( logger.infoEnabled );
			assertTrue( logger.warnEnabled );
			assertTrue( logger.errorEnabled );
			assertTrue( logger.fatalEnabled );
			assertEquals( target, logger.debugTarget );
			assertEquals( target, logger.infoTarget );
			assertEquals( target, logger.warnTarget );
			assertEquals( target, logger.errorTarget );
			assertEquals( target, logger.fatalTarget );
			
			logger.debugTarget = null;
			assertFalse( logger.debugEnabled );
			assertTrue( logger.infoEnabled );
			assertTrue( logger.warnEnabled );
			assertTrue( logger.errorEnabled );
			assertTrue( logger.fatalEnabled );
			assertNull( logger.debugTarget );
			assertEquals( target, logger.infoTarget );
			assertEquals( target, logger.warnTarget );
			assertEquals( target, logger.errorTarget );
			assertEquals( target, logger.fatalTarget );
			logger.allTargets = target;
			
			logger.infoTarget = null;
			assertTrue( logger.debugEnabled );
			assertFalse( logger.infoEnabled );
			assertTrue( logger.warnEnabled );
			assertTrue( logger.errorEnabled );
			assertTrue( logger.fatalEnabled );
			assertEquals( target, logger.debugTarget );
			assertNull( logger.infoTarget );
			assertEquals( target, logger.warnTarget );
			assertEquals( target, logger.errorTarget );
			assertEquals( target, logger.fatalTarget );
			logger.allTargets = target;
			
			logger.warnTarget = null;
			assertTrue( logger.debugEnabled );
			assertTrue( logger.infoEnabled );
			assertFalse( logger.warnEnabled );
			assertTrue( logger.errorEnabled );
			assertTrue( logger.fatalEnabled );
			assertEquals( target, logger.debugTarget );
			assertEquals( target, logger.infoTarget );
			assertNull( logger.warnTarget );
			assertEquals( target, logger.errorTarget );
			assertEquals( target, logger.fatalTarget );
			logger.allTargets = target;
			
			logger.errorTarget = null;
			assertTrue( logger.debugEnabled );
			assertTrue( logger.infoEnabled );
			assertTrue( logger.warnEnabled );
			assertFalse( logger.errorEnabled );
			assertTrue( logger.fatalEnabled );
			assertEquals( target, logger.debugTarget );
			assertEquals( target, logger.infoTarget );
			assertEquals( target, logger.warnTarget );
			assertNull( logger.errorTarget );
			assertEquals( target, logger.fatalTarget );
			logger.allTargets = target;
			
			logger.fatalTarget = null;
			assertTrue( logger.debugEnabled );
			assertTrue( logger.infoEnabled );
			assertTrue( logger.warnEnabled );
			assertTrue( logger.errorEnabled );
			assertFalse( logger.fatalEnabled );
			assertEquals( target, logger.debugTarget );
			assertEquals( target, logger.infoTarget );
			assertEquals( target, logger.warnTarget );
			assertEquals( target, logger.errorTarget );
			assertNull( logger.fatalTarget );
		}
		
		public function testShortName(): void {
			var logger: Logger;
			
			logger = new Logger("");
			assertEquals( "", logger.name );
			assertEquals( "", logger.shortName );
			
			logger = new Logger("\n\n\asdfadsf");
			assertEquals( "\n\n\asdfadsf", logger.name );
			assertEquals( "\n\n\asdfadsf", logger.shortName );
			
			logger = new Logger("...");
			assertEquals( "...", logger.name );
			assertEquals( "", logger.shortName );
			
			logger = new Logger("org.commons.logging");
			assertEquals( "org.commons.logging", logger.name );
			assertEquals( "logging", logger.shortName );
			
			logger = new Logger("10#\"!%&'()(=~\|'.commons.20#\"!%&'()(=~\|'");
			assertEquals( "10#\"!%&'()(=~\|'.commons.20#\"!%&'()(=~\|'", logger.name );
			assertEquals( "20#\"!%&'()(=~\|'", logger.shortName );
		}
		
		public function testDebug(): void {
			var logger: Logger = new Logger("my.log", "me");
			var tar: TestTarget = new TestTarget();
			var msg: * = {};
			var par: Array = [];
			logger.debugTarget = tar;
			logger.debug(msg, par);
			assertEquals( "my.log", tar.name );
			assertEquals( "log", tar.shortName );
			assertEquals( DEBUG, tar.level );
			assertTrue( tar.timeStamp <= getTimer() );
			assertEquals( msg, tar.message );
			assertEquals( par, tar.parameters );
			assertEquals( "me", tar.person );
		}
		
		public function testInfo(): void {
			var logger: Logger = new Logger("my.log", "me");
			var tar: TestTarget = new TestTarget();
			var msg: * = {};
			var par: Array = [];
			logger.infoTarget = tar;
			logger.info(msg, par);
			assertEquals( "my.log", tar.name );
			assertEquals( "log", tar.shortName );
			assertEquals( INFO, tar.level );
			assertTrue( tar.timeStamp <= getTimer() );
			assertEquals( msg, tar.message );
			assertEquals( par, tar.parameters );
			assertEquals( "me", tar.person );
		}
		
		public function testWarn(): void {
			var logger: Logger = new Logger("my.log", "me");
			var tar: TestTarget = new TestTarget();
			var msg: * = {};
			var par: Array = [];
			logger.warnTarget = tar;
			logger.warn(msg, par);
			assertEquals( "my.log", tar.name );
			assertEquals( "log", tar.shortName );
			assertEquals( WARN, tar.level );
			assertTrue( tar.timeStamp <= getTimer() );
			assertEquals( msg, tar.message );
			assertEquals( par, tar.parameters );
			assertEquals( "me", tar.person );
		}
		
		public function testError(): void {
			var logger: Logger = new Logger("my.log", "me");
			var tar: TestTarget = new TestTarget();
			var msg: * = {};
			var par: Array = [];
			logger.errorTarget = tar;
			logger.error(msg, par);
			assertEquals( "my.log", tar.name );
			assertEquals( "log", tar.shortName );
			assertEquals( ERROR, tar.level );
			assertTrue( tar.timeStamp <= getTimer() );
			assertEquals( msg, tar.message );
			assertEquals( par, tar.parameters );
			assertEquals( "me", tar.person );
		}
		
		public function testFatal(): void {
			var logger: Logger = new Logger("my.log", "you");
			var tar: TestTarget = new TestTarget();
			var msg: * = {};
			var par: Array = [];
			logger.fatalTarget = tar;
			logger.fatal(msg, par);
			assertEquals( "my.log", tar.name );
			assertEquals( "log", tar.shortName );
			assertEquals( FATAL, tar.level );
			assertTrue( tar.timeStamp <= getTimer() );
			assertEquals( msg, tar.message );
			assertEquals( par, tar.parameters );
			assertEquals( "you", tar.person );
		}
	}
}
import org.as3commons.logging.api.ILogTarget;

class TestTarget implements ILogTarget {
	
	public var name: String;
	public var shortName: String;
	public var level: int;
	public var timeStamp: Number;
	public var message: *;
	public var parameters: Array;
	public var person: String;
	
	public function log(name : String, shortName : String, level : int, timeStamp : Number, message : String, parameters : *=null, person : String=null) : void {
		this.name = name;
		this.shortName = shortName;
		this.level = level;
		this.timeStamp = timeStamp;
		this.message = message;
		this.parameters = parameters;
		this.person = person;
	}
}
