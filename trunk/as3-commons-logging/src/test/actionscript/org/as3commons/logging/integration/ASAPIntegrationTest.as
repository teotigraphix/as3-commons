package org.as3commons.logging.integration {
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.LOGGER_FACTORY;
	import org.as3commons.logging.api.getLogger;
	import org.as3commons.logging.level.DEBUG;
	import org.as3commons.logging.level.ERROR;
	import org.as3commons.logging.level.FATAL;
	import org.as3commons.logging.level.INFO;
	import org.as3commons.logging.level.WARN;
	import org.as3commons.logging.api.ILogTarget;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.setup.target.ASAPTarget;
	import org.asaplibrary.util.debug.Log;
	import org.asaplibrary.util.debug.LogEvent;
	import org.mockito.MockitoTestCase;
	
	/**
	 * @author mh
	 */
	public class ASAPIntegrationTest extends MockitoTestCase {
		public function ASAPIntegrationTest() {
			super([ILogTarget]);
		}
		
		public function testIntegration():void {
			var target: ILogTarget = mock( ILogTarget );
			
			LOGGER_FACTORY.setup = new SimpleTargetSetup( target );
			
			Log.addLogListener( ASAPIntegration );
			
			Log.debug( "A Debug", "my.super::Sender" );
			Log.status( "A Status", "my.super::Sender" );
			Log.info( "A Info", "my.super::Sender" );
			Log.warn( "A Warn", "my.super::Sender" );
			Log.error( "A Error", "my.super::Sender" );
			Log.fatal( "A Fatal", "my.super::Sender" );
			
			inOrder().verify().that( target.log( eq("my.super.Sender"), eq("Sender"), eq(DEBUG), notNull(), eq( "A Debug" ), eq(null), eq("asap"), eq(null), eq(null) ) );
			inOrder().verify().that( target.log( eq("my.super.Sender"), eq("Sender"), eq(INFO), notNull(), eq( "A Status" ), eq(null), eq("asap"), eq(null), eq(null) ) );
			inOrder().verify().that( target.log( eq("my.super.Sender"), eq("Sender"), eq(INFO), notNull(), eq( "A Info" ), eq(null), eq("asap"), eq(null), eq(null) ) );
			inOrder().verify().that( target.log( eq("my.super.Sender"), eq("Sender"), eq(WARN), notNull(), eq( "A Warn" ), eq(null), eq("asap"), eq(null), eq(null) ) );
			inOrder().verify().that( target.log( eq("my.super.Sender"), eq("Sender"), eq(ERROR), notNull(), eq( "A Error" ), eq(null), eq("asap"), eq(null), eq(null) ) );
			inOrder().verify().that( target.log( eq("my.super.Sender"), eq("Sender"), eq(FATAL), notNull(), eq( "A Fatal" ), eq(null), eq("asap"), eq(null), eq(null) ) );
		}
		
		public function testTarget():void {
			
			var storage: Array = [];
			
			Log.addLogListener( function(e:LogEvent):void {
				storage.push( [e.text, e.sender, e.level ] );
			});
			
			LOGGER_FACTORY.setup = new SimpleTargetSetup( new ASAPTarget() );
			
			var logger:ILogger = getLogger( "hello.world" );
			logger.debug( "A Debug{1}{0}", ["1", 2] );
			logger.info( "A Info", [true, "me"] );
			logger.warn( "A Warn", ["a", "b"] );
			logger.error( "A Error", ["max", 1] );
			logger.fatal( "A Fatal", ["mo", "ho"] );
			
			assertObjectEquals(
				[
					["A Debug21", "hello.world", Log.LEVEL_DEBUG],
					["A Info", "hello.world", Log.LEVEL_INFO],
					["A Warn", "hello.world", Log.LEVEL_WARN],
					["A Error", "hello.world", Log.LEVEL_ERROR],
					["A Fatal", "hello.world", Log.LEVEL_FATAL]
				],
				storage
			);
		}
		
		override public function tearDown(): void {
			Log.removeLogListener(ASAPIntegration);
			LOGGER_FACTORY.setup = null;
		}

	}
}
