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
	import org.as3commons.logging.setup.target.SpiceLibTarget;
	import org.as3commons.logging.util.alike;
	import org.as3commons.logging.util.verifyNothingCalled;
	import org.mockito.MockitoTestCase;
	import org.spicefactory.lib.logging.LogContext;
	import org.spicefactory.lib.logging.Logger;
	

	/**
	 * @author mh
	 */
	public class SpiceLibIntegrationTest extends MockitoTestCase {
		
		public function SpiceLibIntegrationTest() {
			super( [ILogTarget] );
		}
		
		public function testIntegration(): void {
			
			var target: ILogTarget = mock( ILogTarget, "Logtarget" );
			
			LOGGER_FACTORY.setup = new SimpleTargetSetup( target ); 
			
			LogContext.factory = new SpiceLibIntegration();
			
			var logger: Logger = LogContext.getLogger( "test" );
			
			assertEquals( "Name should be same like requested", "test", logger.name );
			
			assertEquals( true, logger.isInfoEnabled()  );
			logger.info( "This is funny!" );
			logger.info( "This is funny!", "me", 1 );
			
			assertEquals( true, logger.isDebugEnabled()  );
			logger.debug( "This is funny!" );
			logger.debug( "This is funny!", "me", 1  );
			
			assertEquals( true, logger.isWarnEnabled() );
			logger.warn( "This is funny!" );
			logger.warn( "This is funny!", "me", 1  );
			
			assertEquals( true, logger.isErrorEnabled()  );
			logger.error( "This is funny!" );
			logger.error( "This is funny!", "me", 1  );
			
			assertEquals( true, logger.isFatalEnabled() );
			logger.fatal( "This is funny!" );
			logger.fatal( "This is funny!", "me", 1  );
			
			inOrder().verify().that( target.log( eq("test"), eq("test"), eq(INFO), anyOf(Number), eq("This is funny!"), eq(null), eq(null), eq(null), eq(null)) );
			inOrder().verify().that( target.log( eq("test"), eq("test"), eq(INFO), anyOf(Number), eq("This is funny!"), alike(["me",1]), eq(null), eq(null), eq(null)) );
			inOrder().verify().that( target.log( eq("test"), eq("test"), eq(DEBUG), anyOf(Number), eq("This is funny!"), eq(null), eq(null), eq(null), eq(null)) );
			inOrder().verify().that( target.log( eq("test"), eq("test"), eq(DEBUG), anyOf(Number), eq("This is funny!"), alike(["me",1]), eq(null), eq(null), eq(null)) );
			inOrder().verify().that( target.log( eq("test"), eq("test"), eq(WARN), anyOf(Number), eq("This is funny!"), eq(null), eq(null), eq(null), eq(null)) );
			inOrder().verify().that( target.log( eq("test"), eq("test"), eq(WARN), anyOf(Number), eq("This is funny!"), alike(["me",1]), eq(null), eq(null), eq(null)) );
			inOrder().verify().that( target.log( eq("test"), eq("test"), eq(ERROR), anyOf(Number), eq("This is funny!"), eq(null), eq(null), eq(null), eq(null)) );
			inOrder().verify().that( target.log( eq("test"), eq("test"), eq(ERROR), anyOf(Number), eq("This is funny!"), alike(["me",1]), eq(null), eq(null), eq(null)) );
			inOrder().verify().that( target.log( eq("test"), eq("test"), eq(FATAL), anyOf(Number), eq("This is funny!"), eq(null), eq(null), eq(null), eq(null)) );
			inOrder().verify().that( target.log( eq("test"), eq("test"), eq(FATAL), anyOf(Number), eq("This is funny!"), alike(["me",1]), eq(null), eq(null), eq(null)) );
			
			LOGGER_FACTORY.setup = null;
			
			assertEquals( false, logger.isDebugEnabled() );
			
			logger.info( "gotta love it" );
			
			verifyNothingCalled( target );
		}
		
		public function testLogger(): void {
			
			var factory: TestFactory = new TestFactory();
			
			LogContext.factory = factory;
			
			LOGGER_FACTORY.setup = new SimpleTargetSetup( new SpiceLibTarget() );
			
			var logger: ILogger = getLogger("moose");
			
			logger.info( "A Info" );
			logger.debug( "A Debug" );
			logger.warn( "A Warn" );
			logger.error( "A Error" );
			logger.fatal( "A Fatal" );
			
			
			var log: Array = factory.log;
			assertTrue( new Log( INFO,  "A Info",  "moose", [] ).equals( log[0] ) );
			assertTrue( new Log( DEBUG, "A Debug", "moose", [] ).equals( log[1] ) );
			assertTrue( new Log( WARN,  "A Warn",  "moose", [] ).equals( log[2] ) );
			assertTrue( new Log( ERROR, "A Error", "moose", [] ).equals( log[3] ) );
			assertTrue( new Log( FATAL, "A Fatal", "moose", [] ).equals( log[4] ) );
		}
		
		override public function tearDown() : void {
			LOGGER_FACTORY.setup = null;
		}
	}
}

import org.as3commons.logging.level.DEBUG;
import org.as3commons.logging.level.ERROR;
import org.as3commons.logging.level.FATAL;
import org.as3commons.logging.level.INFO;
import org.as3commons.logging.level.WARN;
import org.spicefactory.lib.logging.LogFactory;
import org.spicefactory.lib.logging.Logger;

class TestFactory implements LogFactory {
	
	private const _cache: Object = {};
	private const _log: Array = [];
	
	public function TestFactory() {
	}
	
	public function get log(): Array {
		return _log;
	}
	
	public function getLogger(name : Object) : Logger {
		var namestr: String = name.toString();
		return _cache[ namestr ] || ( _cache[ namestr ] = new TestLogger(namestr, _log) );
	}
}

class TestLogger implements Logger {
	
	private var _name: String;
	private var _log: Array;
	
	public function TestLogger( name: String, log: Array ) {
		_name = name;
		_log = log;
	}

	
	public function debug( message: String, ...args: * ): void {
		log( message, args, DEBUG );
	}
	
	public function error( message: String, ...args: * ): void {
		log( message, args, ERROR );
	}
	
	public function fatal( message: String, ...args: * ): void {
		log( message, args, FATAL );
	}
	
	public function info( message: String, ...args: * ): void {
		log( message, args, INFO );
	}
	
	public function trace( message: String, ...args: * ): void {
		log( message, args, WARN );
	}
	
	public function warn( message: String, ...args: * ): void {
		log( message, args, WARN );
	}
	
	public function isDebugEnabled(): Boolean {
		return true;
	}
	
	public function isErrorEnabled(): Boolean {
		return true;
	}
	
	public function isFatalEnabled(): Boolean {
		return true;
	}
	
	public function isInfoEnabled(): Boolean {
		return true;
	}
	
	public function isTraceEnabled() : Boolean {
		return true;
	}
	
	public function isWarnEnabled() : Boolean {
		return true;
	}
	
	private function log( message: String, args: Array, level: int ): void {
		_log.push( new Log( level, message, _name, args ) );
	}
	
	public function get name() : String {
		return _name;
	}
}

class Log {
	
	public var message: String;
	public var name: String;
	public var args: Array;
	public var level: int;
	
	public function Log( level: int, message: String, name: String, args: Array ) {
		this.level = level;
		this.message = message;
		this.name = name;
		this.args = args;
	}

	public function equals(log:Log): Boolean {
		return log.message == message 
			&& log.level == level
			&& log.name == name;
	}

}