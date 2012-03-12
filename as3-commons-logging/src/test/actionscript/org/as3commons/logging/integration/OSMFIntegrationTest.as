package org.as3commons.logging.integration {
	import org.as3commons.logging.setup.target.OSMFTarget;
	import org.as3commons.logging.util.alike;
	import org.as3commons.logging.api.LOGGER_FACTORY;
	import org.as3commons.logging.level.ERROR;
	import org.as3commons.logging.level.INFO;
	import org.as3commons.logging.level.WARN;
	import org.as3commons.logging.api.ILogTarget;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.util.verifyNothingCalled;
	import org.mockito.MockitoTestCase;
	import org.osmf.logging.Log;
	import org.osmf.logging.Logger;

	/**
	 * @author mh
	 */
	public class OSMFIntegrationTest extends MockitoTestCase {
		public function OSMFIntegrationTest() {
			super([ILogTarget]);
		}
		
		public function testIntegration(): void {
			
			var target: ILogTarget = mock( ILogTarget, "Logtarget" );
			
			LOGGER_FACTORY.setup = new SimpleTargetSetup( target );
			
			Log.loggerFactory = new OSMFIntegration();
			
			var logger: Logger = Log.getLogger("this.is.a.Logger");
			
			logger.info( "a log message" );
			logger.info( "a log message", true );
			logger.warn( "a warning" );
			logger.error( "a error" );
			
			inOrder().verify().that( target.log( eq("this.is.a.Logger"), eq("Logger"), eq(INFO), anyOf(Number), eq("a log message"), alike([]), eq("OSMF"), eq(null), eq(null)) );
			inOrder().verify().that( target.log( eq("this.is.a.Logger"), eq("Logger"), eq(INFO), anyOf(Number), eq("a log message"), alike([true]), eq("OSMF"), eq(null), eq(null)) );
			inOrder().verify().that( target.log( eq("this.is.a.Logger"), eq("Logger"), eq(WARN), anyOf(Number), eq("a warning"), alike([]), eq("OSMF"), eq(null), eq(null)) );
			inOrder().verify().that( target.log( eq("this.is.a.Logger"), eq("Logger"), eq(ERROR), anyOf(Number), eq("a error"), alike([]), eq("OSMF"), eq(null), eq(null)) );
			verifyNothingCalled( target );
		}
		
		public function testLogger(): void {
			Log.loggerFactory = new TFactory();
			
			LOGGER_FACTORY.setup = new SimpleTargetSetup( new OSMFTarget() );
			
			var logger: Logger = Log.getLogger( "me" );
			logger.info( "a info" );
			logger.error( "an error", 1 );
			logger.warn( "a warning", 4 );
			logger.debug( "a debug" );
			logger.fatal( "a fatal" );
			
			assertObjectEquals( [
				"info", "a info", [],
				"error", "an error", [1],
				"warn", "a warning", [4],
				"debug", "a debug", [],
				"fatal", "a fatal", []
			], TLogger.stack );
		}
		
		override public function tearDown() : void {
			Log.loggerFactory = null;
			LOGGER_FACTORY.setup = null;
		}
	}
}
import org.osmf.logging.LoggerFactory;
import org.osmf.logging.Logger;

class TFactory extends LoggerFactory {
	
	private var _loggers: Object = {};
	
	override public function getLogger(name: String) : Logger {
		return _loggers[name] || (_loggers[name] || new TLogger(name));
	}
}

class TLogger extends Logger {
	
	public static const stack : Array = [];
	
	public function TLogger(name:String) {
		super(name);
	}
	
	override public function debug(message: String, ...args) : void {
		stack.push("debug");
		stack.push(message);
		stack.push(args);
	}
	
	override public function info(message: String, ...args) : void {
		stack.push("info");
		stack.push(message);
		stack.push(args);
	}
	
	override public function warn(message: String, ...args) : void {
		stack.push("warn");
		stack.push(message);
		stack.push(args);
	}
	
	override public function error(message: String, ...args) : void {
		stack.push("error");
		stack.push(message);
		stack.push(args);
	}
	
	override public function fatal(message: String, ...args) : void {
		stack.push("fatal");
		stack.push(message);
		stack.push(args);
	}
}