package org.as3commons.logging.integration {
	import org.as3commons.logging.util.alike;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.LOGGER_FACTORY;
	import org.as3commons.logging.api.getLogger;
	import org.as3commons.logging.level.DEBUG;
	import org.as3commons.logging.level.ERROR;
	import org.as3commons.logging.level.FATAL;
	import org.as3commons.logging.level.INFO;
	import org.as3commons.logging.level.WARN;
	import org.as3commons.logging.setup.ILogTarget;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.setup.target.Log5FTarget;
	import org.as3commons.logging.util.verifyNothingCalled;
	import org.log5f.Level;
	import org.log5f.Logger;
	import org.log5f.LoggerManager;
	import org.log5f.core.IAppender;
	import org.log5f.core.config.tags.ConfigurationTag;
	import org.log5f.core.config.tags.LoggerTag;
	import org.mockito.MockitoTestCase;

	/**
	 * @author mh
	 */
	public class Log5FIntegrationTest extends MockitoTestCase {
		
		private static var _inited: Boolean = false;
		
		public static function init():void {
			if( !_inited ) {
				_inited = true;
				
			}
		}
		
		override public function setUp() : void {
			init();
			stack = [];
		}
		
		public function Log5FIntegrationTest() {
			super([IAppender, ILogTarget]);
		}
		
		public function testIntegration():void {
			var target: ILogTarget = mock( ILogTarget, "Logtarget" );
			var testAppender: TestAppender = new TestAppender;
			
			LOGGER_FACTORY.setup = new SimpleTargetSetup( target );
			
			var tag: LoggerTag = new LoggerTag();
			tag.appenders = [new Log5FIntegration()];
			tag.level = "ALL";
			
			var tag2: LoggerTag = new LoggerTag();
			tag2.appenders = [testAppender];
			tag2.level = "ALL";
			
			var setup: ConfigurationTag = new ConfigurationTag();
			setup.objects = [tag, tag2];
			
			LoggerManager.configure(setup);
			
			var logger: Logger = LoggerManager.getLogger("my.Test");
			
			logger.info( "a log message" );
			logger.warn( "a warning" );
			logger.error( "a error" );
			logger.fatal( "a fatal msg" );
			logger.debug( "a debug msg" );
			
			logger.info( "a log message", true );
			logger.warn( "a warning", true );
			logger.error( "a error", true );
			logger.fatal( "a fatal msg", true );
			logger.debug( "a debug msg", true );
			
			inOrder().verify().that( target.log( eq("my.Test"), eq("Test"), eq(INFO), anyOf(Number), eq("a log message"), eq(null), eq("log5f")) );
			inOrder().verify().that( target.log( eq("my.Test"), eq("Test"), eq(WARN), anyOf(Number), eq("a warning"), eq(null), eq("log5f")) );
			inOrder().verify().that( target.log( eq("my.Test"), eq("Test"), eq(ERROR), anyOf(Number), eq("a error"), eq(null), eq("log5f")) );
			inOrder().verify().that( target.log( eq("my.Test"), eq("Test"), eq(FATAL), anyOf(Number), eq("a fatal msg"), eq(null), eq("log5f")) );
			inOrder().verify().that( target.log( eq("my.Test"), eq("Test"), eq(DEBUG), anyOf(Number), eq("a debug msg"), eq(null), eq("log5f")) );
			
			inOrder().verify().that( target.log( eq("my.Test"), eq("Test"), eq(INFO), anyOf(Number), eq("{0},{1}"), alike(["a log message", true]), eq("log5f")) );
			inOrder().verify().that( target.log( eq("my.Test"), eq("Test"), eq(WARN), anyOf(Number), eq("{0},{1}"), alike(["a warning", true]), eq("log5f")) );
			inOrder().verify().that( target.log( eq("my.Test"), eq("Test"), eq(ERROR), anyOf(Number), eq("{0},{1}"), alike(["a error", true]), eq("log5f")) );
			inOrder().verify().that( target.log( eq("my.Test"), eq("Test"), eq(FATAL), anyOf(Number), eq("{0},{1}"), alike(["a fatal msg", true]), eq("log5f")) );
			inOrder().verify().that( target.log( eq("my.Test"), eq("Test"), eq(DEBUG), anyOf(Number), eq("{0},{1}"), alike(["a debug msg", true]), eq("log5f")) );
			verifyNothingCalled( target );	
			
			LOGGER_FACTORY.setup = new SimpleTargetSetup( new Log5FTarget("{message}") );
			
			stack = [];
			
			var as3log: ILogger = getLogger(this);
			as3log.debug("a debug msg");
			as3log.info("a info msg");
			as3log.warn("a warn msg");
			as3log.error("a error msg");
			as3log.fatal("a fatal msg");
			
			as3log.debug("a debug msg {0}", [2]);
			as3log.info("a info msg {0}", [2]);
			as3log.warn("a warn msg {0}", [2]);
			as3log.error("a error msg {0}", [2]);
			as3log.fatal("a fatal msg {0}", [2]);
			
			assertObjectEquals(["org.as3commons.logging.integration.Log5FIntegrationTest", Level.DEBUG, ["a debug msg"]],stack.shift());
			assertObjectEquals(["org.as3commons.logging.integration.Log5FIntegrationTest", Level.INFO, ["a info msg"]],stack.shift());
			assertObjectEquals(["org.as3commons.logging.integration.Log5FIntegrationTest", Level.WARN, ["a warn msg"]],stack.shift());
			assertObjectEquals(["org.as3commons.logging.integration.Log5FIntegrationTest", Level.ERROR, ["a error msg"]],stack.shift());
			assertObjectEquals(["org.as3commons.logging.integration.Log5FIntegrationTest", Level.FATAL, ["a fatal msg"]],stack.shift());
			assertObjectEquals(["org.as3commons.logging.integration.Log5FIntegrationTest", Level.DEBUG, ["a debug msg 2"]],stack.shift());
			assertObjectEquals(["org.as3commons.logging.integration.Log5FIntegrationTest", Level.INFO, ["a info msg 2"]],stack.shift());
			assertObjectEquals(["org.as3commons.logging.integration.Log5FIntegrationTest", Level.WARN, ["a warn msg 2"]],stack.shift());
			assertObjectEquals(["org.as3commons.logging.integration.Log5FIntegrationTest", Level.ERROR, ["a error msg 2"]],stack.shift());
			assertObjectEquals(["org.as3commons.logging.integration.Log5FIntegrationTest", Level.FATAL, ["a fatal msg 2"]],stack.shift());
		}
		
		override public function tearDown(): void {
			LOGGER_FACTORY.setup = null;
		}
	}
}
import org.log5f.core.Appender;
import org.log5f.events.LogEvent;
import org.log5f.layouts.SimpleLayout;

var stack: Array = [];

class TestAppender extends Appender {
	public function TestAppender() {
		layout = new SimpleLayout();
	}

	override protected function append(event:LogEvent):void {
		stack.push([event.category.name, event.level, event.message ]);
	}
}
