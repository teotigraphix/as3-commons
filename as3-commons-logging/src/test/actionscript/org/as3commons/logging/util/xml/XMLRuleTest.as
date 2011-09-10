package org.as3commons.logging.util.xml {
	import org.as3commons.logging.setup.LeveledTargetSetupTest;
	import flexunit.framework.TestCase;

	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.LOGGER_FACTORY;
	import org.as3commons.logging.api.getLogger;
	import org.as3commons.logging.setup.LevelTargetSetup;
	import org.as3commons.logging.setup.SimpleRegExpSetup;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	
	/**
	 * @author mh
	 */
	public class XMLRuleTest extends TestCase {
		
		private static const logger: ILogger = getLogger(XMLSetupTest);
		private static const loggerCustom: ILogger = getLogger("Custom");
		private static const loggerMartin: ILogger = getLogger(XMLSetupTest, "Martin");
		
		private const targetTypes: Object = {
			test: TestTarget
		};
		
		override public function setUp() : void {
			stack = [];
		}
		
		public function testRule():void {
			var simple: SimpleTargetSetup;
			simple = xmlToSetup(<rule xmlns="http://as3commons.org/logging/1"/>, {}) as SimpleTargetSetup;
			assertNotNull(simple);
			LOGGER_FACTORY.setup = simple;
			logger.info("Should be hidden by our setup");
			LOGGER_FACTORY.setup = new SimpleTargetSetup(new TestTarget);
			logger.info("Should be shown!");
			assertEquals("Should be shown!", stack.shift());
			
			simple = xmlToSetup(
			<rule xmlns="http://as3commons.org/logging/1">
				<target type="test"/>
			</rule>, targetTypes) as SimpleTargetSetup;
			assertNotNull( simple );
			LOGGER_FACTORY.setup = simple;
			logger.info("hi");
			assertEquals("hi", stack.shift());
			
			// Set the level to ALL
			simple = xmlToSetup(
			<rule xmlns="http://as3commons.org/logging/1" level="ALL">
				<target type="test"/>
			</rule>, targetTypes) as SimpleTargetSetup;
			assertNotNull( simple );
			LOGGER_FACTORY.setup = simple;
			logger.info("hi");
			assertEquals("hi", stack.shift());
			
			var leveled: LevelTargetSetup = xmlToSetup(
			<rule xmlns="http://as3commons.org/logging/1" level="ERROR">
				<target type="test"/>
			</rule>, targetTypes) as LevelTargetSetup;
			assertNotNull( leveled );
			LOGGER_FACTORY.setup = leveled;
			logger.info("info");
			logger.error("error");
			assertEquals("error", stack.shift());
			
			var rule: SimpleRegExpSetup = xmlToSetup(
			<rule xmlns="http://as3commons.org/logging/1" person="/^martin/i">
				<target type="test"/>
			</rule>, targetTypes) as SimpleRegExpSetup;
			assertNotNull( rule );
			LOGGER_FACTORY.setup = rule;
			logger.info("hello");
			loggerMartin.info("hi!");
			assertEquals("hi!", stack.shift());
			assertEquals(0, stack.length);
			
			rule = xmlToSetup(
			<rule xmlns="http://as3commons.org/logging/1" name="/^Custom$/">
				<target type="test"/>
			</rule>, targetTypes) as SimpleRegExpSetup;
			assertNotNull( rule );
			LOGGER_FACTORY.setup = rule;
			logger.info("hello");
			loggerCustom.info("hi!");
			assertEquals("hi!", stack.shift());
			assertEquals(0, stack.length);
		}
		
		public function testVariousLevelCombinations(): void {
			// The following targets have do deliver a SimpleTargetSetup because their value is always "ALL"
			assertTrue( xmlToSetup(<rule xmlns="http://as3commons.org/logging/1" level="ALL"/>, targetTypes) is SimpleTargetSetup );
			assertTrue( xmlToSetup(<rule xmlns="http://as3commons.org/logging/1" level="DEBUG"/>, targetTypes) is SimpleTargetSetup );
			assertTrue( xmlToSetup(<rule xmlns="http://as3commons.org/logging/1" level="DEBUG_ONLY|INFO"/>, targetTypes) is SimpleTargetSetup );
			assertTrue( xmlToSetup(<rule xmlns="http://as3commons.org/logging/1" level="DEBUG_ONLY|INFO_ONLY|WARN"/>, targetTypes) is SimpleTargetSetup );
			assertTrue( xmlToSetup(<rule xmlns="http://as3commons.org/logging/1" level="DEBUG_ONLY|INFO_ONLY|WARN_ONLY|ERROR"/>, targetTypes) is SimpleTargetSetup );
			assertTrue( xmlToSetup(<rule xmlns="http://as3commons.org/logging/1" level="DEBUG_ONLY|INFO_ONLY|WARN_ONLY|ERROR_ONLY|FATAL"/>, targetTypes) is SimpleTargetSetup );
			assertTrue( xmlToSetup(<rule xmlns="http://as3commons.org/logging/1" level="ALL|ALL"/>, targetTypes) is SimpleTargetSetup );
			assertTrue( xmlToSetup(<rule xmlns="http://as3commons.org/logging/1" level="ALL|DEBUG"/>, targetTypes) is SimpleTargetSetup );
			assertTrue( xmlToSetup(<rule xmlns="http://as3commons.org/logging/1" level="DEBUG|ALL"/>, targetTypes) is SimpleTargetSetup );
			
			var level: LevelTargetSetup = xmlToSetup(<rule xmlns="http://as3commons.org/logging/1" level="INFO"><target type="test"/></rule>, targetTypes) as LevelTargetSetup;
			assertNotNull( level );
			LOGGER_FACTORY.setup = level;
			
			logger.debug("debug");
			logger.info("info");
			logger.warn("warn");
			logger.error("error");
			logger.fatal("fatal");
			
			assertObjectEquals(["info","warn","error","fatal"], stack);
			stack = [];
			
			level = xmlToSetup(<rule xmlns="http://as3commons.org/logging/1" level="INFO_ONLY"><target type="test"/></rule>, targetTypes) as LevelTargetSetup;
			assertNotNull( level );
			LOGGER_FACTORY.setup = level;
			
			logger.debug("debug");
			logger.info("info");
			logger.warn("warn");
			logger.error("error");
			logger.fatal("fatal");
			
			assertObjectEquals(["info"], stack);
			stack = [];
			
			level = xmlToSetup(<rule xmlns="http://as3commons.org/logging/1" level="WARN"><target type="test"/></rule>, targetTypes) as LevelTargetSetup;
			assertNotNull( level );
			LOGGER_FACTORY.setup = level;
			
			logger.debug("debug");
			logger.info("info");
			logger.warn("warn");
			logger.error("error");
			logger.fatal("fatal");
			
			assertObjectEquals(["warn","error","fatal"], stack);
			stack = [];
			
			level = xmlToSetup(<rule xmlns="http://as3commons.org/logging/1" level="WARN_ONLY"><target type="test"/></rule>, targetTypes) as LevelTargetSetup;
			assertNotNull( level );
			LOGGER_FACTORY.setup = level;
			
			logger.debug("debug");
			logger.info("info");
			logger.warn("warn");
			logger.error("error");
			logger.fatal("fatal");
			
			assertObjectEquals(["warn"], stack);
			stack = [];
			
			level = xmlToSetup(<rule xmlns="http://as3commons.org/logging/1" level="ERROR"><target type="test"/></rule>, targetTypes) as LevelTargetSetup;
			assertNotNull( level );
			LOGGER_FACTORY.setup = level;
			
			logger.debug("debug");
			logger.info("info");
			logger.warn("warn");
			logger.error("error");
			logger.fatal("fatal");
			
			assertObjectEquals(["error","fatal"], stack);
			stack = [];
			
			level = xmlToSetup(<rule xmlns="http://as3commons.org/logging/1" level="ERROR_ONLY"><target type="test"/></rule>, targetTypes) as LevelTargetSetup;
			assertNotNull( level );
			LOGGER_FACTORY.setup = level;
			
			logger.debug("debug");
			logger.info("info");
			logger.warn("warn");
			logger.error("error");
			logger.fatal("fatal");
			
			assertObjectEquals(["error"], stack);
			stack = [];
			
			level = xmlToSetup(<rule xmlns="http://as3commons.org/logging/1" level="FATAL"><target type="test"/></rule>, targetTypes) as LevelTargetSetup;
			assertNotNull( level );
			LOGGER_FACTORY.setup = level;
			
			logger.debug("debug");
			logger.info("info");
			logger.warn("warn");
			logger.error("error");
			logger.fatal("fatal");
			
			assertObjectEquals(["fatal"], stack);
			stack = [];
			
			
			level = xmlToSetup(<rule xmlns="http://as3commons.org/logging/1" level="FATAL_ONLY"><target type="test"/></rule>, targetTypes) as LevelTargetSetup;
			assertNotNull( level );
			LOGGER_FACTORY.setup = level;
			
			logger.debug("debug");
			logger.info("info");
			logger.warn("warn");
			logger.error("error");
			logger.fatal("fatal");
			
			assertObjectEquals(["fatal"], stack);
			stack = [];
		}
		
		public function testTargets(): void {
			var simple: SimpleTargetSetup;
			simple = xmlToSetup(
				<rule xmlns="http://as3commons.org/logging/1">
					<target type="test"/>
					<target type="test"/>
				</rule>, targetTypes) as SimpleTargetSetup;
			assertNotNull( simple );
			LOGGER_FACTORY.setup = simple;
			logger.info("hi");
			assertEquals("hi", stack.shift());
			assertEquals("hi", stack.shift());
			assertEquals(0, stack.length);
			
			simple = xmlToSetup(
				<rule xmlns="http://as3commons.org/logging/1">
					<target type="test" name="hello"/>
				</rule>, targetTypes) as SimpleTargetSetup;
			assertNotNull( simple );
			LOGGER_FACTORY.setup = simple;
			logger.info("hi");
			assertEquals("hi", stack.shift());
			assertEquals(0, stack.length);
			
			// Two times the same value is valid, but it will just be taken once
			simple = xmlToSetup(
				<rule xmlns="http://as3commons.org/logging/1">
					<target type="test" name="hello"/>
					<target-ref ref="hello"/>
				</rule>, targetTypes) as SimpleTargetSetup;
			assertNotNull( simple );
			LOGGER_FACTORY.setup = simple;
			logger.info("hi");
			assertEquals("hi", stack.shift());
			assertEquals(0, stack.length);
			
			
			var defaultTarget: TestTarget = new TestTarget("itsme - ");
			simple = xmlToSetup(
				<rule xmlns="http://as3commons.org/logging/1">
					<target-ref ref="hello"/>
				</rule>, targetTypes, {
					hello: defaultTarget
				}) as SimpleTargetSetup;
			assertNotNull( simple );
			LOGGER_FACTORY.setup = simple;
			logger.info("hi");
			assertEquals("itsme - hi", stack.shift());
			assertEquals(0, stack.length);
			
			simple = xmlToSetup(
				<rule xmlns="http://as3commons.org/logging/1">
					<target name="hello" />
					<target-ref ref="hello"/>
				</rule>, targetTypes, {
					hello: defaultTarget
				}) as SimpleTargetSetup;
			assertNotNull( simple );
			LOGGER_FACTORY.setup = simple;
			logger.info("hi");
			assertEquals("itsme - hi", stack.shift());
			assertEquals(0, stack.length);
		}
	}
}
import org.as3commons.logging.setup.ILogTarget;

var stack: Array = [];

class TestTarget implements ILogTarget {
	private var _prefix: String;
	public function TestTarget(prefix:String="") {
		_prefix = prefix;
	}
	
	public function log(name : String, shortName : String, level : int, timeStamp : Number, message : *, parameters : Array, person : String) : void {
		stack.push(_prefix+message);
	}
}