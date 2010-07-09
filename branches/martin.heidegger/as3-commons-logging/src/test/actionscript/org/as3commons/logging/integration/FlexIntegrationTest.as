package org.as3commons.logging.integration {
	import org.as3commons.logging.util.verifyNothingCalled;
	import org.mockito.integrations.notNull;
	import org.as3commons.logging.util.alike;
	import org.as3commons.logging.LogLevel;
	import org.as3commons.logging.LoggerFactory;
	import org.as3commons.logging.setup.ILogTarget;
	import org.as3commons.logging.setup.TargetSetup;
	import org.mockito.integrations.eq;
	import org.mockito.integrations.flexunit3.MockitoTestCase;
	import org.mockito.integrations.inOrder;
	import org.mockito.integrations.mock;

	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.logging.LogEventLevel;

	/**
	 * @author mh
	 */
	public class FlexIntegrationTest extends MockitoTestCase {
		
		public function FlexIntegrationTest() {
			super([ILogTarget]);
		}
		
		public function testNormal():void {
			
			var target: ILogTarget = mock( ILogTarget );
			
			LoggerFactory.setup = new TargetSetup( target );
			
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
			
			inOrder().verify().that( target.log( eq("test"), eq("test"), eq(LogLevel.DEBUG), notNull(), eq( "Hello World" ), alike([]) ) );
			inOrder().verify().that( target.log( eq("test"), eq("test"), eq(LogLevel.DEBUG), notNull(), eq( "Hello Mario" ), alike([]) ) );
			inOrder().verify().that( target.log( eq("test"), eq("test"), eq(LogLevel.INFO), notNull(), eq( "Hola!" ), alike([]) ) );
			inOrder().verify().that( target.log( eq("test"), eq("test"), eq(LogLevel.INFO), notNull(), eq( "Amigo Santa Maria" ), alike([]) ) );
			inOrder().verify().that( target.log( eq("test"), eq("test"), eq(LogLevel.WARN), notNull(), eq( "Como!" ), alike([]) ) );
			inOrder().verify().that( target.log( eq("test"), eq("test"), eq(LogLevel.ERROR), notNull(), eq( "Estaz!" ), alike([]) ) );
			inOrder().verify().that( target.log( eq("test"), eq("test"), eq(LogLevel.FATAL), notNull(), eq( "Santa domingo!" ), alike([]) ) );
			
			verifyNothingCalled( target );
		}
	}
}
