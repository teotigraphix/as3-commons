package org.as3commons.logging { 
	import org.as3commons.logging.level.*;
	import org.as3commons.logging.setup.ILogTarget;
	import org.as3commons.logging.setup.TargetSetup;
	import org.as3commons.logging.util.AClass;
	import org.as3commons.logging.util.alike;
	import org.as3commons.logging.util.rest;
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
			LoggerFactory.setup = null;
			_logger = LoggerFactory.getLogger("");
		}
		
		public function testAccess(): void {
			assertStrictlyEquals(LoggerFactory.getLogger(""), LoggerFactory.getLogger(""));
			assertStrictlyEquals(LoggerFactory.getLogger("test.more"), LoggerFactory.getLogger("test.more"));
			assertStrictlyEquals(LoggerFactory.getLogger(null), LoggerFactory.getLogger(null));
			assertStrictlyEquals(LoggerFactory.getLogger(null), LoggerFactory.getLogger("null") );
			assertStrictlyEquals(LoggerFactory.getLogger(undefined), LoggerFactory.getLogger(undefined));
			assertStrictlyEquals(LoggerFactory.getLogger(undefined), LoggerFactory.getLogger("void"));
			
			var aLogger: ILogger = LoggerFactory.getLogger( AClass );
			var bLogger: ILogger = LoggerFactory.getLogger( new AClass );
			var cLogger: ILogger = LoggerFactory.getLogger( getQualifiedClassName( AClass ).replace( "::", "." ) );
			var dLogger: ILogger = LoggerFactory.getLogger( getQualifiedClassName( new AClass ).replace( "::", "." ) );
			var gLogger: ILogger = LoggerFactory.getNamedLogger( getQualifiedClassName( AClass ).replace( "::", "." ) );
			var hLogger: ILogger = LoggerFactory.getNamedLogger( getQualifiedClassName( new AClass ).replace( "::", "." ) );
			
			assertFalse( _logger == aLogger );
			
			assertStrictlyEquals( aLogger, bLogger );
			assertStrictlyEquals( bLogger, cLogger );
			assertStrictlyEquals( dLogger, gLogger );
			assertStrictlyEquals( gLogger, hLogger );
		}
		
		public function testFactoryIntegration():void {
			var setup: ILogSetup = mock(ILogSetup);
			var testTarget: ILogTarget = new TestLogTarget();
			given( setup.getTarget( any() ) ).willReturn( testTarget );
			given( setup.getLevel( any() ) ).willReturn( null );
			
			LoggerFactory.setup = setup;
			
			rest( setup ).choose( setup.getLevel( any() ), setup.getTarget( any() ) );
		}
		
		public function testEmptyCase(): void {
			var setup: ILogSetup = new TargetSetup( null, LogSetupLevel.ALL );
			LoggerFactory.setup = setup;
			
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
			
			var setup: TargetSetup = new TargetSetup(logTarget, LogSetupLevel.DEBUG);
			LoggerFactory.setup = setup;
			verifyNothingCalled( logTarget );
			if(    _logger.debugEnabled
				&& _logger.infoEnabled
				&& _logger.warnEnabled
				&& _logger.errorEnabled
				&& _logger.fatalEnabled ) {
				_logger.debug("debug1", 1, 2, myObject);
				_logger.info("info1", 1, 2, myObject);
				_logger.warn("warn1", 1, 2, myObject);
				_logger.error("error1", 1, 2, myObject);
				_logger.fatal("fatal1", 1, 2, myObject);
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(DEBUG), anyOf(Number), eq("debug1"), alike([1, 2, myObject]) ));
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(INFO), anyOf(Number), eq( "info1" ), alike([1, 2, myObject])));
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(WARN), anyOf(Number), eq( "warn1" ), alike([1, 2, myObject])));
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(ERROR), anyOf(Number), eq( "error1" ), alike([1, 2, myObject])));
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(FATAL), anyOf(Number), eq( "fatal1" ), alike([1, 2, myObject])));
			} else {
				fail("The Logsystem tells logging is not properly enabled @ debug");
			}
			
			LoggerFactory.setup = new TargetSetup(logTarget,LogSetupLevel.DEBUG_ONLY);
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
			
			LoggerFactory.setup = new TargetSetup( logTarget,LogSetupLevel.INFO);
			
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
			
			LoggerFactory.setup = new TargetSetup( logTarget,LogSetupLevel.INFO_ONLY);
			
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
			
			LoggerFactory.setup = new TargetSetup( logTarget,LogSetupLevel.WARN);
			
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
			
			
			LoggerFactory.setup = new TargetSetup( logTarget,LogSetupLevel.WARN_ONLY);
			
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
			
			LoggerFactory.setup = new TargetSetup( logTarget,LogSetupLevel.ERROR);
			
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
			
			LoggerFactory.setup = new TargetSetup( logTarget,LogSetupLevel.ERROR_ONLY);
			
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
			
			LoggerFactory.setup = new TargetSetup( logTarget,LogSetupLevel.FATAL);
			
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
			
			LoggerFactory.setup = new TargetSetup( logTarget,LogSetupLevel.NONE);
			
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
			
			
			LoggerFactory.setup = new TargetSetup( logTarget,LogSetupLevel.DEBUG_ONLY.or( LogSetupLevel.ERROR_ONLY ));
			
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
			LoggerFactory.setup = null;
		}
	}
}

import org.as3commons.logging.LogLevel;
import org.as3commons.logging.setup.ILogTarget;

class TestLogTarget implements ILogTarget {

	public function log(name:String, shortName:String, level:LogLevel, timeStamp:Number, message:*, parameters:Array):void {
	}
}