package org.as3commons.logging.setup {
	import org.as3commons.logging.api.ILogTarget;
	import org.as3commons.logging.api.Logger;
	import org.as3commons.logging.util.verifyNothingCalled;
	import org.mockito.MockitoTestCase;
	/**
	 * @author mh
	 */
	public class SimpleTargetSetupTest extends MockitoTestCase {
		public function SimpleTargetSetupTest() {
			super( [ILogTarget] );
		}
		
		public function testNormal(): void {
			var target: ILogTarget = mock( ILogTarget );
			var logger: Logger = new Logger("a");
			var setup: SimpleTargetSetup;
			
			setup = new SimpleTargetSetup( target );
			setup.applyTo(logger);

			assertEquals(logger.debugTarget, target);
			assertEquals(logger.infoTarget, target);
			assertEquals(logger.warnTarget, target);
			assertEquals(logger.errorTarget, target);
			assertEquals(logger.fatalTarget, target);
			
			setup = new SimpleTargetSetup( null );
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
