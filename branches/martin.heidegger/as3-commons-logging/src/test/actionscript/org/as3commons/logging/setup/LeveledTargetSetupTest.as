package org.as3commons.logging.setup {
	
	import org.as3commons.logging.Logger;
	import org.as3commons.logging.util.verifyNothingCalled;
	import org.mockito.MockitoTestCase;
	
	/**
	 * @author mh
	 */
	public class LeveledTargetSetupTest extends MockitoTestCase {
		public function LeveledTargetSetupTest() {
			super( [ILogTarget] );
		}
		
		public function testNormal(): void {
			var target: ILogTarget = mock( ILogTarget );
			var logger: Logger = new Logger("a");
			var setup: LevelTargetSetup;
			
			setup = new LevelTargetSetup(target,LogSetupLevel.ALL);
			setup.applyTo(logger);
			
			assertEquals(logger.debugTarget, target);
			assertEquals(logger.infoTarget, target);
			assertEquals(logger.warnTarget, target);
			assertEquals(logger.errorTarget, target);
			assertEquals(logger.fatalTarget, target);
			
			setup = new LevelTargetSetup(target, LogSetupLevel.DEBUG_ONLY);
			setup.applyTo(logger);
			
			assertEquals(logger.debugTarget, target);
			assertEquals(logger.infoTarget, null);
			assertEquals(logger.warnTarget, null);
			assertEquals(logger.errorTarget, null);
			assertEquals(logger.fatalTarget, null);
			
			setup = new LevelTargetSetup(target, LogSetupLevel.INFO_ONLY);
			setup.applyTo(logger);
			
			assertEquals(logger.debugTarget, null);
			assertEquals(logger.infoTarget, target);
			assertEquals(logger.warnTarget, null);
			assertEquals(logger.errorTarget, null);
			assertEquals(logger.fatalTarget, null);
			
			setup = new LevelTargetSetup(target, LogSetupLevel.WARN_ONLY);
			setup.applyTo(logger);
			
			assertEquals(logger.debugTarget, null);
			assertEquals(logger.infoTarget, null);
			assertEquals(logger.warnTarget, target);
			assertEquals(logger.errorTarget, null);
			assertEquals(logger.fatalTarget, null);
			
			setup = new LevelTargetSetup(target, LogSetupLevel.ERROR_ONLY);
			setup.applyTo(logger);
			
			assertEquals(logger.debugTarget, null);
			assertEquals(logger.infoTarget, null);
			assertEquals(logger.warnTarget, null);
			assertEquals(logger.errorTarget, target);
			assertEquals(logger.fatalTarget, null);
			
			setup = new LevelTargetSetup(target, LogSetupLevel.FATAL_ONLY);
			setup.applyTo(logger);
			
			assertEquals(logger.debugTarget, null);
			assertEquals(logger.infoTarget, null);
			assertEquals(logger.warnTarget, null);
			assertEquals(logger.errorTarget, null);
			assertEquals(logger.fatalTarget, target);
			
			setup = new LevelTargetSetup(target,LogSetupLevel.NONE);
			setup.applyTo(logger);
			
			assertEquals(logger.debugTarget, null);
			assertEquals(logger.infoTarget, null);
			assertEquals(logger.warnTarget, null);
			assertEquals(logger.errorTarget, null);
			assertEquals(logger.fatalTarget, null);
			
			verifyNothingCalled(target);
		}
	}
}