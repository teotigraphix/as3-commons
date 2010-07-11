package org.as3commons.logging.setup {
	import org.as3commons.logging.ILogSetup;
	import org.as3commons.logging.LogTargetLevel;
	import org.as3commons.logging.util.verifyNothingCalled;
	import org.mockito.integrations.any;
	import org.mockito.integrations.eq;
	import org.mockito.integrations.flexunit3.MockitoTestCase;
	import org.mockito.integrations.given;
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
			
			var setup: ComplexSetup = new ComplexSetup();
			
			assertEquals( setup.getTarget(""), null );
			assertStrictlyEquals( setup.getTarget(null), null );
			assertStrictlyEquals( setup.getTarget(undefined), null );
			assertEquals( setup.getLevel(""), null );
			assertStrictlyEquals( setup.getLevel(null), null );
			assertStrictlyEquals( setup.getLevel(undefined), null );
			
			setup.addTargetRule( /.*/, dummy );
			
			assertEquals( setup.getTarget( "" ), dummy );
			assertStrictlyEquals( setup.getTarget( null ), dummy );
			assertStrictlyEquals( setup.getTarget( undefined ), dummy );
			
			assertEquals( setup.getLevel( "" ), LogTargetLevel.ALL );
			assertStrictlyEquals( setup.getLevel( null ), LogTargetLevel.ALL );
			assertStrictlyEquals( setup.getLevel( undefined ), LogTargetLevel.ALL );
			
			setup.addTargetRule( /.*/, null );
			
			assertEquals( setup.getTarget( "" ), null );
			assertStrictlyEquals( setup.getTarget( null ), null );
			assertStrictlyEquals( setup.getTarget( undefined ), null );
			
			// Null should be returned if there is no target level to log to!
			assertEquals( setup.getLevel( "" ), null );
			assertStrictlyEquals( setup.getLevel( null ), null );
			assertStrictlyEquals( setup.getLevel( undefined ), null );
			
			setup = new ComplexSetup();
			setup.addTargetRule( /test/, dummy );
			assertEquals( setup.getTarget("something"), null );
			assertEquals( setup.getTarget("test"), dummy );
			assertEquals( setup.getTarget("test,tommy"), dummy );
			assertEquals( setup.getLevel("something"), null );
			assertEquals( setup.getLevel("test"), LogTargetLevel.ALL );
			
			setup.addTargetRule( /test,tommy/, null );
			assertEquals( setup.getTarget("something"), null );
			assertEquals( setup.getTarget("test"), dummy );
			assertEquals( setup.getTarget("test,funny"), dummy );
			assertEquals( setup.getTarget("test,tommy"), null );
			
			setup.addNoLogRule( /test,funny/ );
			assertEquals( setup.getTarget("something"), null );
			assertEquals( setup.getTarget("test"), dummy );
			assertEquals( setup.getTarget("test,tommy"), null );
			assertEquals( setup.getTarget("test,funny"), null );
			
			setup.addTargetRule( /tes/, dummy2 );
			assertEquals( setup.getTarget("something"), null );
			assertEquals( setup.getTarget("test"), dummy2 );
			assertEquals( setup.getTarget("test,tommy"), dummy2 );
			assertEquals( setup.getTarget("test,funny"), dummy2 );
			
			verifyNothingCalled( dummy );
			verifyNothingCalled( dummy2 );
		}
		
		public function testTargetSetupIntegration(): void {
			
			var dummyTarget: ILogTarget = mock( ILogTarget );
			var targetSetup: ILogSetup = mock( ILogSetup );
			
			var setup: ComplexSetup = new ComplexSetup();
			setup.addSetupRule( /^adf.*$/, targetSetup );
			
			given( targetSetup.getTarget( any() ) ).willReturn( dummyTarget );
			given( targetSetup.getLevel( any() ) ).willReturn( LogTargetLevel.INFO );
			
			assertStrictlyEquals( setup.getTarget( "mouse" ), null );
			assertStrictlyEquals( setup.getLevel( "mouse" ), null );
			assertEquals( setup.getTarget("adf"), dummyTarget );
			assertEquals( setup.getLevel("adf"), LogTargetLevel.INFO );
			
			inOrder().verify().that( targetSetup.getTarget( eq("adf") ) );
			inOrder().verify().that( targetSetup.getLevel( eq("adf") ) );
			
			verifyNothingCalled( targetSetup );
		}
		
		public function testDispose(): void {
			var dummy: ILogTarget = mock( ILogTarget );
			var setup: ComplexSetup = new ComplexSetup();
			
			setup.addNoLogRule( /.*/ );
			setup.addTargetRule( /.*/, dummy );
			
			setup.dispose();
			
			assertStrictlyEquals( setup.getTarget( "" ) , null );
			assertStrictlyEquals( setup.getLevel( "" ) , null );
		}
	}
}
