package org.as3commons.logging.integration {
	import jp.progression.core.debug.Verbose;

	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LOGGER_FACTORY;
	import org.as3commons.logging.getLogger;
	import org.as3commons.logging.level.ERROR;
	import org.as3commons.logging.level.INFO;
	import org.as3commons.logging.level.WARN;
	import org.as3commons.logging.setup.ILogTarget;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.setup.target.Progression3Target;
	import org.as3commons.logging.util.alike;
	import org.as3commons.logging.util.verifyNothingCalled;
	import org.mockito.MockitoTestCase;

	import flash.display.Sprite;
	/**
	 * @author mh
	 */
	public class Progression3IntegrationTest  extends MockitoTestCase {
		
		public function Progression3IntegrationTest() {
			super( [ILogTarget] );
		}
		
		public function testIntegration(): void {
			
			var target: ILogTarget = mock( ILogTarget, "Logtarget" );
			
			LOGGER_FACTORY.setup = new SimpleTargetSetup( target );
			
			Verbose.enabled = true;
			Verbose.loggingFunction = Progression3Integration;
			
			var sprite: Sprite = new Sprite();
			
			Verbose.log( null, "a log message" );
			Verbose.log( null, "a log message", true );
			Verbose.warning( null, "a warning" );
			Verbose.error( sprite, "a error" );
			
			inOrder().verify().that( target.log( eq("jp.progression.core.debug.Verbose"), eq("Verbose"), eq(INFO), anyOf(Number), eq("a log message"), alike([]), eq("Progression")) );
			inOrder().verify().that( target.log( eq("jp.progression.core.debug.Verbose"), eq("Verbose"), eq(INFO), anyOf(Number), eq("a log message"), alike([]), eq("Progression")) );
			inOrder().verify().that( target.log( eq("jp.progression.core.debug.Verbose"), eq("Verbose"), eq(WARN), anyOf(Number), eq("a warning"), alike([]), eq("Progression")) );
			inOrder().verify().that( target.log( eq("jp.progression.core.debug.Verbose"), eq("Verbose"), eq(ERROR), anyOf(Number), eq("a error"), alike([]), eq("Progression")) );
			verifyNothingCalled( target );
		}
		
		public function testLogger(): void {
			var arr: Array = [];
			Verbose.enabled = true;
			Verbose.loggingFunction = function( message: String, ...rest: Array ): void {
				arr.push( message );
			};
			
			LOGGER_FACTORY.setup = new SimpleTargetSetup( new Progression3Target() );
			
			var logger: ILogger = getLogger( "me" );
			
			logger.info( "a info" );
			logger.error( "an error" );
			logger.warn( "a warning" );
			logger.debug( "a debug" );
			logger.fatal( "a fatal" );
			
			assertObjectEquals( [
				"[LOG] me a info",
				"[ERROR] me an error",
				"[WARNING] me a warning",
				"[LOG] me a debug",
				"[ERROR] me a fatal"
			], arr );
		}
		
		override public function tearDown() : void {
			
			Verbose.loggingFunction = null;
			LOGGER_FACTORY.setup = null;
		}
	}
}
