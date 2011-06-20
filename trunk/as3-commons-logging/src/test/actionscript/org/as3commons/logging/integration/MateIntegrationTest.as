package org.as3commons.logging.integration {
	import mx.logging.LogEventLevel;
	import org.as3commons.logging.getLogger;
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.setup.target.MateTarget;
	import com.asfusion.mate.core.MateManager;
	import com.asfusion.mate.utils.debug.IMateLogger;

	import org.as3commons.logging.LOGGER_FACTORY;
	import org.as3commons.logging.level.DEBUG;
	import org.as3commons.logging.level.ERROR;
	import org.as3commons.logging.level.FATAL;
	import org.as3commons.logging.level.INFO;
	import org.as3commons.logging.level.WARN;
	import org.as3commons.logging.setup.ILogTarget;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.util.alike;
	import org.mockito.MockitoTestCase;

	/**
	 * @author mh
	 */
	public class MateIntegrationTest extends MockitoTestCase {
		public function MateIntegrationTest() {
			super([ILogTarget]);
		}
		
		public function testIntegration():void {
			var target: ILogTarget = mock( ILogTarget );
			
			LOGGER_FACTORY.setup = new SimpleTargetSetup( target );
			
			new MateIntegration(); // Mate metapher, those guys like it like that.
			
			var logger: IMateLogger = MateManager.instance.getLogger(true);
			logger.debug( "A Debug", "1", 2 );
			logger.info( "A Info", true, "me" );
			logger.warn( "A Warn", "a", "b" );
			logger.error( "A Error", "max", 1 );
			logger.fatal( "A Fatal", "mo", "ho" );
			
			inOrder().verify().that( target.log( eq("com.asfusion.mate"), eq("mate"), eq(DEBUG), notNull(), eq( "A Debug" ), alike(["1",2]), eq("mate") ) );
			inOrder().verify().that( target.log( eq("com.asfusion.mate"), eq("mate"), eq(INFO), notNull(), eq( "A Info" ), alike([true,"me"]), eq("mate") ) );
			inOrder().verify().that( target.log( eq("com.asfusion.mate"), eq("mate"), eq(WARN), notNull(), eq( "A Warn" ), alike(["a","b"]), eq("mate") ) );
			inOrder().verify().that( target.log( eq("com.asfusion.mate"), eq("mate"), eq(ERROR), notNull(), eq( "A Error" ), alike(["max",1]), eq("mate") ) );
			inOrder().verify().that( target.log( eq("com.asfusion.mate"), eq("mate"), eq(FATAL), notNull(), eq( "A Fatal" ), alike(["mo","ho"]), eq("mate") ) );
		}
		
		public function testTarget():void {
			
			var storage: Storage = new Storage();
			
			MateManager.instance.debugger = storage;
			
			LOGGER_FACTORY.setup = new SimpleTargetSetup( new MateTarget() );
			
			var logger:ILogger = getLogger( "hello.world" );
			logger.debug( "A Debug{1}{0}", "1", 2 );
			logger.info( "A Info", true, "me" );
			logger.warn( "A Warn", "a", "b" );
			logger.error( "A Error", "max", 1 );
			logger.fatal( "A Fatal", "mo", "ho" );
			
			assertObjectEquals(
				[
					["A Debug21",LogEventLevel.DEBUG],
					["A Info",LogEventLevel.INFO],
					["A Warn",LogEventLevel.WARN],
					["A Error",LogEventLevel.ERROR],
					["A Fatal",LogEventLevel.FATAL]
				],
				storage.statements
			);
		}
	}
}
import mx.logging.LogEvent;
import mx.logging.ILogger;
import mx.logging.ILoggingTarget;

class Storage implements ILoggingTarget {
	
	private const _statements: Array = [];
	
	public function addLogger( logger: ILogger ): void {
		if( logger ) {
			logger.addEventListener( LogEvent.LOG, handle );
		}
	}
	
	private function handle(event : LogEvent) : void {
		_statements.push( [event.message, event.level] );
	}
	
	public function get filters() : Array {
		return null;
	}

	public function set filters(value : Array) : void {
	}

	public function get level() : int {
		return 0;
	}

	public function set level(value : int) : void {
	}

	public function removeLogger(logger : ILogger) : void {
	}

	public function get statements() : Array {
		return _statements;
	}
}