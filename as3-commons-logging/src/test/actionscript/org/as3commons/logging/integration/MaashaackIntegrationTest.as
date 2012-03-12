package org.as3commons.logging.integration {
	import system.logging.LoggerStrings;
	import system.logging.LoggerLevel;
	import org.as3commons.logging.setup.target.MaashaackTarget;
	import system.logging.Logger;
	import system.logging.Log;
	import system.logging.LoggerTarget;

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
	import org.as3commons.logging.util.verifyNothingCalled;
	import org.mockito.MockitoTestCase;

	/**
	 * @author mh
	 */
	public class MaashaackIntegrationTest extends MockitoTestCase {
		private var _target: LoggerTarget;
		
		public function MaashaackIntegrationTest() {
			super([ILogTarget, LoggerTarget]);
		}
		
		public function testIntegration():void {
			
			var target: ILogTarget = mock( ILogTarget );

			LOGGER_FACTORY.setup = new SimpleTargetSetup(target);
			
			_target = new MaashaackIntegration();
			
			Log.addTarget( _target );
			
			var logger: Logger = Log.getLogger( "my.package.MyClass" );
			logger.debug( "Hello World" );
			logger.debug( "Hello {0}", "Mario" );
			logger.info( "Hola!" );
			logger.info( "Amigo {0} {1}", "Santa", "Maria" );
			logger.warn( "Como!" );
			logger.error( "Estaz!" );
			logger.fatal( "Santa domingo!" );
			
			inOrder().verify().that( target.log( eq("my.package.MyClass"), eq("MyClass"), eq(DEBUG), notNull(), eq( "Hello World" ), eq(null), eq("Maashaack"), eq(null), eq(null) ) );
			inOrder().verify().that( target.log( eq("my.package.MyClass"), eq("MyClass"), eq(DEBUG), notNull(), eq( "Hello Mario" ), eq(null), eq("Maashaack"), eq(null), eq(null) ) );
			inOrder().verify().that( target.log( eq("my.package.MyClass"), eq("MyClass"), eq(INFO), notNull(), eq( "Hola!" ), eq(null), eq("Maashaack"), eq(null), eq(null) ) );
			inOrder().verify().that( target.log( eq("my.package.MyClass"), eq("MyClass"), eq(INFO), notNull(), eq( "Amigo Santa Maria" ), eq(null), eq("Maashaack"), eq(null), eq(null) ) );
			inOrder().verify().that( target.log( eq("my.package.MyClass"), eq("MyClass"), eq(WARN), notNull(), eq( "Como!" ), eq(null), eq("Maashaack"), eq(null), eq(null) ) );
			inOrder().verify().that( target.log( eq("my.package.MyClass"), eq("MyClass"), eq(ERROR), notNull(), eq( "Estaz!" ), eq(null), eq("Maashaack"), eq(null), eq(null) ) );
			inOrder().verify().that( target.log( eq("my.package.MyClass"), eq("MyClass"), eq(FATAL), notNull(), eq( "Santa domingo!" ), eq(null), eq("Maashaack"), eq(null), eq(null) ) );
			
			verifyNothingCalled( target );
		}
		
		public function testTarget(): void {
			var target: TestLogTarget =  new TestLogTarget();
			_target = target;
			Log.addTarget( _target );
			
			LOGGER_FACTORY.setup = new SimpleTargetSetup( new MaashaackTarget("{message}") );
			
			var logger: org.as3commons.logging.api.ILogger = getLogger( "my.package.MyClass");
			logger.debug( "Hello World" );
			logger.debug( "Hello {0}", ["World"] );
			logger.info( "Hola!" );
			logger.info("Amigo {0} {1}", ["Santa", "Maria"]);
			logger.warn( "Como!" );
			logger.warn( "Como!", ["Holla!"] );
			logger.error( "Estaz!" );
			logger.error( "Estaz!", ["Amigo"] );
			logger.fatal( "Santa domingo!" );
			logger.fatal( "Santa domingo! {0}", ["Dios!"] );
			
			// I don't know a word of spanish and I hope noone feels insulted :)
			assertObjectEquals( target._events,
				[ 
					[LoggerLevel.DEBUG, "Hello World", "my.package.MyClass"],
					[LoggerLevel.DEBUG, "Hello World", "my.package.MyClass"],
					[LoggerLevel.INFO, "Hola!", "my.package.MyClass"],
					[LoggerLevel.INFO, "Amigo Santa Maria", "my.package.MyClass"],
					[LoggerLevel.WARN, "Como!", "my.package.MyClass"],
					[LoggerLevel.WARN, "Como!", "my.package.MyClass"],
					[LoggerLevel.ERROR, "Estaz!", "my.package.MyClass"],
					[LoggerLevel.ERROR, "Estaz!", "my.package.MyClass"],
					[LoggerLevel.FATAL, "Santa domingo!", "my.package.MyClass"],
					[LoggerLevel.FATAL, "Santa domingo! Dios!", "my.package.MyClass"]
				]
			);
			
			target._events = [];
			
			logger = getLogger( LoggerStrings.INVALID_CHARS);
			logger.debug( "Hello World" );
			assertObjectEquals( target._events,
				[ 
					[LoggerLevel.DEBUG, "Hello World", "Channels can not contain any of the following characters  "],
				]
			);
		}
		
		override public function tearDown() : void {
			LOGGER_FACTORY.setup = null;
			Log.flush();
		}
	}
}
import system.logging.LoggerEntry;
import system.logging.LoggerTarget;

class TestLogTarget extends LoggerTarget {
	
	public var _events: Array = [];
	
	override public function logEntry( entry: LoggerEntry ):void {
		_events.push( [ entry.level, entry.message, entry.channel ]);
	}
}
