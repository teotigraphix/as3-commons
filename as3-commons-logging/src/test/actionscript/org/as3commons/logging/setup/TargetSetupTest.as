package org.as3commons.logging.setup {
	import org.as3commons.logging.LogTargetLevel;
	import org.mockito.integrations.mock;
	import org.mockito.integrations.flexunit3.MockitoTestCase;

	/**
	 * @author mh
	 */
	public class TargetSetupTest extends MockitoTestCase {
		public function TargetSetupTest() {
			super( [ILogTarget] );
		}
		
		public function testNormal(): void {
			var target: ILogTarget = mock( ILogTarget );
			var setup: TargetSetup = new TargetSetup( target );
			assertEquals( setup.getLevel( "A" ), LogTargetLevel.ALL );
			assertEquals( setup.getLevel( "B" ), LogTargetLevel.ALL );
			assertEquals( setup.getTarget( "A"), target );
			assertEquals( setup.getTarget( "B"), target );
			
			setup = new TargetSetup( null );
			assertNull( setup.getTarget("A") );
			assertNull( setup.getTarget(null) );
			assertEquals( setup.getLevel("A"), null );
			assertEquals( setup.getLevel(null), null );
			
			setup = new TargetSetup( target, LogTargetLevel.ERROR_ONLY );
			assertEquals( setup.getTarget("A"), target );
			assertEquals( setup.getTarget(null), target );
			assertEquals( setup.getLevel("A"), LogTargetLevel.ERROR_ONLY );
			assertEquals( setup.getLevel(null), LogTargetLevel.ERROR_ONLY );
			
			setup = new TargetSetup( null, LogTargetLevel.ERROR_ONLY );
			assertNull( setup.getTarget("A") );
			assertNull( setup.getTarget(null) );
			assertEquals( setup.getLevel("A"), null );
			assertEquals( setup.getLevel(null), null );
		}
	}
}
