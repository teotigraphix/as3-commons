package org.as3commons.logging {
	import org.as3commons.logging.impl.NameBasedLoggerFactory;
	import org.mockito.MockitoTestCase;

	/**
	 * @author Martin
	 */
	public class BasicLoggingTest extends MockitoTestCase {
		private var _logger:ILogger;
		private var _factory:NameBasedLoggerFactory;

		public function BasicLoggingTest() {
			super([ILogTarget]);
		}

		[Before]
		override public function setUp():void {
			super.setUp();
			_logger = LoggerFactory.getLogger("");
		}

		public function testlogEnabled():void {
			var logTarget:ILogTarget = ILogTarget(mock(ILogTarget));
			var myObject:Object = {};
			
			_factory = new NameBasedLoggerFactory();
			_factory.setLogger(_logger.name, new TestLoggerFactory(logTarget));
			LoggerFactory.loggerFactory = _factory;
			
			given(logTarget.debugEnabled).willReturn(true);
			if( _logger.debugEnabled ) {
				verify().that(logTarget.debugEnabled);
				_logger.debug("Hello World", 1, 2, myObject);
				verify().that(logTarget.debug(eq(""), eq("Hello World"), eq([1, 2, myObject])));
			} else {
				fail("The Logsystem tells logging is not enabled - even if its enabled @ debug");
			}
			
			given(logTarget.infoEnabled).willReturn(true);
			if( _logger.infoEnabled ) {
				verify().that(logTarget.infoEnabled);
				_logger.info("Hello World", 1, 2, myObject);
				verify().that(logTarget.info(eq(""), eq( "Hello World" ), eq([1, 2, myObject])));
			} else {
				fail("The Logsystem tells logging is not enabled - even if its enabled @ info.");
			}
			
			given(logTarget.warnEnabled).willReturn(true);
			if( _logger.warnEnabled ) {
				verify().that(logTarget.warnEnabled);
				_logger.warn("Hello World", 1, 2, myObject);
				verify().that(logTarget.warn(eq(""), eq( "Hello World" ), eq([1, 2, myObject])));
			} else {
				fail("The Logsystem tells logging is not enabled - even if its enabled @ warn.");
			}
			
			given(logTarget.errorEnabled).willReturn(true);
			if( _logger.errorEnabled ) {
				verify().that(logTarget.errorEnabled);
				_logger.error("Hello World", 1, 2, myObject);
				verify().that(logTarget.error(eq(""), eq( "Hello World" ), eq([1, 2, myObject])));
			} else {
				fail("The Logsystem tells logging is not enabled - even if its enabled @ error.");
			}
			
			given(logTarget.fatalEnabled).willReturn(true);
			if( _logger.fatalEnabled ) {
				verify().that(logTarget.fatalEnabled);
				_logger.fatal("Hello World", 1, 2, myObject);
				verify().that(logTarget.fatal(eq(""), eq( "Hello World" ), eq([1, 2, myObject])));
			} else {
				fail("The Logsystem tells logging is not enabled - even if its enabled @ fatal.");
			}
		}

		[Test]
		public function testlogDisabled():void {
			var logTarget:ILogTarget = ILogTarget(mock(ILogTarget));
			
			_factory = new NameBasedLoggerFactory();
			_factory.setLogger(_logger.name, new TestLoggerFactory(logTarget));
			LoggerFactory.loggerFactory = _factory;
			
			given(logTarget.debugEnabled).willReturn(false);
			if( _logger.debugEnabled ) {
				fail("The Logsystem tells logging is enabled - even if was disabled @ debug");
			} else {
				_logger.debug("Hello");
				verify().that( logTarget.debug( "", "Hello", eq([])) );
			}
			
			given(logTarget.infoEnabled).willReturn(false);
			if( _logger.infoEnabled ) {
				fail("The Logsystem tells logging is enabled - even if was disabled @ info");
			} else {
				_logger.info();
				verify().that( logTarget.info( "", null, eq([])) );
			}
			given(logTarget.warnEnabled).willReturn(false);
			if( _logger.warnEnabled ) {
				fail("The Logsystem tells logging is enabled - even if was disabled @ warn");
			} else {
				_logger.warn();
				verify().that( logTarget.warn( "", null, eq([])) );
			}
			
			given(logTarget.errorEnabled).willReturn(false);
			if( _logger.errorEnabled ) {
				fail("The Logsystem tells logging is enabled - even if was disabled @ error");
			} else {
				_logger.error();
				verify().that( logTarget.error( "", null, eq([])) );
			}
			
			given(logTarget.fatalEnabled).willReturn(false);
			if( _logger.fatalEnabled ) {
				fail("The Logsystem tells logging is enabled - even if was disabled @ fatal");
			} else {
				_logger.fatal();
				verify().that( logTarget.fatal( "", null, eq([])) );
			}
		}

		[Test]
		public function testTemptyLogger():void {
			_factory = new NameBasedLoggerFactory();
			_factory.setLogger(_logger.name, null );
			LoggerFactory.loggerFactory = _factory;
			
			assertFalse( _logger.debugEnabled );
			assertFalse( _logger.infoEnabled );
			assertFalse( _logger.warnEnabled );
			assertFalse( _logger.errorEnabled );
			assertFalse( _logger.fatalEnabled );
		}
		
		[After]
		override public function tearDown():void {
			super.tearDown();
			LoggerFactory.loggerFactory = null;
		}
	}
}

import org.as3commons.logging.ILogTargetFactory;
import org.as3commons.logging.ILogTarget;

class TestLoggerFactory implements ILogTargetFactory {
	private var _logger:ILogTarget;

	public function TestLoggerFactory(logger:ILogTarget) {
		_logger = logger;
	}

	public function getLogTarget(name:String):ILogTarget {
		return _logger;
	}
}
