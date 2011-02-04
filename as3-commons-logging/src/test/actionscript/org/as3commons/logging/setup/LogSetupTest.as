package org.as3commons.logging.setup {
	import org.as3commons.logging.getNamedLogger;
	import org.as3commons.logging.getLogger;
	import org.as3commons.logging.LOGGER_FACTORY;
	import org.as3commons.logging.ILogSetup;
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.setup.LogSetupLevel;
	import org.as3commons.logging.setup.LevelTargetSetup;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.level.*;
	import org.as3commons.logging.setup.ILogTarget;
	import org.as3commons.logging.util.AClass;
	import org.as3commons.logging.util.alike;
	import org.as3commons.logging.util.verifyNothingCalled;
	import org.mockito.MockitoTestCase;

	import flash.utils.getQualifiedClassName;

	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public class LogSetupTest extends MockitoTestCase {
		
		private var _logger:ILogger;
		
		public function LogSetupTest() {
			super([ILogTarget,ILogSetup]);
		}
		
		[Before]
		override public function setUp():void {
			super.setUp();
			LOGGER_FACTORY.setup = null;
			_logger = LOGGER_FACTORY.getNamedLogger("");
		}
		
		public function testAccess(): void {
			assertStrictlyEquals(getLogger(""), getLogger(""));
			assertStrictlyEquals(getLogger("test.more"), getLogger("test.more"));
			assertStrictlyEquals(getLogger(null), getLogger(null));
			assertStrictlyEquals(getLogger(null), getLogger("null") );
			assertStrictlyEquals(getLogger(undefined), getLogger(undefined));
			assertStrictlyEquals(getLogger(undefined), getLogger("void"));
			
			var aLogger: ILogger = getLogger( AClass );
			var bLogger: ILogger = getLogger( new AClass );
			var cLogger: ILogger = getLogger( getQualifiedClassName( AClass ).replace( "::", "." ) );
			var dLogger: ILogger = getLogger( getQualifiedClassName( new AClass ).replace( "::", "." ) );
			var gLogger: ILogger = getNamedLogger( getQualifiedClassName( AClass ).replace( "::", "." ) );
			var hLogger: ILogger = getNamedLogger( getQualifiedClassName( new AClass ).replace( "::", "." ) );
			
			assertFalse( _logger == aLogger );
			
			assertStrictlyEquals( aLogger, bLogger );
			assertStrictlyEquals( bLogger, cLogger );
			assertStrictlyEquals( dLogger, gLogger );
			assertStrictlyEquals( gLogger, hLogger );
		}
		
		public function testEmptyCase(): void {
			var setup : ILogSetup = new SimpleTargetSetup(null);
			LOGGER_FACTORY.setup = setup;
			
			// None of these should throw an exception
			_logger.debug( "hello world" );
			_logger.info( "hello world" );
			_logger.warn( "hello world" );
			_logger.error( "hello world" );
			_logger.fatal( "hello world" );
		}

		public function testTargetIntegration():void {
			var logTarget:ILogTarget = mock(ILogTarget);
			var myObject:Object = {};
			
			var setup: LevelTargetSetup = new LevelTargetSetup(logTarget, LogSetupLevel.DEBUG);
			LOGGER_FACTORY.setup = setup;
			verifyNothingCalled( logTarget );
			if(    _logger.debugEnabled
				&& _logger.infoEnabled
				&& _logger.warnEnabled
				&& _logger.errorEnabled
				&& _logger.fatalEnabled ) {
				_logger.debug("debug1", 1, 2, myObject);
				_logger.info( "info1",  1, 2, myObject);
				_logger.warn( "warn1",  1, 2, myObject);
				_logger.error("error1", 1, 2, myObject);
				_logger.fatal("fatal1", 1, 2, myObject);
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(DEBUG), anyOf(Number), eq("debug1"), alike([1, 2, myObject])));
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(INFO),  anyOf(Number), eq("info1"),  alike([1, 2, myObject])));
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(WARN),  anyOf(Number), eq("warn1"),  alike([1, 2, myObject])));
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(ERROR), anyOf(Number), eq("error1"), alike([1, 2, myObject])));
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(FATAL), anyOf(Number), eq("fatal1"), alike([1, 2, myObject])));
			} else {
				fail("The Logsystem tells logging is not properly enabled @ debug");
			}
			
			LOGGER_FACTORY.setup = new LevelTargetSetup(logTarget,LogSetupLevel.DEBUG_ONLY);
			verifyNothingCalled( logTarget );
			if(     _logger.debugEnabled
				&& !_logger.infoEnabled
				&& !_logger.warnEnabled
				&& !_logger.errorEnabled
				&& !_logger.fatalEnabled ) {
				_logger.debug("debug2", 1, 2, myObject);
				_logger.info("Should not be called");
				_logger.warn("Should not be called");
				_logger.error("Should not be called");
				_logger.fatal("Should not be called");
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(DEBUG), anyOf(Number), eq("debug2"), alike([1, 2, myObject]) ));
			} else {
				fail("The Logsystem tells logging is not properly enabled @ debug-only");
			}
			
			LOGGER_FACTORY.setup = new LevelTargetSetup( logTarget,LogSetupLevel.INFO);
			
			verifyNothingCalled( logTarget );
			if(    !_logger.debugEnabled
				&&  _logger.infoEnabled
				&&  _logger.warnEnabled
				&&  _logger.errorEnabled
				&&  _logger.fatalEnabled ) {
				_logger.debug("Should not be called");
				_logger.info("info3", 1, 2, myObject);
				_logger.warn("warn3", 1, 2, myObject);
				_logger.error("error3", 1, 2, myObject);
				_logger.fatal("fatal3", 1, 2, myObject);
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(INFO), anyOf(Number), eq( "info3" ), alike([1, 2, myObject])));
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(WARN), anyOf(Number), eq( "warn3" ), alike([1, 2, myObject])));
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(ERROR), anyOf(Number), eq( "error3" ), alike([1, 2, myObject])));
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(FATAL), anyOf(Number), eq( "fatal3" ), alike([1, 2, myObject])));
			} else {
				fail("The Logsystem tells logging is not enabled @ info.");
			}
			
			LOGGER_FACTORY.setup = new LevelTargetSetup( logTarget,LogSetupLevel.INFO_ONLY);
			
			verifyNothingCalled( logTarget );
			if(    !_logger.debugEnabled
				&&  _logger.infoEnabled
				&& !_logger.warnEnabled
				&& !_logger.errorEnabled
				&& !_logger.fatalEnabled ) {
				_logger.debug("Should not be called");
				_logger.info("info4", 1, 2, myObject);
				_logger.warn("Should not be called");
				_logger.error("Should not be called");
				_logger.fatal("Should not be called");
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(INFO), anyOf(Number), eq("info4"), alike([1, 2, myObject]) ));
			} else {
				fail("The Logsystem tells logging is not properly enabled @ info-only");
			}
			
			LOGGER_FACTORY.setup = new LevelTargetSetup( logTarget,LogSetupLevel.WARN);
			
			verifyNothingCalled( logTarget );
			if(    !_logger.debugEnabled
				&& !_logger.infoEnabled
				&&  _logger.warnEnabled
				&&  _logger.errorEnabled
				&&  _logger.fatalEnabled ) {
				_logger.debug("Should not be called");
				_logger.info("Should not be called");
				_logger.warn("warn5", 1, 2, myObject);
				_logger.error("error5", 1, 2, myObject);
				_logger.fatal("fatal5", 1, 2, myObject);
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(WARN), anyOf(Number), eq( "warn5" ), alike([1, 2, myObject])));
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(ERROR), anyOf(Number), eq( "error5" ), alike([1, 2, myObject])));
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(FATAL), anyOf(Number), eq( "fatal5" ), alike([1, 2, myObject])));
			} else {
				fail("The Logsystem tells logging is not enabled @ warn.");
			}
			
			
			LOGGER_FACTORY.setup = new LevelTargetSetup( logTarget,LogSetupLevel.WARN_ONLY);
			
			verifyNothingCalled( logTarget );
			if(    !_logger.debugEnabled
				&& !_logger.infoEnabled
				&&  _logger.warnEnabled
				&& !_logger.errorEnabled
				&& !_logger.fatalEnabled ) {
				_logger.debug("Should not be called");
				_logger.info("Should not be called");
				_logger.warn("warn6", 1, 2, myObject);
				_logger.error("Should not be called");
				_logger.fatal("Should not be called");
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(WARN), anyOf(Number), eq("warn6"), alike([1, 2, myObject]) ));
			} else {
				fail("The Logsystem tells logging is not properly enabled @ warn-only");
			}
			
			LOGGER_FACTORY.setup = new LevelTargetSetup( logTarget,LogSetupLevel.ERROR);
			
			verifyNothingCalled( logTarget );
			if(    !_logger.debugEnabled
				&& !_logger.infoEnabled
				&& !_logger.warnEnabled
				&&  _logger.errorEnabled
				&&  _logger.fatalEnabled ) {
				_logger.debug("Should not be called");
				_logger.info("Should not be called");
				_logger.warn("Should not be called");
				_logger.error("error7", 1, 2, myObject);
				_logger.fatal("fatal7", 1, 2, myObject);
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(ERROR), anyOf(Number), eq( "error7" ), alike([1, 2, myObject])));
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(FATAL), anyOf(Number), eq( "fatal7" ), alike([1, 2, myObject])));
			} else {
				fail("The Logsystem tells logging is not enabled @ error.");
			}
			
			LOGGER_FACTORY.setup = new LevelTargetSetup( logTarget,LogSetupLevel.ERROR_ONLY);
			
			verifyNothingCalled( logTarget );
			if(    !_logger.debugEnabled
				&& !_logger.infoEnabled
				&& !_logger.warnEnabled
				&&  _logger.errorEnabled
				&& !_logger.fatalEnabled ) {
				_logger.debug("Should not be called");
				_logger.info("Should not be called");
				_logger.warn("Should not be called");
				_logger.error("error8", 1, 2, myObject);
				_logger.fatal("Should not be called");
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(ERROR), anyOf(Number), eq("error8"), alike([1, 2, myObject]) ));
			} else {
				fail("The Logsystem tells logging is not properly enabled @ error-only");
			}
			
			LOGGER_FACTORY.setup = new LevelTargetSetup( logTarget,LogSetupLevel.FATAL);
			
			verifyNothingCalled( logTarget );
			if(    !_logger.debugEnabled
				&& !_logger.infoEnabled
				&& !_logger.warnEnabled
				&& !_logger.errorEnabled
				&&  _logger.fatalEnabled ) {
				_logger.debug("Should not be called");
				_logger.info("Should not be called");
				_logger.warn("Should not be called");
				_logger.error("Should not be called");
				_logger.fatal("fatal9", 1, 2, myObject);
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(FATAL), anyOf(Number), eq( "fatal9" ), alike([1, 2, myObject])));
			} else {
				fail("The Logsystem tells logging is not enabled @ fatal.");
			}
			
			LOGGER_FACTORY.setup = new LevelTargetSetup( logTarget,LogSetupLevel.NONE);
			
			verifyNothingCalled( logTarget );
			if(    !_logger.debugEnabled
				&& !_logger.infoEnabled
				&& !_logger.warnEnabled
				&& !_logger.errorEnabled
				&& !_logger.fatalEnabled ) {
				_logger.debug("Should not be called");
				_logger.info("Should not be called");
				_logger.warn("Should not be called");
				_logger.error("Should not be called");
				_logger.fatal("Should not be called");
				logTarget.log("", "", DEBUG, 123.0, "test", null);
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(DEBUG), anyOf(Number), eq( "test" ), eq(null)));
			} else {
				fail("The Logsystem tells logging is not enabled @ fatal.");
			}
			
			
			LOGGER_FACTORY.setup = new LevelTargetSetup( logTarget,LogSetupLevel.DEBUG_ONLY.or( LogSetupLevel.ERROR_ONLY ));
			
			verifyNothingCalled( logTarget );
			if(     _logger.debugEnabled
				&& !_logger.infoEnabled
				&& !_logger.warnEnabled
				&&  _logger.errorEnabled
				&& !_logger.fatalEnabled ) {
				_logger.debug("debug10", 1, 2, myObject);
				_logger.info("Should not be called");
				_logger.warn("Should not be called");
				_logger.error("error10", 1, 2, myObject);
				_logger.fatal("Should not be called");
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(DEBUG), anyOf(Number), eq( "debug10" ), alike([1, 2, myObject])));
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(ERROR), anyOf(Number), eq( "error10" ), alike([1, 2, myObject])));
			} else {
				fail("The Logsystem tells logging is not enabled @ fatal.");
			}
		}

		[Test]
		public function testEmptyLogger():void {
			assertFalse( Object( _logger ).toString(), _logger.debugEnabled );
			assertFalse( Object( _logger ).toString(),_logger.infoEnabled );
			assertFalse( Object( _logger ).toString(), _logger.warnEnabled );
			assertFalse( Object( _logger ).toString(),_logger.errorEnabled );
			assertFalse( Object( _logger ).toString(),_logger.fatalEnabled );
		}
		
		[After]
		override public function tearDown():void {
			super.tearDown();
			LOGGER_FACTORY.setup = null;
		}
	}
}

import org.as3commons.logging.LogLevel;
import org.as3commons.logging.setup.ILogTarget;

class TestLogTarget implements ILogTarget {

	public function log(name:String, shortName:String, level:LogLevel, timeStamp:Number, message:*, parameters:Array):void {
	}
}