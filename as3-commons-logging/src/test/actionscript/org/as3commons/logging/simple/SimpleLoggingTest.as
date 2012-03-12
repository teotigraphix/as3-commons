package org.as3commons.logging.simple {
	import org.as3commons.logging.setup.rule;
	import flexunit.framework.TestCase;

	import org.as3commons.logging.api.LOGGER_FACTORY;
	import org.as3commons.logging.level.DEBUG;
	import org.as3commons.logging.level.ERROR;
	import org.as3commons.logging.level.FATAL;
	import org.as3commons.logging.level.INFO;
	import org.as3commons.logging.level.WARN;
	import org.as3commons.logging.setup.SimpleTargetSetup;

	/**
	 * @author mh
	 */
	public class SimpleLoggingTest extends TestCase {
		
		public function SimpleLoggingTest() {}
		
		override public function setUp() : void {
			stack = [];
		}
		
		public function testTrace(): void {
			LOGGER_FACTORY.setup = new SimpleTargetSetup( new FullSampleTarget() );
			
			var obj: Object = { me:"me" };
			
			aTrace("hi");
			aTrace(obj);
			aTrace("hi",obj);
			aTrace("hi",obj,"hello", "world");
			
			USE_STACKTRACE = true;
			
			aTrace("hi");
			aTrace(obj);
			aTrace("hi",obj);
			aTrace("hi",obj,"hello", "world");
			
			USE_STACKTRACE = false;
			
			aTrace("hi");
			aTrace(obj);
			aTrace("hi",obj);
			aTrace("hi",obj,"hello", "world");
			
			assertObjectEquals([INFO, "org.as3commons.logging.simple", "{0}", ["hi"], "direct"], stack.shift());
			assertObjectEquals([INFO, "org.as3commons.logging.simple", "{0}", [obj], "direct"], stack.shift());
			assertObjectEquals([INFO, "org.as3commons.logging.simple", "{0} {1}", ["hi", obj], "direct"], stack.shift());
			assertObjectEquals([INFO, "org.as3commons.logging.simple", "{0} {1} {2} {3}", ["hi", obj, "hello", "world"], "direct"], stack.shift());
			assertObjectEquals([INFO, "org.as3commons.logging.simple.SimpleLoggingTest/testTrace:36", "{0}", ["hi"], "direct"], stack.shift());
			assertObjectEquals([INFO, "org.as3commons.logging.simple.SimpleLoggingTest/testTrace:37", "{0}", [obj], "direct"], stack.shift());
			assertObjectEquals([INFO, "org.as3commons.logging.simple.SimpleLoggingTest/testTrace:38", "{0} {1}", ["hi", obj], "direct"], stack.shift());
			assertObjectEquals([INFO, "org.as3commons.logging.simple.SimpleLoggingTest/testTrace:39", "{0} {1} {2} {3}", ["hi", obj, "hello", "world"], "direct"], stack.shift());
			assertObjectEquals([INFO, "org.as3commons.logging.simple", "{0}", ["hi"], "direct"], stack.shift());
			assertObjectEquals([INFO, "org.as3commons.logging.simple", "{0}", [obj], "direct"], stack.shift());
			assertObjectEquals([INFO, "org.as3commons.logging.simple", "{0} {1}", ["hi", obj], "direct"], stack.shift());
			assertObjectEquals([INFO, "org.as3commons.logging.simple", "{0} {1} {2} {3}", ["hi", obj, "hello", "world"], "direct"], stack.shift());
		}
		
		public function testActivationStackTrace():void {
			LOGGER_FACTORY.setup = new SimpleTargetSetup( new SampleTarget );
			
			org.as3commons.logging.simple.debug(null);
			org.as3commons.logging.simple.info(null);
			org.as3commons.logging.simple.warn(null);
			org.as3commons.logging.simple.error(null);
			org.as3commons.logging.simple.fatal(null);
			
			USE_STACKTRACE = true;
			
			org.as3commons.logging.simple.debug(null);
			org.as3commons.logging.simple.info(null);
			org.as3commons.logging.simple.warn(null);
			org.as3commons.logging.simple.error(null);
			org.as3commons.logging.simple.fatal(null);
			
			USE_STACKTRACE = false;
			
			org.as3commons.logging.simple.debug(null);
			org.as3commons.logging.simple.info(null);
			org.as3commons.logging.simple.warn(null);
			org.as3commons.logging.simple.error(null);
			org.as3commons.logging.simple.fatal(null);
			
			assertEquals(DEBUG+"org.as3commons.logging.simple",stack.shift());
			assertEquals(INFO+"org.as3commons.logging.simple",stack.shift());;
			assertEquals(WARN+"org.as3commons.logging.simple",stack.shift());
			assertEquals(ERROR+"org.as3commons.logging.simple",stack.shift());
			assertEquals(FATAL+"org.as3commons.logging.simple",stack.shift());
			
			assertEquals(DEBUG+"org.as3commons.logging.simple.SimpleLoggingTest/testActivationStackTrace:73",stack.shift());
			assertEquals(INFO+"org.as3commons.logging.simple.SimpleLoggingTest/testActivationStackTrace:74",stack.shift());
			assertEquals(WARN+"org.as3commons.logging.simple.SimpleLoggingTest/testActivationStackTrace:75",stack.shift());
			assertEquals(ERROR+"org.as3commons.logging.simple.SimpleLoggingTest/testActivationStackTrace:76",stack.shift());
			assertEquals(FATAL+"org.as3commons.logging.simple.SimpleLoggingTest/testActivationStackTrace:77",stack.shift());
			
			assertEquals(DEBUG+"org.as3commons.logging.simple",stack.shift());
			assertEquals(INFO+"org.as3commons.logging.simple",stack.shift());;
			assertEquals(WARN+"org.as3commons.logging.simple",stack.shift());
			assertEquals(ERROR+"org.as3commons.logging.simple",stack.shift());
			assertEquals(FATAL+"org.as3commons.logging.simple",stack.shift());
			
			assertEquals(stack.length, 0);
		}
		
		public function testEnabling():void {
			LOGGER_FACTORY.setup = rule( new SampleTarget, /^org\.as3commons\.logging\.simple\.SimpleLoggingTest/ );
			
			org.as3commons.logging.simple.debug(null);
			org.as3commons.logging.simple.info(null);
			org.as3commons.logging.simple.warn(null);
			org.as3commons.logging.simple.error(null);
			org.as3commons.logging.simple.fatal(null);
			
			assertFalse(isInfoEnabled());
			assertFalse(isWarnEnabled());
			assertFalse(isErrorEnabled());
			assertFalse(isFatalEnabled());
			assertFalse(isDebugEnabled());
			
			USE_STACKTRACE = true;
			
			org.as3commons.logging.simple.debug(null);
			org.as3commons.logging.simple.info(null);
			org.as3commons.logging.simple.warn(null);
			org.as3commons.logging.simple.error(null);
			org.as3commons.logging.simple.fatal(null);
			
			assertTrue(isInfoEnabled());
			assertTrue(isWarnEnabled());
			assertTrue(isErrorEnabled());
			assertTrue(isFatalEnabled());
			assertTrue(isDebugEnabled());
			
			LOGGER_FACTORY.setup = null;
			
			assertFalse(isInfoEnabled());
			assertFalse(isWarnEnabled());
			assertFalse(isErrorEnabled());
			assertFalse(isFatalEnabled());
			assertFalse(isDebugEnabled());
			
			USE_STACKTRACE = false;
			
			org.as3commons.logging.simple.debug(null);
			org.as3commons.logging.simple.info(null);
			org.as3commons.logging.simple.warn(null);
			org.as3commons.logging.simple.error(null);
			org.as3commons.logging.simple.fatal(null);
			
			assertFalse(isInfoEnabled());
			assertFalse(isWarnEnabled());
			assertFalse(isErrorEnabled());
			assertFalse(isFatalEnabled());
			assertFalse(isDebugEnabled());
			
			assertEquals(DEBUG+"org.as3commons.logging.simple.SimpleLoggingTest/testEnabling:125",stack.shift());
			assertEquals(INFO+"org.as3commons.logging.simple.SimpleLoggingTest/testEnabling:126",stack.shift());
			assertEquals(WARN+"org.as3commons.logging.simple.SimpleLoggingTest/testEnabling:127",stack.shift());
			assertEquals(ERROR+"org.as3commons.logging.simple.SimpleLoggingTest/testEnabling:128",stack.shift());
			assertEquals(FATAL+"org.as3commons.logging.simple.SimpleLoggingTest/testEnabling:129",stack.shift());
			
			assertEquals(stack.length, 0);
		}
		
		override public function tearDown():void {
			LOGGER_FACTORY.setup = null;
			stack = null;
		}
	}
}
import org.as3commons.logging.api.ILogTarget;

var stack: Array;

class SampleTarget implements ILogTarget {
	
	public function SampleTarget() {}
	
	public function log(name : String, shortName : String, level : int, timeStamp : Number, message : String, parameters: *, person : String, context:String, shortContext:String) : void {
		stack.push(level+name);
	}
}

class FullSampleTarget implements ILogTarget {
	
	public function log(name : String, shortName : String, level : int, timeStamp : Number, message : String, parameters: *, person : String, context:String, shortContext:String) : void {
		stack.push([level,name,message, parameters,person]);
	}
}
