package org.as3commons.logging.integration
{
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.logging.LogEventLevel;
	import org.as3commons.logging.api.LOGGER_FACTORY;
	import org.as3commons.logging.level.DEBUG;
	import org.as3commons.logging.level.ERROR;
	import org.as3commons.logging.level.FATAL;
	import org.as3commons.logging.level.INFO;
	import org.as3commons.logging.level.WARN;
	import org.as3commons.logging.setup.ILogTarget;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.util.alike;
	import org.as3commons.logging.util.verifyNothingCalled;
	import org.mockito.integrations.eq;
	import org.mockito.integrations.flexunit3.MockitoTestCase;
	import org.mockito.integrations.inOrder;
	import org.mockito.integrations.mock;
	import org.mockito.integrations.notNull;


	/**
	 * @author mh
	 */
	public class FlexIntegrationTest extends MockitoTestCase {
		
		public function FlexIntegrationTest() {
			super([ILogTarget]);
		}
		
		public function testNormal():void {
			
			var target: ILogTarget = mock( ILogTarget );

			LOGGER_FACTORY.setup = new SimpleTargetSetup(target);
			
			var flexLogger: FlexLogger = new FlexLogger( LogEventLevel.DEBUG );
			Log.addTarget( flexLogger );
			
			var logger: ILogger = Log.getLogger( "test" );
			logger.debug( "Hello World" );
			logger.debug( "Hello {0}", "Mario" );
			logger.info( "Hola!" );
			logger.info( "Amigo {0} {1}", "Santa", "Maria" );
			logger.warn( "Como!" );
			logger.error( "Estaz!" );
			logger.fatal( "Santa domingo!" );
			
			inOrder().verify().that( target.log( eq("test"), eq("test"), eq(DEBUG), notNull(), eq( "Hello World" ), eq(null), eq("flex") ) );
			inOrder().verify().that( target.log( eq("test"), eq("test"), eq(DEBUG), notNull(), eq( "Hello Mario" ), eq(null), eq("flex") ) );
			inOrder().verify().that( target.log( eq("test"), eq("test"), eq(INFO), notNull(), eq( "Hola!" ), eq(null), eq("flex") ) );
			inOrder().verify().that( target.log( eq("test"), eq("test"), eq(INFO), notNull(), eq( "Amigo Santa Maria" ), eq(null), eq("flex") ) );
			inOrder().verify().that( target.log( eq("test"), eq("test"), eq(WARN), notNull(), eq( "Como!" ), eq(null), eq("flex") ) );
			inOrder().verify().that( target.log( eq("test"), eq("test"), eq(ERROR), notNull(), eq( "Estaz!" ), eq(null), eq("flex") ) );
			inOrder().verify().that( target.log( eq("test"), eq("test"), eq(FATAL), notNull(), eq( "Santa domingo!" ), eq(null), eq("flex") ) );
			
			verifyNothingCalled( target );
		}
	}
}
