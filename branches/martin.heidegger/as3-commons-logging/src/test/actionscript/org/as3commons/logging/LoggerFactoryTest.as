package org.as3commons.logging {
	import org.as3commons.logging.util.AClass;
	import org.as3commons.logging.util.alike;
	import org.as3commons.logging.util.rest;
	import org.mockito.MockitoTestCase;

	import flash.utils.getQualifiedClassName;

	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public class LoggerFactoryTest extends MockitoTestCase {
		
		private var _logger:ILogger;
		
		public function LoggerFactoryTest() {
			super([ILogTarget,ILogTargetFactory]);
		}
		
		[Before]
		override public function setUp():void {
			super.setUp();
			LoggerFactory.targetFactory = null;
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
			var eLogger: ILogger = LoggerFactory.getClassLogger( AClass );
			var fLogger: ILogger = LoggerFactory.getInstanceLogger( new AClass );
			var gLogger: ILogger = LoggerFactory.getNamedLogger( getQualifiedClassName( AClass ).replace( "::", "." ) );
			var hLogger: ILogger = LoggerFactory.getNamedLogger( getQualifiedClassName( new AClass ).replace( "::", "." ) );
			
			assertFalse( _logger == aLogger );
			
			assertStrictlyEquals( aLogger, bLogger );
			assertStrictlyEquals( bLogger, cLogger );
			assertStrictlyEquals( dLogger, eLogger );
			assertStrictlyEquals( eLogger, fLogger );
			assertStrictlyEquals( fLogger, gLogger );
			assertStrictlyEquals( gLogger, hLogger );
		}
		
		public function testSetup(): void {
			assertEquals( LoggerFactory.SWF_URL, LoggerFactory.SWF_URL_ERROR );
			assertEquals( LoggerFactory.SWF_SHORT_URL, LoggerFactory.SWF_URL_ERROR );
			
			LoggerFactory.initSWFURLs( LogTests.STAGE );
			
			var url: String = LogTests.STAGE.loaderInfo.url;
			assertEquals( url, LoggerFactory.SWF_URL );
			assertEquals( url.substring( url.lastIndexOf("/") + 1 ), LoggerFactory.SWF_SHORT_URL );
			
			LoggerFactory.initSWFURLs( null );
			
			assertEquals( LoggerFactory.SWF_URL, LoggerFactory.SWF_URL_ERROR );
			assertEquals( LoggerFactory.SWF_SHORT_URL, LoggerFactory.SWF_URL_ERROR );
		}
		
		public function testFactoryIntegration():void {
			var factory: ILogTargetFactory = ILogTargetFactory(mock(ILogTargetFactory));
			var testTarget: ILogTarget = new TestLogTarget();
			given( factory.getLogTarget( any() ) ).willReturn( testTarget );
			
			LoggerFactory.targetFactory = factory;
			
		}
		
		public function testTargetIntegration():void {
			var logTarget:ILogTarget = ILogTarget(mock(ILogTarget));
			var myObject:Object = {};
			
			var factory: TestLoggerFactory = new TestLoggerFactory(logTarget);
			given( logTarget.logTargetLevel ).willReturn(LogTargetLevel.DEBUG);
			LoggerFactory.targetFactory = factory;
			verify( rest() ).that(logTarget.logTargetLevel );
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
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(LogLevel.DEBUG), anyOf(Number), eq("debug1"), alike([1, 2, myObject]) ));
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(LogLevel.INFO), anyOf(Number), eq( "info1" ), alike([1, 2, myObject])));
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(LogLevel.WARN), anyOf(Number), eq( "warn1" ), alike([1, 2, myObject])));
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(LogLevel.ERROR), anyOf(Number), eq( "error1" ), alike([1, 2, myObject])));
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(LogLevel.FATAL), anyOf(Number), eq( "fatal1" ), alike([1, 2, myObject])));
			} else {
				fail("The Logsystem tells logging is not properly enabled @ debug");
			}
			
			given( logTarget.logTargetLevel ).willReturn(LogTargetLevel.DEBUG_ONLY);
			LoggerFactory.targetFactory = factory;
			verify( rest() ).that(logTarget.logTargetLevel );
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
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(LogLevel.DEBUG), anyOf(Number), eq("debug2"), alike([1, 2, myObject]) ));
			} else {
				fail("The Logsystem tells logging is not properly enabled @ debug-only");
			}
			
			given( logTarget.logTargetLevel ).willReturn(LogTargetLevel.INFO);
			LoggerFactory.targetFactory = factory;
			verify( rest() ).that(logTarget.logTargetLevel );
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
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(LogLevel.INFO), anyOf(Number), eq( "info3" ), alike([1, 2, myObject])));
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(LogLevel.WARN), anyOf(Number), eq( "warn3" ), alike([1, 2, myObject])));
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(LogLevel.ERROR), anyOf(Number), eq( "error3" ), alike([1, 2, myObject])));
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(LogLevel.FATAL), anyOf(Number), eq( "fatal3" ), alike([1, 2, myObject])));
			} else {
				fail("The Logsystem tells logging is not enabled @ info.");
			}
			
			given( logTarget.logTargetLevel ).willReturn(LogTargetLevel.INFO_ONLY);
			LoggerFactory.targetFactory = factory;
			verify( rest() ).that(logTarget.logTargetLevel );
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
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(LogLevel.INFO), anyOf(Number), eq("info4"), alike([1, 2, myObject]) ));
			} else {
				fail("The Logsystem tells logging is not properly enabled @ info-only");
			}
			
			given( logTarget.logTargetLevel ).willReturn(LogTargetLevel.WARN);
			LoggerFactory.targetFactory = factory;
			verify( rest() ).that(logTarget.logTargetLevel );
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
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(LogLevel.WARN), anyOf(Number), eq( "warn5" ), alike([1, 2, myObject])));
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(LogLevel.ERROR), anyOf(Number), eq( "error5" ), alike([1, 2, myObject])));
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(LogLevel.FATAL), anyOf(Number), eq( "fatal5" ), alike([1, 2, myObject])));
			} else {
				fail("The Logsystem tells logging is not enabled @ warn.");
			}
			
			given( logTarget.logTargetLevel ).willReturn(LogTargetLevel.WARN_ONLY);
			LoggerFactory.targetFactory = factory;
			verify( rest() ).that(logTarget.logTargetLevel );
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
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(LogLevel.WARN), anyOf(Number), eq("warn6"), alike([1, 2, myObject]) ));
			} else {
				fail("The Logsystem tells logging is not properly enabled @ warn-only");
			}
			
			given( logTarget.logTargetLevel ).willReturn(LogTargetLevel.ERROR);
			LoggerFactory.targetFactory = factory;
			verify( rest() ).that(logTarget.logTargetLevel );
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
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(LogLevel.ERROR), anyOf(Number), eq( "error7" ), alike([1, 2, myObject])));
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(LogLevel.FATAL), anyOf(Number), eq( "fatal7" ), alike([1, 2, myObject])));
			} else {
				fail("The Logsystem tells logging is not enabled @ error.");
			}
			
			given( logTarget.logTargetLevel ).willReturn(LogTargetLevel.ERROR_ONLY);
			LoggerFactory.targetFactory = factory;
			verify( rest() ).that(logTarget.logTargetLevel );
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
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(LogLevel.ERROR), anyOf(Number), eq("error8"), alike([1, 2, myObject]) ));
			} else {
				fail("The Logsystem tells logging is not properly enabled @ error-only");
			}
			
			given( logTarget.logTargetLevel ).willReturn(LogTargetLevel.FATAL);
			LoggerFactory.targetFactory = factory;
			verify( rest() ).that(logTarget.logTargetLevel );
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
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(LogLevel.FATAL), anyOf(Number), eq( "fatal9" ), alike([1, 2, myObject])));
			} else {
				fail("The Logsystem tells logging is not enabled @ fatal.");
			}
			
			given( logTarget.logTargetLevel ).willReturn(LogTargetLevel.NONE);
			LoggerFactory.targetFactory = factory;
			verify( rest() ).that(logTarget.logTargetLevel );
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
				logTarget.log("", "", LogLevel.DEBUG, 123.0, "test", null);
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(LogLevel.DEBUG), anyOf(Number), eq( "test" ), eq(null)));
			} else {
				fail("The Logsystem tells logging is not enabled @ fatal.");
			}
			
			given( logTarget.logTargetLevel ).willReturn(LogTargetLevel.DEBUG_ONLY.or( LogTargetLevel.ERROR_ONLY ));
			LoggerFactory.targetFactory = factory;
			verify( rest() ).that(logTarget.logTargetLevel );
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
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(LogLevel.DEBUG), anyOf(Number), eq( "debug10" ), alike([1, 2, myObject])));
				inOrder().verify().that(logTarget.log(eq(""), eq(""), eq(LogLevel.ERROR), anyOf(Number), eq( "error10" ), alike([1, 2, myObject])));
			} else {
				fail("The Logsystem tells logging is not enabled @ fatal.");
			}
		}
		
		[Test]
		public function testEmptyLogger():void {
			assertFalse( _logger.toString(), _logger.debugEnabled );
			assertFalse( _logger.toString(),_logger.infoEnabled );
			assertFalse( _logger.toString(), _logger.warnEnabled );
			assertFalse( _logger.toString(),_logger.errorEnabled );
			assertFalse( _logger.toString(),_logger.fatalEnabled );
		}
		
		[After]
		override public function tearDown():void {
			super.tearDown();
			LoggerFactory.targetFactory = null;
		}
	}
}

import org.as3commons.logging.ILogTarget;
import org.as3commons.logging.ILogTargetFactory;
import org.as3commons.logging.LogLevel;
import org.as3commons.logging.LogTargetLevel;

class TestLoggerFactory implements ILogTargetFactory {
	private var _logger:ILogTarget;

	public function TestLoggerFactory(logger:ILogTarget) {
		_logger = logger;
	}

	public function getLogTarget(name:String):ILogTarget {
		return _logger;
	}
}

class TestLogTarget implements ILogTarget {

	public function log(name:String, shortName:String, level:LogLevel, timeStamp:Number, message:String, parameters:Array):void {
	}
	
	public function get logTargetLevel():LogTargetLevel {
		return null;
	}
}