package org.as3commons.logging.setup.target {
	import org.as3commons.logging.util.verifyNothingCalled;
	import org.as3commons.logging.util.alike;
	import org.mockito.integrations.eq;
	import org.as3commons.logging.LogTargetLevel;
	import org.as3commons.logging.ILogSetup;
	import org.as3commons.logging.LogLevel;
	import org.as3commons.logging.setup.ILogTarget;
	import org.mockito.integrations.any;
	import org.mockito.integrations.flexunit3.MockitoTestCase;
	import org.mockito.integrations.given;
	import org.mockito.integrations.inOrder;
	import org.mockito.integrations.mock;

	/**
	 * @author mh
	 */
	public class BufferTest extends MockitoTestCase {
		public function BufferTest() {
			super( [ ILogSetup ] );
		}
		
		public function testEmpty(): void {
			var logCache: BufferTarget = new BufferTarget();
			logCache.flushTo( null );
		}

		public function testNormal(): void {
			var logCache: BufferTarget = new BufferTarget();
			
			var setup: ILogSetup = mock( ILogSetup );
			var target: ILogTarget = mock( ILogTarget );
			
			given( setup.getTarget( any() ) ).willReturn( target );
			given( setup.getLevel( any() ) ).willReturn( LogTargetLevel.DEBUG_ONLY.or( LogTargetLevel.FATAL_ONLY ) );
			
			logCache.log( "debug", "test", LogLevel.DEBUG, 1234, "debug", [] );
			
			// Contains smaller number to see if the number matter or not (it should not!)
			logCache.log( "info", "test", LogLevel.INFO, 0, "info", [] );
			
			logCache.log( "fatal", "test", LogLevel.FATAL, 1, "fatal", [] );
			
			logCache.flushTo( setup );
			
			inOrder().verify().that( setup.getTarget( "debug" ) );
			inOrder().verify().that( setup.getLevel( "debug" ) );
			inOrder().verify().that( target.log( eq("debug"), eq("test"), eq(LogLevel.DEBUG), eq(1234), eq("debug"), alike([])));
			inOrder().verify().that( setup.getTarget( "info" ) );
			inOrder().verify().that( setup.getLevel( "info" ) );
			inOrder().verify().that( setup.getTarget( "fatal" ) );
			inOrder().verify().that( setup.getLevel( "fatal" ) );
			inOrder().verify().that( target.log( eq("fatal"), eq("test"), eq(LogLevel.FATAL), eq(1), eq("fatal"), alike([])));
			
			verifyNothingCalled( setup );
			verifyNothingCalled( target );
			
			logCache.log( "fatal", "test", LogLevel.FATAL, 123, "fatal", [] );
			
			logCache.flushTo( setup );
			
			inOrder().verify().that( setup.getTarget( "fatal" ) );
			inOrder().verify().that( setup.getLevel( "fatal" ) );
			inOrder().verify().that( target.log( eq("fatal"), eq("test"), eq(LogLevel.FATAL), eq(123), eq("fatal"), alike([])));
			
			verifyNothingCalled( setup );
			verifyNothingCalled( target );
		}
	}
}
