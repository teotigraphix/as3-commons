package org.as3commons.logging.setup {
	
	import org.as3commons.logging.Logger;
	import org.as3commons.logging.LoggerFactory;
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
			var factory: LoggerFactory = new LoggerFactory( new LevelTargetSetup(target,LogSetupLevel.ALL) );
			var logger: Logger = factory.getNamedLogger("a") as Logger;
			
			assertEquals(logger.debugTarget, target);
			assertEquals(logger.infoTarget, target);
			assertEquals(logger.warnTarget, target);
			assertEquals(logger.errorTarget, target);
			assertEquals(logger.fatalTarget, target);
			
			factory.setup = new LevelTargetSetup(target, LogSetupLevel.DEBUG_ONLY);
			
			assertEquals(logger.debugTarget, target);
			assertEquals(logger.infoTarget, null);
			assertEquals(logger.warnTarget, null);
			assertEquals(logger.errorTarget, null);
			assertEquals(logger.fatalTarget, null);
			
			factory.setup = new LevelTargetSetup(target, LogSetupLevel.INFO_ONLY);
			
			assertEquals(logger.debugTarget, null);
			assertEquals(logger.infoTarget, target);
			assertEquals(logger.warnTarget, null);
			assertEquals(logger.errorTarget, null);
			assertEquals(logger.fatalTarget, null);
			
			factory.setup = new LevelTargetSetup(target, LogSetupLevel.WARN_ONLY);
			
			assertEquals(logger.debugTarget, null);
			assertEquals(logger.infoTarget, null);
			assertEquals(logger.warnTarget, target);
			assertEquals(logger.errorTarget, null);
			assertEquals(logger.fatalTarget, null);
			
			factory.setup = new LevelTargetSetup(target, LogSetupLevel.ERROR_ONLY);
			
			assertEquals(logger.debugTarget, null);
			assertEquals(logger.infoTarget, null);
			assertEquals(logger.warnTarget, null);
			assertEquals(logger.errorTarget, target);
			assertEquals(logger.fatalTarget, null);
			
			factory.setup = new LevelTargetSetup(target, LogSetupLevel.FATAL_ONLY);
			
			assertEquals(logger.debugTarget, null);
			assertEquals(logger.infoTarget, null);
			assertEquals(logger.warnTarget, null);
			assertEquals(logger.errorTarget, null);
			assertEquals(logger.fatalTarget, target);
			
			factory.setup = new LevelTargetSetup(target,LogSetupLevel.NONE);
			
			assertEquals(logger.debugTarget, null);
			assertEquals(logger.infoTarget, null);
			assertEquals(logger.warnTarget, null);
			assertEquals(logger.errorTarget, null);
			assertEquals(logger.fatalTarget, null);
			
			verifyNothingCalled(target);
		}
	}
}