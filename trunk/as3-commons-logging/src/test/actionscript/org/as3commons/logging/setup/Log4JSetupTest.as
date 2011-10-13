package org.as3commons.logging.setup {
	import org.as3commons.logging.setup.log4j.log4jPropertiesToSetup;
	import org.as3commons.logging.setup.log4j.TestClassWithArgument;
	import org.as3commons.logging.level.WARN;
	import org.as3commons.logging.setup.target.LogStatement;
	import avmplus.getQualifiedClassName;

	import flexunit.framework.TestCase;

	import org.as3commons.logging.api.LOGGER_FACTORY;
	import org.as3commons.logging.api.Logger;
	import org.as3commons.logging.setup.log4j.Log4JStyleSetup;
	import org.as3commons.logging.setup.target.TraceTarget;
	
	
	/**
	 * @author mh
	 */
	public class Log4JSetupTest extends TestCase {
		private var _testTarget : TestTarget;
		public function Log4JSetupTest() {}
		
		override public function setUp() : void {
			_testTarget = new TestTarget();
			LOGGER_FACTORY.setup = new SimpleTargetSetup( _testTarget );
		}
		
		public function testProperties(): void {
			var logger: Logger = new Logger("name");
			
			log4jPropertiesToSetup(
				"log4j.appender.trace="+getQualifiedClassName(TraceTarget)+"\n"
				+ "log4j.rootLogger=all, trace"
			).applyTo(logger);
			
			assertTrue( logger.debugTarget is TraceTarget );
		}
		
		public function testRootLogger(): void {
			var trace: TraceTarget = new TraceTarget();
			
			var log4j: Log4JStyleSetup = new Log4JStyleSetup();
			log4j.appender.trace = trace;
			log4j.rootLogger = "WARN, trace";
			
			var logger: Logger = new Logger("name");
			var setup: HierarchicalSetup = log4j.compile();
			setup.applyTo(logger);
			
			assertEquals( null, logger.debugTarget );
			assertEquals( null, logger.infoTarget );
			assertEquals( trace, logger.warnTarget );
			assertEquals( trace, logger.errorTarget );
			assertEquals( trace, logger.fatalTarget );
		}
		
		public function testUseNonexistingAndWrongAppender(): void {
			var logger: Logger = new Logger("name");
			var log4j: Log4JStyleSetup = new Log4JStyleSetup();
			log4j.rootLogger = "ALL, trace";
			log4j.compile().applyTo(logger);
			
			assertEquals(0, _testTarget.statements.length);
			
			log4j.appender.trace = 1;
			log4j.compile().applyTo(logger);
			
			var state: LogStatement = _testTarget.statements.shift();
			assertEquals("Appender '{0}' could not be used as its no ILogTarget implementation or class name! Defined as: {1}", state.message);
			assertEquals("org.as3commons.logging.setup.log4j.Log4JStyleSetup", state.name);
			assertObjectEquals(["trace", 1], state.parameters);
			
			assertEquals(0, _testTarget.statements.length);
			
			log4j.appender.trace = "strage.class.Doesnt.Exist";
			log4j.compile().applyTo(logger);
			
			state = _testTarget.statements.shift();
			
			assertObjectEquals(["trace", "strage.class.Doesnt.Exist"], state.parameters);
			assertEquals("Appender '{0}' can not be instantiated from class '{1}' because the class wasn't available at runtime.", state.message);
			assertEquals("org.as3commons.logging.setup.log4j.Log4JStyleSetup", state.name);
			
			log4j.appender.trace = getQualifiedClassName(TestClassWithArgument);
			log4j.compile().applyTo(logger);
			
			state = _testTarget.statements.shift();
			
			assertEquals("trace", state.parameters[0]);
			assertEquals("org.as3commons.logging.setup.log4j::TestClassWithArgument", state.parameters[1]);
			assertTrue( state.parameters[2] is ArgumentError );
			assertEquals("Appender '{0}' could not be instantiated as '{1}' due to error '{2}'", state.message);
			assertEquals("org.as3commons.logging.setup.log4j.Log4JStyleSetup", state.name);
			
			assertEquals(0, _testTarget.statements.length);
		}
		
		public function testAppenderGeneration(): void {
			var logger: Logger = new Logger("name");
			var log4j: Log4JStyleSetup = new Log4JStyleSetup();
			log4j.appender.trace = getQualifiedClassName(TraceTarget);
			log4j.rootLogger = "ALL, trace";
			log4j.compile().applyTo(logger);
			
			assertTrue( logger.debugTarget is TraceTarget);
			
			log4j.appender.trace.notWorking = "abc";
			log4j.compile().applyTo(logger);
			// no exception thrown is a good thing!
			// warning was rendered though
			
			var statement: LogStatement = _testTarget.statements.shift();
			assertEquals( WARN, statement.level );
			assertEquals( "org.as3commons.logging.setup.log4j.Log4JStyleSetup", statement.name );
			assertEquals( "trace", statement.parameters[0] );
			assertEquals( "notWorking", statement.parameters[1] );
			assertTrue( statement.parameters[2] is ReferenceError );
			assertEquals( "Can not access property '{1}' of appender '{0}': {2}", statement.message );
			
			log4j.appender.trace.something.will.notWork = "abc";
			log4j.compile().applyTo(logger);
			
			// no exception here as well
		}
		
		public function testSimpleThreshold(): void {
			var trace: TraceTarget = new TraceTarget();
			var logger: Logger = new Logger("name");
			
			var log4j: Log4JStyleSetup = new Log4JStyleSetup();
			log4j.threshold = "ALL";
			log4j.appender.trace = trace;
			log4j.rootLogger = "ALL, trace";
			
			log4j.compile().applyTo(logger);
			
			assertEquals( trace, logger.debugTarget );
			assertEquals( trace, logger.infoTarget );
			assertEquals( trace, logger.warnTarget );
			assertEquals( trace, logger.errorTarget );
			assertEquals( trace, logger.fatalTarget );
			
			log4j.threshold = "NONE";
			logger.allTargets = null;
			log4j.compile().applyTo(logger);
			
			assertEquals( null, logger.debugTarget );
			assertEquals( null, logger.infoTarget );
			assertEquals( null, logger.warnTarget );
			assertEquals( null, logger.errorTarget );
			assertEquals( null, logger.fatalTarget );
			
			log4j.threshold = "FATAL";
			logger.allTargets = null;
			log4j.compile().applyTo(logger);
			
			assertEquals( null, logger.debugTarget );
			assertEquals( null, logger.infoTarget );
			assertEquals( null, logger.warnTarget );
			assertEquals( null, logger.errorTarget );
			assertEquals( trace, logger.fatalTarget );
			
			log4j.threshold = "ERROR";
			logger.allTargets = null;
			log4j.compile().applyTo(logger);
			
			assertEquals( null, logger.debugTarget );
			assertEquals( null, logger.infoTarget );
			assertEquals( null, logger.warnTarget );
			assertEquals( trace, logger.errorTarget );
			assertEquals( trace, logger.fatalTarget );
			
			log4j.threshold = "WARN";
			logger.allTargets = null;
			log4j.compile().applyTo(logger);
			
			assertEquals( null, logger.debugTarget );
			assertEquals( null, logger.infoTarget );
			assertEquals( trace, logger.warnTarget );
			assertEquals( trace, logger.errorTarget );
			assertEquals( trace, logger.fatalTarget );
			
			log4j.threshold = "INFO";
			logger.allTargets = null;
			log4j.compile().applyTo(logger);
			
			assertEquals( null, logger.debugTarget );
			assertEquals( trace, logger.infoTarget );
			assertEquals( trace, logger.warnTarget );
			assertEquals( trace, logger.errorTarget );
			assertEquals( trace, logger.fatalTarget );
			
			log4j.threshold = "DEBUG";
			logger.allTargets = null;
			log4j.compile().applyTo(logger);
			
			assertEquals( trace, logger.debugTarget );
			assertEquals( trace, logger.infoTarget );
			assertEquals( trace, logger.warnTarget );
			assertEquals( trace, logger.errorTarget );
			assertEquals( trace, logger.fatalTarget );
			
			log4j.threshold = "ALL";
			logger.allTargets = null;
			log4j.compile().applyTo(logger);
			
			assertEquals( trace, logger.debugTarget );
			assertEquals( trace, logger.infoTarget );
			assertEquals( trace, logger.warnTarget );
			assertEquals( trace, logger.errorTarget );
			assertEquals( trace, logger.fatalTarget );
			
			log4j.threshold = "MOKES";
			logger.allTargets = null;
			log4j.compile().applyTo(logger);
			
			assertEquals( trace, logger.debugTarget );
			assertEquals( trace, logger.infoTarget );
			assertEquals( trace, logger.warnTarget );
			assertEquals( trace, logger.errorTarget );
			assertEquals( trace, logger.fatalTarget );
		}
		
		override public function tearDown() : void {
			LOGGER_FACTORY.setup = null;
		}

	}
}
import org.as3commons.logging.setup.target.LogStatement;
import org.as3commons.logging.setup.ILogTarget;


class TestTarget implements ILogTarget {
	
	public const statements: Array = [];
	
	public function log(name : String, shortName : String, level : int, timeStamp : Number, message : *, parameters : Array, person : String) : void {
		statements.push( new LogStatement(name, shortName, level, timeStamp, message, parameters, person, 0, false) );
	}
	
}
