package org.as3commons.logging.integration {
	import org.as3commons.logging.LOGGER_FACTORY;
	import org.as3commons.logging.level.DEBUG;
	import org.as3commons.logging.level.ERROR;
	import org.as3commons.logging.level.FATAL;
	import org.as3commons.logging.level.INFO;
	import org.as3commons.logging.level.WARN;
	import org.as3commons.logging.setup.ILogTarget;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.util.alike;
	import org.mockito.MockitoTestCase;
	import org.swizframework.utils.logging.SwizLogger;
	/**
	 * @author mh
	 */
	public class SwizIntegrationTest extends MockitoTestCase {
		
		public function SwizIntegrationTest() {
			super([ILogTarget]);
		}
		
		public function testIntegration(): void {
			var target: ILogTarget = mock( ILogTarget );
			
			LOGGER_FACTORY.setup = new SimpleTargetSetup( target );
			
			SwizLogger.addLoggingTarget( new SwizIntegration() );
			
			var logger: SwizLogger = SwizLogger.getLogger( SwizLogger );
			logger.debug( "A Debug{1}{0}", "1", 2 );
			logger.info( "A Info", true, "me" );
			logger.warn( "A Warn", "a", "b" );
			logger.error( "A Error", "max", 1 );
			logger.fatal( "A Fatal", "mo", "ho" );
			
			inOrder().verify().that( target.log( eq("org.swizframework.utils.logging.SwizLogger"), eq("SwizLogger"), eq(DEBUG), notNull(), eq( "A Debug21" ), eq(null), eq("swiz") ) );
			inOrder().verify().that( target.log( eq("org.swizframework.utils.logging.SwizLogger"), eq("SwizLogger"), eq(INFO), notNull(), eq( "A Info" ), eq(null), eq("swiz") ) );
			inOrder().verify().that( target.log( eq("org.swizframework.utils.logging.SwizLogger"), eq("SwizLogger"), eq(WARN), notNull(), eq( "A Warn" ), eq(null), eq("swiz") ) );
			inOrder().verify().that( target.log( eq("org.swizframework.utils.logging.SwizLogger"), eq("SwizLogger"), eq(ERROR), notNull(), eq( "A Error" ), eq(null), eq("swiz") ) );
			inOrder().verify().that( target.log( eq("org.swizframework.utils.logging.SwizLogger"), eq("SwizLogger"), eq(FATAL), notNull(), eq( "A Fatal" ), eq(null), eq("swiz") ) );
		}
	}
}