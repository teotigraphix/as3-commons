package org.as3commons.logging.integration {
	import jp.nium.core.debug.Logger;
	import jp.progression.core.debug.Verbose;

	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LOGGER_FACTORY;
	import org.as3commons.logging.getLogger;
	import org.as3commons.logging.level.ERROR;
	import org.as3commons.logging.level.INFO;
	import org.as3commons.logging.level.WARN;
	import org.as3commons.logging.setup.ILogTarget;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.setup.target.Progression4Target;
	import org.as3commons.logging.util.alike;
	import org.as3commons.logging.util.verifyNothingCalled;
	import org.mockito.MockitoTestCase;
	/**
	 * @author mh
	 */
	public class Progression4IntegrationTest  extends MockitoTestCase {
		
		public function Progression4IntegrationTest() {
			super( [ILogTarget] );
		}
		
		public function testIntegration(): void {
			
			var target: ILogTarget = mock( ILogTarget, "Logtarget" );
			
			LOGGER_FACTORY.setup = new SimpleTargetSetup( target );
			
			Logger.enabled = true;
			Logger.loggingFunction = Progression4Integration;
			
			Logger.info( "a log message" );
			Logger.info( "a log message", true );
			Logger.warn( "a warning" );
			Logger.error( "a error" );
			
			inOrder().verify().that( target.log( eq("jp.nium.core.debug.Logger"), eq("Logger"), eq(INFO), anyOf(Number), eq("a log message"), alike([]), eq("Progression")) );
			inOrder().verify().that( target.log( eq("jp.nium.core.debug.Logger"), eq("Logger"), eq(INFO), anyOf(Number), eq("a log message"), alike([]), eq("Progression")) );
			inOrder().verify().that( target.log( eq("jp.nium.core.debug.Logger"), eq("Logger"), eq(WARN), anyOf(Number), eq("a warning"), alike([]), eq("Progression")) );
			inOrder().verify().that( target.log( eq("jp.nium.core.debug.Logger"), eq("Logger"), eq(ERROR), anyOf(Number), eq("a error"), alike([]), eq("Progression")) );
			verifyNothingCalled( target );
		}
		
		public function testLogger(): void {
			var arr: Array = [];
			Logger.loggingFunction = function( ...rest: Array ): void {
				arr.push( rest );
			};
			
			LOGGER_FACTORY.setup = new SimpleTargetSetup( new Progression4Target() );
			
			var logger: ILogger = getLogger( "me" );
			
			logger.info( "a info" );
			logger.error( "an error" );
			logger.warn( "a warning" );
			logger.debug( "a debug" );
			logger.fatal( "a fatal" );
			
			assertObjectEquals( [
				["  [info]", "me a info"],
				["  [error]", "me an error"],
				["  [warn]", "me a warning"],
				["  [info]", "me a debug"],
				["  [error]", "me a fatal"]
			], arr );
		}
		
		override public function tearDown() : void {
			
			Verbose.loggingFunction = null;
			LOGGER_FACTORY.setup = null;
		}
	}
}
