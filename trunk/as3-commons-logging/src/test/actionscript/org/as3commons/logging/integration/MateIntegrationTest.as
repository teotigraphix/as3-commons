package org.as3commons.logging.integration {
	
	import com.asfusion.mate.utils.debug.ILoggerProvider;
	import com.asfusion.mate.utils.debug.LogInfo;
	import com.asfusion.mate.utils.debug.LogTypes;
	import com.asfusion.mate.core.MateManager;
	import com.asfusion.mate.utils.debug.IMateLogger;
	import mx.logging.LogEventLevel;
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
	import org.as3commons.logging.setup.target.MateTarget;
	import org.mockito.MockitoTestCase;
	
	/**
	 * @author mh
	 */
	public class MateIntegrationTest extends MockitoTestCase {
		
		private static var provider:ILoggerProvider;
		
		public function MateIntegrationTest() {
			provider = new TempLoggingProvider();
			super([ILogTarget]);
		}
		
		public function testIntegration():void {
			var target: ILogTarget = mock( ILogTarget );
			
			LOGGER_FACTORY.setup = new SimpleTargetSetup( target );
			
			new MateIntegration(); // Mate metapher, those guys like it like that.
			
			var logger: IMateLogger = MateManager.instance.getLogger(true);
			
			logger.debug( LogTypes.IS_NOT_AN_EVENT, new LogInfo(provider, this, null, "helloWorld") );
			logger.info( LogTypes.METHOD_NOT_FOUND, new LogInfo(provider, this, null, "helloWorld") );
			logger.warn( LogTypes.SEQUENCE_END, new LogInfo(provider, this, null, "helloWorld") );
			logger.error( LogTypes.SOURCE_NULL, new LogInfo(provider, this, null, "helloWorld") );
			logger.fatal( LogTypes.SEQUENCE_TRIGGER, new LogInfo(provider, this, null, "helloWorld") );
			
			inOrder().verify().that( target.log( eq("com.asfusion.mate"), eq("mate"), eq(DEBUG), notNull(), eq( "Not an Event \n---------------------------------------------------------\n- ERROR: Unable to dispatch MateIntegrationTest because it is not an Event \n- METHOD: helloWorld\n- FILE: null\n- NO ARGUMENTS SUPPLIED \n---------------------------------------------------------\n" ), eq(null), eq("mate") ) );
			inOrder().verify().that( target.log( eq("com.asfusion.mate"), eq("mate"), eq(INFO), notNull(), eq( "Method not found \n---------------------------------------------------------\n- ERROR: Method helloWorld not found in class MateIntegrationTest \n- METHOD: helloWorld\n- FILE: null\n- NO ARGUMENTS SUPPLIED \n---------------------------------------------------------\n" ), eq(null), eq("mate") ) );
			inOrder().verify().that( target.log( eq("com.asfusion.mate"), eq("mate"), eq(WARN), notNull(), eq( "Sequence ended" ), eq(null), eq("mate") ) );
			inOrder().verify().that( target.log( eq("com.asfusion.mate"), eq("mate"), eq(ERROR), notNull(), eq( "Source null" ), eq(null), eq("mate") ) );
			inOrder().verify().that( target.log( eq("com.asfusion.mate"), eq("mate"), eq(FATAL), notNull(), eq( "Sequence triggered" ), eq(null), eq("mate") ) );
		}
		
		public function testTarget():void {
			
			var storage: Storage = new Storage();
			
			MateManager.instance.debugger = storage;
			
			LOGGER_FACTORY.setup = new SimpleTargetSetup( new MateTarget() );
			
			var logger:ILogger = getLogger( "hello.world" );
			logger.debug( "A Debug{1}{0}", ["1", 2] );
			logger.info( "A Info", [true, "me"] );
			logger.warn( "A Warn", ["a", "b"] );
			logger.error( "A Error", ["max", 1] );
			logger.fatal( "A Fatal", ["mo", "ho"] );
			
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
import com.asfusion.mate.utils.debug.IMateLogger;
import com.asfusion.mate.utils.debug.ILoggerProvider;
import mx.logging.LogEvent;
import mx.logging.ILogger;
import mx.logging.ILoggingTarget;

class Storage implements ILoggingTarget {
	
	private const _statements : Array = [];
	
	public function Storage() {}
	
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

class TempLoggingProvider implements ILoggerProvider {
	public function errorString() : String {
		return "";
	}
	
	public function getCurrentTarget() : Object {
		return null;
	}
	
	public function getDocument() : Object {
		return null;
	}
	
	public function getLogger() : IMateLogger {
		return null;
	}
}