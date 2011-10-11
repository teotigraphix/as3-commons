package org.as3commons.logging.setup {
	import flexunit.framework.TestCase;

	import org.as3commons.logging.api.Logger;
	import org.as3commons.logging.api.getLogger;
	import org.as3commons.logging.setup.target.TraceTarget;
	
	
	/**
	 * @author mh
	 */
	public class HierarchialSetupTest extends TestCase {
		
		public function HierarchialSetupTest() {
		}
		
		public function testEmptySetup(): void {
			var setup: HierarchialSetup = new HierarchialSetup();
			
			setup.applyTo(getLogger() as Logger);
			setup.applyTo(getLogger("nopackage") as Logger);
			setup.applyTo(getLogger("a.package") as Logger);
			
			setup.applyTo(getLogger(null, "name") as Logger);
			setup.applyTo(getLogger("nopackage", "name") as Logger);
			setup.applyTo(getLogger("a.package", "name") as Logger);
			
			// Just testing that no errors occur :)
		}
		
		public function testThreshold(): void {
			var target: TraceTarget = new TraceTarget();
			var logger: Logger;
			var setup: HierarchialSetup = new HierarchialSetup();
			
			logger = new Logger("");
			setup.threshold = LogSetupLevel.DEBUG_ONLY;
			setup.setHierarchy(null,target);
			setup.applyTo(logger);
			
			assertNull( logger.errorTarget );
			assertNull( logger.fatalTarget );
			assertNull( logger.warnTarget );
			assertNull( logger.infoTarget );
			assertEquals( logger.debugTarget, target );
			
			logger = new Logger("");
			setup.threshold = LogSetupLevel.ERROR_ONLY;
			setup.applyTo(logger);
			
			assertNull( logger.debugTarget );
			assertNull( logger.fatalTarget );
			assertNull( logger.warnTarget );
			assertNull( logger.infoTarget );
			assertEquals( logger.errorTarget, target );
			
			logger = new Logger("");
			setup.threshold = LogSetupLevel.DEBUG_ONLY;
			setup.setHierarchy(null,target, LogSetupLevel.ALL);
			setup.applyTo(logger);
			
			assertNull( logger.errorTarget );
			assertNull( logger.fatalTarget );
			assertNull( logger.warnTarget );
			assertNull( logger.infoTarget );
			assertEquals( logger.debugTarget, target );
			
			
			logger = new Logger("");
			setup.threshold = LogSetupLevel.DEBUG_ONLY;
			setup.setHierarchy(null,target, LogSetupLevel.ERROR_ONLY);
			setup.applyTo(logger);
			
			assertNull( logger.errorTarget );
			assertNull( logger.fatalTarget );
			assertNull( logger.warnTarget );
			assertNull( logger.infoTarget );
			assertNull( logger.debugTarget );
		}
		
		public function testAdditivityForTargets():void {
			
			var calls: Array = [];
			
			var targetA: Target = new Target("A", calls);
			var targetB: Target = new Target("B", calls);
			var targetC: Target = new Target("C", calls);
			
			var setup: HierarchialSetup = new HierarchialSetup();
			setup.setHierarchy("", targetA, LogSetupLevel.DEBUG_ONLY );
			setup.setHierarchy("org", targetB);
			setup.setHierarchy("org.as3commons", targetB, LogSetupLevel.WARN_ONLY, false );
			setup.setHierarchy("org.as3commons.logging", targetC );
			
			var loggerA: Logger = new Logger("");
			var loggerB: Logger = new Logger("org");
			var loggerC: Logger = new Logger("org.as3commons");
			var loggerD: Logger = new Logger("org.as3commons.logging");
			
			setup.applyTo(loggerA);
			setup.applyTo(loggerB);
			setup.applyTo(loggerC);
			setup.applyTo(loggerD);
			
			loggerA.debug("hi");
			assertObjectEquals( ["A"], calls.splice(0,calls.length) );
			loggerB.debug("hi");
			assertObjectEquals( ["A", "B"], calls.splice(0,calls.length) );
			loggerC.warn("hi");
			assertObjectEquals( ["B"], calls.splice(0,calls.length) );
			loggerD.warn("hi");
			assertObjectEquals( ["B", "C"], calls.splice(0,calls.length) );
		}
		
		public function testDefaultHierarchy():void {
			
			var calls: Array = [];
			
			var targetA: Target = new Target("A",calls);
			var targetB: Target = new Target("B",calls);
			var targetC: Target = new Target("C",calls);
			
			var setup: HierarchialSetup = new HierarchialSetup();
			setup.setHierarchy("", targetA);
			setup.setHierarchy("org", targetB);
			setup.setHierarchy("org.as3commons", targetC);
			
			var loggerA: Logger = new Logger("");
			var loggerB: Logger = new Logger("org");
			var loggerC: Logger = new Logger("org.as3commons");
			var loggerD: Logger = new Logger("org.as3commons.logging");
			
			setup.applyTo(loggerA);
			setup.applyTo(loggerB);
			setup.applyTo(loggerC);
			setup.applyTo(loggerD);
			
			assertEquals( loggerA.debugTarget,  targetA );
			
			loggerB.debug("hi");
			assertObjectEquals( ["A","B"], calls.splice(0,calls.length) );
			
			loggerC.debug("hi");
			assertObjectEquals( ["A","B","C"], calls.splice(0,calls.length) );
			
			loggerD.debug("hi");
			assertObjectEquals( ["A","B","C"], calls.splice(0,calls.length) );
		}
		
		public function testHierarchyLevelFallback():void {
			
			var target: TraceTarget = new TraceTarget();
			
			var setup: HierarchialSetup = new HierarchialSetup();
			setup.setHierarchy("", target, LogSetupLevel.DEBUG_ONLY );
			setup.setHierarchy("org");
			setup.setHierarchy("org.as3commons", null, LogSetupLevel.WARN_ONLY );
			
			var loggerA: Logger = new Logger("");
			var loggerB: Logger = new Logger("org");
			var loggerC: Logger = new Logger("org.as3commons");
			var loggerD: Logger = new Logger("org.as3commons.logging");
			
			setup.applyTo(loggerA);
			setup.applyTo(loggerB);
			setup.applyTo(loggerC);
			setup.applyTo(loggerD);
			
			assertTrue( loggerA.debugEnabled );
			assertFalse( loggerA.warnEnabled );
			
			assertTrue( loggerB.debugEnabled );
			assertFalse( loggerB.warnEnabled );
			
			assertFalse( loggerC.debugEnabled );
			assertTrue( loggerC.warnEnabled );
			
			assertFalse( loggerD.debugEnabled );
			assertTrue( loggerD.warnEnabled );
		}
	}
}


import org.as3commons.logging.setup.ILogTarget;

class Target implements ILogTarget {
	private var _target : Array;
	private var _name : String;

	public function Target(name : String, target : Array) {
		_name = name;
		_target = target;
	}

	
	public function log(name : String, shortName : String, level : int, timeStamp : Number, message : *, parameters : Array, person : String) : void {
		_target.push( _name );
	}
	
}