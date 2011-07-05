package org.as3commons.logging.setup.target {
	import org.as3commons.logging.util.passToFactory;
	import org.as3commons.logging.ILogSetup;
	import org.as3commons.logging.LoggerFactory;
	import org.as3commons.logging.level.DEBUG;
	import org.as3commons.logging.level.FATAL;
	import org.as3commons.logging.level.INFO;
	import org.as3commons.logging.setup.ILogTarget;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.util.alike;
	import org.as3commons.logging.util.verifyNothingCalled;
	import org.mockito.integrations.eq;
	import org.mockito.integrations.flexunit3.MockitoTestCase;
	import org.mockito.integrations.inOrder;
	import org.mockito.integrations.mock;

	/**
	 * @author mh
	 */
	public class BufferTest extends MockitoTestCase {
		public function BufferTest() {
			super( [ ILogSetup, ILogTarget ] );
		}

		public function testNormal(): void {
			var logCache: BufferTarget = new BufferTarget();
			var factory: LoggerFactory = new LoggerFactory( new SimpleTargetSetup(logCache) );
			
			var target: ILogTarget = mock( ILogTarget );
			var setup: ILogSetup = new SimpleTargetSetup( target );
			
			logCache.log( "debug", "test", DEBUG, 1234, "debug", [], null );
			
			// Contains smaller number to see if the number matter or not (it should not!)
			logCache.log( "info", "test", INFO, 0, "info", [], null );
			
			logCache.log( "fatal", "test", FATAL, 1, "fatal", [], null );
			
			factory.setup = setup;
			
			passToFactory(logCache.statements, factory);
			logCache.clear();
			
			assertEquals(logCache.statements.length, 0);
			
			inOrder().verify().that( target.log( eq("debug"), eq("test"), eq(DEBUG), eq(1234), eq("debug"), alike([]), eq(null)));
			inOrder().verify().that( target.log( eq("info"), eq("test"), eq(INFO), eq(0), eq("info"), alike([]), eq(null)));
			inOrder().verify().that( target.log( eq("fatal"), eq("test"), eq(FATAL), eq(1), eq("fatal"), alike([]), eq(null)));
			
			verifyNothingCalled( target );
		}
	}
}
