package org.as3commons.logging.integration {
	import org.as3commons.logging.api.getLogger;
	import org.as3commons.logging.setup.target.FlexLogTarget;
	import mx.logging.ILoggingTarget;
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
		
		private var _target: ILoggingTarget; 
		
		public function FlexIntegrationTest() {
			super([ILogTarget, ILoggingTarget]);
		}
		
		public function testIntegration():void {
			
			var target: ILogTarget = mock( ILogTarget );

			LOGGER_FACTORY.setup = new SimpleTargetSetup(target);
			
			_target = new FlexLogger( LogEventLevel.DEBUG );
			Log.addTarget( _target );
			
			var logger: mx.logging.ILogger = Log.getLogger( "my.package.MyClass" );
			logger.debug( "Hello World" );
			logger.debug( "Hello {0}", "Mario" );
			logger.info( "Hola!" );
			logger.info( "Amigo {0} {1}", "Santa", "Maria" );
			logger.warn( "Como!" );
			logger.error( "Estaz!" );
			logger.fatal( "Santa domingo!" );
			
			inOrder().verify().that( target.log( eq("my.package.MyClass"), eq("MyClass"), eq(DEBUG), notNull(), eq( "Hello World" ), eq(null), eq("flex") ) );
			inOrder().verify().that( target.log( eq("my.package.MyClass"), eq("MyClass"), eq(DEBUG), notNull(), eq( "Hello Mario" ), eq(null), eq("flex") ) );
			inOrder().verify().that( target.log( eq("my.package.MyClass"), eq("MyClass"), eq(INFO), notNull(), eq( "Hola!" ), eq(null), eq("flex") ) );
			inOrder().verify().that( target.log( eq("my.package.MyClass"), eq("MyClass"), eq(INFO), notNull(), eq( "Amigo Santa Maria" ), eq(null), eq("flex") ) );
			inOrder().verify().that( target.log( eq("my.package.MyClass"), eq("MyClass"), eq(WARN), notNull(), eq( "Como!" ), eq(null), eq("flex") ) );
			inOrder().verify().that( target.log( eq("my.package.MyClass"), eq("MyClass"), eq(ERROR), notNull(), eq( "Estaz!" ), eq(null), eq("flex") ) );
			inOrder().verify().that( target.log( eq("my.package.MyClass"), eq("MyClass"), eq(FATAL), notNull(), eq( "Santa domingo!" ), eq(null), eq("flex") ) );
			
			verifyNothingCalled( target );
		}
		
		public function testTarget(): void {
			var target: TestLogger =  new TestLogger();
			_target = target;
			Log.addTarget( _target );
			
			LOGGER_FACTORY.setup = new SimpleTargetSetup( new FlexLogTarget() );
			
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
					[LogEventLevel.DEBUG, "Hello World", "my.package.MyClass"],
					[LogEventLevel.DEBUG, "Hello World", "my.package.MyClass"],
					[LogEventLevel.INFO, "Hola!", "my.package.MyClass"],
					[LogEventLevel.INFO, "Amigo Santa Maria", "my.package.MyClass"],
					[LogEventLevel.WARN, "Como!", "my.package.MyClass"],
					[LogEventLevel.WARN, "Como!", "my.package.MyClass"],
					[LogEventLevel.ERROR, "Estaz!", "my.package.MyClass"],
					[LogEventLevel.ERROR, "Estaz!", "my.package.MyClass"],
					[LogEventLevel.FATAL, "Santa domingo!", "my.package.MyClass"],
					[LogEventLevel.FATAL, "Santa domingo! Dios!", "my.package.MyClass"]
				]
			);
		}
		
		override public function tearDown() : void {
			LOGGER_FACTORY.setup = null;
			Log.removeTarget( _target );
		}
	}
}
import mx.logging.LogLogger;
import mx.logging.LogEventLevel;
import mx.logging.LogEvent;
import mx.logging.ILogger;
import mx.logging.ILoggingTarget;


class TestLogger implements ILoggingTarget {
	
	public var _events: Array = [];
	
	public function addLogger(logger : ILogger) : void {
		logger.addEventListener( LogEvent.LOG, save );
	}

	public function get filters() : Array { return ["*"];}
	
	public function set filters(value : Array) : void {}
	
	public function get level() : int {
		return LogEventLevel.ALL;
	}
	
	public function set level(value : int) : void {}
	
	public function removeLogger(logger : ILogger) : void {
		logger.removeEventListener( LogEvent.LOG, save );
	}
	
	private function save( e: LogEvent ): void {
		_events.push( [ e.level, e.message, LogLogger( e.target ).category ]); 
	}
}