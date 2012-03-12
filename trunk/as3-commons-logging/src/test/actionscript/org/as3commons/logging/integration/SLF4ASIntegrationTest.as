package org.as3commons.logging.integration {
	import com.furusystems.logging.slf4as.ILogger;
	import com.furusystems.logging.slf4as.Logging;

	import org.as3commons.logging.api.LOGGER_FACTORY;
	import org.as3commons.logging.level.DEBUG;
	import org.as3commons.logging.level.ERROR;
	import org.as3commons.logging.level.FATAL;
	import org.as3commons.logging.level.INFO;
	import org.as3commons.logging.level.WARN;
	import org.as3commons.logging.api.ILogTarget;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.util.verifyNothingCalled;
	import org.mockito.MockitoTestCase;
	
	/**
	 * @author mh
	 */
	public class SLF4ASIntegrationTest extends MockitoTestCase {
		
		public function SLF4ASIntegrationTest() {
			super([ILogTarget]);
		}
		
		
		public function testIntegration(): void {
			
			var target: ILogTarget = mock( ILogTarget, "Logtarget" );
			
			LOGGER_FACTORY.setup = new SimpleTargetSetup( target ); 
			
			Logging.logBinding = new SLF4ASIntegration();
			
			var logger: ILogger = Logging.getLogger( SLF4ASIntegrationTest );
			
			logger.info( "This is funny!" );
			logger.info( "This is funny!", "me", 1 );
			
			logger.debug( "This is funny!" );
			logger.debug( "This is funny!", "me", 1  );
			
			logger.warn( "This is funny!" );
			logger.warn( "This is funny!", "me", 1  );
			
			logger.error( "This is funny!" );
			logger.error( "This is funny!", "me", 1  );
			
			logger.fatal( "This is funny!" );
			logger.fatal( "This is funny!", "me", 1  );
			
			inOrder().verify().that( target.log( eq("SLF4ASIntegrationTest"), eq("SLF4ASIntegrationTest"), eq(INFO), anyOf(Number), eq("This is funny!"), eq(null), eq("slf4as"), eq(null), eq(null)) );
			inOrder().verify().that( target.log( eq("SLF4ASIntegrationTest"), eq("SLF4ASIntegrationTest"), eq(INFO), anyOf(Number), eq("This is funny! me 1"), eq(null), eq("slf4as"), eq(null), eq(null)) );
			inOrder().verify().that( target.log( eq("SLF4ASIntegrationTest"), eq("SLF4ASIntegrationTest"), eq(DEBUG), anyOf(Number), eq("This is funny!"), eq(null), eq("slf4as"), eq(null), eq(null)) );
			inOrder().verify().that( target.log( eq("SLF4ASIntegrationTest"), eq("SLF4ASIntegrationTest"), eq(DEBUG), anyOf(Number), eq("This is funny! me 1"), eq(null), eq("slf4as"), eq(null), eq(null)) );
			inOrder().verify().that( target.log( eq("SLF4ASIntegrationTest"), eq("SLF4ASIntegrationTest"), eq(WARN), anyOf(Number), eq("This is funny!"), eq(null), eq("slf4as"), eq(null), eq(null)) );
			inOrder().verify().that( target.log( eq("SLF4ASIntegrationTest"), eq("SLF4ASIntegrationTest"), eq(WARN), anyOf(Number), eq("This is funny! me 1"), eq(null), eq("slf4as"), eq(null), eq(null)) );
			inOrder().verify().that( target.log( eq("SLF4ASIntegrationTest"), eq("SLF4ASIntegrationTest"), eq(ERROR), anyOf(Number), eq("This is funny!"), eq(null), eq("slf4as"), eq(null), eq(null)) );
			inOrder().verify().that( target.log( eq("SLF4ASIntegrationTest"), eq("SLF4ASIntegrationTest"), eq(ERROR), anyOf(Number), eq("This is funny! me 1"), eq(null), eq("slf4as"), eq(null), eq(null)) );
			inOrder().verify().that( target.log( eq("SLF4ASIntegrationTest"), eq("SLF4ASIntegrationTest"), eq(FATAL), anyOf(Number), eq("This is funny!"), eq(null), eq("slf4as"), eq(null), eq(null)) );
			inOrder().verify().that( target.log( eq("SLF4ASIntegrationTest"), eq("SLF4ASIntegrationTest"), eq(FATAL), anyOf(Number), eq("This is funny! me 1"), eq(null), eq("slf4as"), eq(null), eq(null)) );
			
			verifyNothingCalled( target );
		}
	}
}
