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
			
			assertEquals(DEBUG+"direct",stack.shift());
			assertEquals(INFO+"direct",stack.shift());;
			assertEquals(WARN+"direct",stack.shift());
			assertEquals(ERROR+"direct",stack.shift());
			assertEquals(FATAL+"direct",stack.shift());
			
			assertEquals(DEBUG+"org.as3commons.logging.simple::SimpleLoggingTest/testActivationStackTrace:35",stack.shift());
			assertEquals(INFO+"org.as3commons.logging.simple::SimpleLoggingTest/testActivationStackTrace:36",stack.shift());
			assertEquals(WARN+"org.as3commons.logging.simple::SimpleLoggingTest/testActivationStackTrace:37",stack.shift());
			assertEquals(ERROR+"org.as3commons.logging.simple::SimpleLoggingTest/testActivationStackTrace:38",stack.shift());
			assertEquals(FATAL+"org.as3commons.logging.simple::SimpleLoggingTest/testActivationStackTrace:39",stack.shift());
			
			assertEquals(DEBUG+"direct",stack.shift());
			assertEquals(INFO+"direct",stack.shift());;
			assertEquals(WARN+"direct",stack.shift());
			assertEquals(ERROR+"direct",stack.shift());
			assertEquals(FATAL+"direct",stack.shift());
			
			assertEquals(stack.length, 0);
		}
		
		public function testEnabling():void {
			LOGGER_FACTORY.setup = rule( new SampleTarget, /^org/ );
			
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
			
			assertEquals(DEBUG+"org.as3commons.logging.simple::SimpleLoggingTest/testEnabling:87",stack.shift());
			assertEquals(INFO+"org.as3commons.logging.simple::SimpleLoggingTest/testEnabling:88",stack.shift());
			assertEquals(WARN+"org.as3commons.logging.simple::SimpleLoggingTest/testEnabling:89",stack.shift());
			assertEquals(ERROR+"org.as3commons.logging.simple::SimpleLoggingTest/testEnabling:90",stack.shift());
			assertEquals(FATAL+"org.as3commons.logging.simple::SimpleLoggingTest/testEnabling:91",stack.shift());
			
			assertEquals(stack.length, 0);
		}
		
		override public function tearDown():void {
			LOGGER_FACTORY.setup = null;
			stack = null;
		}
	}
}
import org.as3commons.logging.setup.ILogTarget;

var stack: Array;

class SampleTarget implements ILogTarget {
	
	public function SampleTarget() {}
	
	public function log(name : String, shortName : String, level : int, timeStamp : Number, message : *, parameters : Array, person : String) : void {
		stack.push(level+name);
	}
}
