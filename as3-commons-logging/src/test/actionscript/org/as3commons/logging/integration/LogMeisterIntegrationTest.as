package org.as3commons.logging.integration {
	import flash.display.BitmapData;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import org.as3commons.logging.setup.target.LogMeisterTarget;
	import logmeister.connectors.ILogMeisterConnector;
	import logmeister.LogMeister;

	import org.as3commons.logging.api.LOGGER_FACTORY;
	import org.as3commons.logging.level.DEBUG;
	import org.as3commons.logging.level.ERROR;
	import org.as3commons.logging.level.FATAL;
	import org.as3commons.logging.level.INFO;
	import org.as3commons.logging.level.WARN;
	import org.as3commons.logging.api.ILogTarget;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.util.alike;
	import org.as3commons.logging.util.verifyNothingCalled;
	import org.mockito.MockitoTestCase;
	/**
	 * @author mh
	 */
	public class LogMeisterIntegrationTest extends MockitoTestCase {
		
		public function LogMeisterIntegrationTest() {
			super([ILogTarget,ILogMeisterConnector]);
		}
		
		public function testIntegration():void {
			
			var target: ILogTarget = mock( ILogTarget, "Logtarget" );
			
			LOGGER_FACTORY.setup = new SimpleTargetSetup( target );
			
			LogMeister.addLogger( new LogMeisterIntegration() );
			info( "a log message" );
			warn( "a warning" );
			error( "a error" );
			fatal( "a fatal msg" );
			status( "a status msg" );
			debug( "a debug msg" );
			critical( "a critical msg" );
			notice( "a notice msg" );
			
			info( "a log message", true );
			warn( "a warning", true );
			error( "a error", true );
			fatal( "a fatal msg", true );
			status( "a status msg", true );
			debug( "a debug msg", true );
			critical( "a critical msg", true );
			notice( "a notice msg", true );
			
			inOrder().verify().that( target.log( eq("org.as3commons.logging.integration.LogMeisterIntegrationTest"), eq("LogMeisterIntegrationTest"), eq(INFO), anyOf(Number), eq("a log message"), eq(null), eq("LogMeister")) );
			inOrder().verify().that( target.log( eq("org.as3commons.logging.integration.LogMeisterIntegrationTest"), eq("LogMeisterIntegrationTest"), eq(WARN), anyOf(Number), eq("a warning"), eq(null), eq("LogMeister")) );
			inOrder().verify().that( target.log( eq("org.as3commons.logging.integration.LogMeisterIntegrationTest"), eq("LogMeisterIntegrationTest"), eq(ERROR), anyOf(Number), eq("a error"), eq(null), eq("LogMeister")) );
			inOrder().verify().that( target.log( eq("org.as3commons.logging.integration.LogMeisterIntegrationTest"), eq("LogMeisterIntegrationTest"), eq(FATAL), anyOf(Number), eq("a fatal msg"), eq(null), eq("LogMeister")) );
			inOrder().verify().that( target.log( eq("org.as3commons.logging.integration.LogMeisterIntegrationTest"), eq("LogMeisterIntegrationTest"), eq(INFO), anyOf(Number), eq("a status msg"), eq(null), eq("LogMeister")) );
			inOrder().verify().that( target.log( eq("org.as3commons.logging.integration.LogMeisterIntegrationTest"), eq("LogMeisterIntegrationTest"), eq(DEBUG), anyOf(Number), eq("a debug msg"), eq(null), eq("LogMeister")) );
			inOrder().verify().that( target.log( eq("org.as3commons.logging.integration.LogMeisterIntegrationTest"), eq("LogMeisterIntegrationTest"), eq(FATAL), anyOf(Number), eq("a critical msg"), eq(null), eq("LogMeister")) );
			inOrder().verify().that( target.log( eq("org.as3commons.logging.integration.LogMeisterIntegrationTest"), eq("LogMeisterIntegrationTest"), eq(INFO), anyOf(Number), eq("a notice msg"), eq(null), eq("LogMeister")) );
			
			inOrder().verify().that( target.log( eq("org.as3commons.logging.integration.LogMeisterIntegrationTest"), eq("LogMeisterIntegrationTest"), eq(INFO), anyOf(Number), eq("a log message"), alike([true]), eq("LogMeister")) );
			inOrder().verify().that( target.log( eq("org.as3commons.logging.integration.LogMeisterIntegrationTest"), eq("LogMeisterIntegrationTest"), eq(WARN), anyOf(Number), eq("a warning"), alike([true]), eq("LogMeister")) );
			inOrder().verify().that( target.log( eq("org.as3commons.logging.integration.LogMeisterIntegrationTest"), eq("LogMeisterIntegrationTest"), eq(ERROR), anyOf(Number), eq("a error"), alike([true]), eq("LogMeister")) );
			inOrder().verify().that( target.log( eq("org.as3commons.logging.integration.LogMeisterIntegrationTest"), eq("LogMeisterIntegrationTest"), eq(FATAL), anyOf(Number), eq("a fatal msg"), alike([true]), eq("LogMeister")) );
			inOrder().verify().that( target.log( eq("org.as3commons.logging.integration.LogMeisterIntegrationTest"), eq("LogMeisterIntegrationTest"), eq(INFO), anyOf(Number), eq("a status msg"), alike([true]), eq("LogMeister")) );
			inOrder().verify().that( target.log( eq("org.as3commons.logging.integration.LogMeisterIntegrationTest"), eq("LogMeisterIntegrationTest"), eq(DEBUG), anyOf(Number), eq("a debug msg"), alike([true]), eq("LogMeister")) );
			inOrder().verify().that( target.log( eq("org.as3commons.logging.integration.LogMeisterIntegrationTest"), eq("LogMeisterIntegrationTest"), eq(FATAL), anyOf(Number), eq("a critical msg"), alike([true]), eq("LogMeister")) );
			inOrder().verify().that( target.log( eq("org.as3commons.logging.integration.LogMeisterIntegrationTest"), eq("LogMeisterIntegrationTest"), eq(INFO), anyOf(Number), eq("a notice msg"), alike([true]), eq("LogMeister")) );
			verifyNothingCalled( target );
		}
		
		public function testTarget():void {
			
			var target: ILogMeisterConnector = mock( ILogMeisterConnector, "Logtarget" );
			
			LogMeister.addLogger( target );
			
			LOGGER_FACTORY.setup = new SimpleTargetSetup( new LogMeisterTarget("{message}") );
			
			var logger: ILogger = getLogger(this);
			logger.debug("a debug msg");
			logger.info("a info msg");
			logger.warn("a warn msg");
			logger.error("a error msg");
			logger.fatal("a fatal msg");
			
			var bmp: BitmapData = new BitmapData(200, 200);
			
			logger.debug("a debug msg {0}", [2]);
			logger.info("a info msg {0}", [2]);
			logger.warn("a warn msg {0}", [2]);
			logger.error("a error msg {0}", [2]);
			logger.fatal("a fatal msg {0}", [2]);
			logger.debug(bmp, [2]);
			logger.info(bmp, [2]);
			logger.warn(bmp, [2]);
			logger.error(bmp, [2]);
			logger.fatal(bmp, [2]);
			logger.debug(bmp);
			logger.info(bmp);
			logger.warn(bmp);
			logger.error(bmp);
			logger.fatal(bmp);
			
			inOrder().verify().that( target.init() );
			inOrder().verify().that( target.sendDebug( eq("a debug msg") ) );
			inOrder().verify().that( target.sendInfo( eq("a info msg") ) );
			inOrder().verify().that( target.sendWarn( eq("a warn msg") ) );
			inOrder().verify().that( target.sendError( eq("a error msg") ) );
			inOrder().verify().that( target.sendFatal( eq("a fatal msg") ) );
			inOrder().verify().that( target.sendDebug( eq("a debug msg 2"), eq(2) ) );
			inOrder().verify().that( target.sendInfo( eq("a info msg 2"), eq(2) ) );
			inOrder().verify().that( target.sendWarn( eq("a warn msg 2"), eq(2) ) );
			inOrder().verify().that( target.sendError( eq("a error msg 2"), eq(2) ) );
			inOrder().verify().that( target.sendFatal( eq("a fatal msg 2"), eq(2) ) );
			inOrder().verify().that( target.sendDebug( eq("[object BitmapData]") ) );
			inOrder().verify().that( target.sendInfo( eq("[object BitmapData]") ) );
			inOrder().verify().that( target.sendWarn( eq("[object BitmapData]") ) );
			inOrder().verify().that( target.sendError( eq("[object BitmapData]") ) );
			inOrder().verify().that( target.sendFatal( eq("[object BitmapData]") ) );
			inOrder().verify().that( target.sendDebug( eq("[object BitmapData]"), eq(bmp) ) );
			inOrder().verify().that( target.sendInfo( eq("[object BitmapData]"), eq(bmp) ) );
			inOrder().verify().that( target.sendWarn( eq("[object BitmapData]"), eq(bmp) ) );
			inOrder().verify().that( target.sendError( eq("[object BitmapData]"), eq(bmp) ) );
			inOrder().verify().that( target.sendFatal( eq("[object BitmapData]"), eq(bmp) ) );
			verifyNothingCalled(target);
		}
		
		override public function tearDown(): void {
			LOGGER_FACTORY.setup = null;
			LogMeister.clearLoggers();
		}
	}
}
