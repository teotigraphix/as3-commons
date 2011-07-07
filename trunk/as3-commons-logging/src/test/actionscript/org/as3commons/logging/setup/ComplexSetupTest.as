package org.as3commons.logging.setup {
	import org.as3commons.logging.api.ILogSetup;
	import org.as3commons.logging.api.Logger;
	import org.as3commons.logging.setup.target.TextFieldTarget;
	import org.as3commons.logging.util.verifyNothingCalled;
	import org.mockito.integrations.flexunit3.MockitoTestCase;
	import org.mockito.integrations.inOrder;
	import org.mockito.integrations.mock;

	/**
	 * @author mh
	 */
	public class ComplexSetupTest extends MockitoTestCase {
		
		public function ComplexSetupTest() {
			super([ILogTarget,ILogSetup]);
		}
		
		public function testTargetRule(): void {
			var dummy: ILogTarget = mock( ILogTarget );
			var dummy2: ILogTarget = mock( ILogTarget );
			var loggerA: Logger = new Logger("");
			var loggerB: Logger = new Logger("something");
			var loggerC: Logger = new Logger("test");
			var loggerD: Logger = new Logger("test,funny");
			var loggerE: Logger = new Logger("test,tommy");
			
			var traceSetup: SimpleTargetSetup = new SimpleTargetSetup(dummy);
			traceSetup.applyTo(loggerA);
			traceSetup.applyTo(loggerB);
			traceSetup.applyTo(loggerC);
			traceSetup.applyTo(loggerD);
			traceSetup.applyTo(loggerE);
			
			var setup: RegExpSetup = new RegExpSetup();
			setup.applyTo(loggerA);
			assertEquals(loggerA.debugTarget, null);
			
			setup.addTargetRule( /.*/, dummy );
			
			setup.applyTo(loggerA);
			setup.applyTo(loggerB);
			setup.applyTo(loggerC);
			setup.applyTo(loggerD);
			setup.applyTo(loggerE);
			
			assertEquals(loggerA.debugTarget, dummy);
			assertEquals(loggerB.debugTarget, dummy);
			assertEquals(loggerC.debugTarget, dummy);
			assertEquals(loggerD.debugTarget, dummy);
			assertEquals(loggerE.debugTarget, dummy);
			
			setup.addTargetRule( /.*/, null );
			
			setup.applyTo(loggerA);
			setup.applyTo(loggerB);
			setup.applyTo(loggerC);
			setup.applyTo(loggerD);
			setup.applyTo(loggerE);
			
			assertEquals(loggerA.debugTarget, null);
			assertEquals(loggerB.debugTarget, null);
			assertEquals(loggerC.debugTarget, null);
			assertEquals(loggerD.debugTarget, null);
			assertEquals(loggerE.debugTarget, null);
			
			setup = new RegExpSetup();
			setup.addTargetRule( /test/, dummy );
			setup.applyTo(loggerA);
			setup.applyTo(loggerB);
			setup.applyTo(loggerC);
			setup.applyTo(loggerD);
			setup.applyTo(loggerE);
			
			assertEquals(loggerA.debugTarget, null);
			assertEquals(loggerB.debugTarget, null);
			assertEquals(loggerC.debugTarget, dummy);
			assertEquals(loggerD.debugTarget, dummy);
			assertEquals(loggerE.debugTarget, dummy);
			
			setup.addTargetRule( /test,tommy/, null );
			setup.applyTo(loggerA);
			setup.applyTo(loggerB);
			setup.applyTo(loggerC);
			setup.applyTo(loggerD);
			setup.applyTo(loggerE);
			
			assertEquals(loggerA.debugTarget, null);
			assertEquals(loggerB.debugTarget, null);
			assertEquals(loggerC.debugTarget, dummy);
			assertEquals(loggerD.debugTarget, dummy);
			assertEquals(loggerE.debugTarget, null);
			
			setup.addNoLogRule( /test,funny/ );
			setup.applyTo(loggerA);
			setup.applyTo(loggerB);
			setup.applyTo(loggerC);
			setup.applyTo(loggerD);
			setup.applyTo(loggerE);
			
			assertEquals(loggerA.debugTarget, null);
			assertEquals(loggerB.debugTarget, null);
			assertEquals(loggerC.debugTarget, dummy);
			assertEquals(loggerD.debugTarget, null);
			assertEquals(loggerE.debugTarget, null);
			
			setup.addTargetRule( /tes/, dummy2 );
			setup.applyTo(loggerA);
			setup.applyTo(loggerB);
			setup.applyTo(loggerC);
			setup.applyTo(loggerD);
			setup.applyTo(loggerE);
			
			assertEquals(loggerA.debugTarget, null);
			assertEquals(loggerB.debugTarget, null);
			assertEquals(loggerC.debugTarget, dummy2);
			assertEquals(loggerD.debugTarget, dummy2);
			assertEquals(loggerE.debugTarget, dummy2);
			
			verifyNothingCalled( dummy );
			verifyNothingCalled( dummy2 );
		}
		
		public function testTargetSetupIntegration(): void {
			
			var targetSetup: ILogSetup = mock( ILogSetup );
			var loggerA: Logger = new Logger("mouse");
			var loggerB: Logger = new Logger("adf");
			
			var setup: RegExpSetup = new RegExpSetup();
			setup.addRule( /^adf.*$/, targetSetup );
			
			setup.applyTo( loggerA );
			setup.applyTo( loggerB );
			
			inOrder().verify().that( targetSetup.applyTo( loggerB ) );
			
			verifyNothingCalled( targetSetup );
		}
		
		public function testOverriding(): void {
			var setup: RegExpSetup = new RegExpSetup();
			var targetA: ILogTarget = new TextFieldTarget();
			var targetB: ILogTarget = new TextFieldTarget();
			var targetC: ILogTarget = new TextFieldTarget();
			
			var loggerA: Logger = new Logger("mouse");
			loggerA.allTargets = targetC;
			
			setup.addTargetRule(/mouse/, targetA, LogSetupLevel.ERROR_ONLY);
			setup.addTargetRule(/mouse/, targetB, LogSetupLevel.DEBUG_ONLY);
			setup.applyTo(loggerA);
			
			assertEquals(loggerA.errorTarget, targetA);
			assertEquals(loggerA.debugTarget, targetB);
			assertNull(loggerA.fatalTarget);
			assertNull(loggerA.infoTarget);
			assertNull(loggerA.warnTarget);
		}
		
		public function testDispose(): void {
			var dummy: ILogTarget = mock( ILogTarget );
			var setup: RegExpSetup = new RegExpSetup();
			var logger: Logger = new Logger("");
			
			setup.addNoLogRule( /.*/ );
			setup.addTargetRule( /.*/, dummy );
			
			setup.dispose();
			
			setup.applyTo(logger);
			
			assertStrictlyEquals( logger.debugTarget, null);
			assertStrictlyEquals( logger.debugTarget, null);
		}
	}
}
