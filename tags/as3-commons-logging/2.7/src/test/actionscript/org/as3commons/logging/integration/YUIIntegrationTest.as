package org.as3commons.logging.integration {
	import org.as3commons.logging.util.alike;
	import org.seasar.akabana.yui.core.ClassLoader;
	import org.mockito.MockitoTestCase;

	import org.as3commons.logging.api.LOGGER_FACTORY;
	import org.as3commons.logging.level.DEBUG;
	import org.as3commons.logging.level.ERROR;
	import org.as3commons.logging.level.FATAL;
	import org.as3commons.logging.level.INFO;
	import org.as3commons.logging.level.WARN;
	import org.as3commons.logging.setup.ILogTarget;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.util.verifyNothingCalled;
	import org.seasar.akabana.yui.core.logging.ILogger;
	import org.seasar.akabana.yui.framework.logging.Logging;

	import flash.net.registerClassAlias;

	/**
	 * @author mh
	 */
	public class YUIIntegrationTest extends MockitoTestCase {
		public function YUIIntegrationTest() {
			super( [ILogTarget] );
		}
		
		public function testNormal():void {
			
			var target: ILogTarget = mock( ILogTarget );
			
			LOGGER_FACTORY.setup = new SimpleTargetSetup(target);
			
			registerClassAlias( "org.seasar.akabana.yui.logging.LoggerFactory", YUILoggerFactory );
			
			var loader: ClassLoader = new ClassLoader();
			trace( loader.findClass("org.seasar.akabana.yui.logging.LoggerFactory") );
			Logging.initialize();
			
			var logger: ILogger = Logging.getLogger( "test" );
			logger.debug( "Hello World" );
			logger.debug( "Hello {0}", "Mario" );
			logger.info( "Hola!" );
			logger.info( "Amigo {0} {1}", "Santa", "Maria" );
			logger.warn( "Como!" );
			logger.error( "Estaz!" );
			logger.fatal( "Santa domingo!" );
			
			inOrder().verify().that( target.log( eq("test"), eq("test"), eq(DEBUG), notNull(), eq( "Hello World" ), eq(null), eq("yui") ) );
			inOrder().verify().that( target.log( eq("test"), eq("test"), eq(DEBUG), notNull(), eq( "Hello {0}" ), alike(["Mario"]), eq("yui") ) );
			inOrder().verify().that( target.log( eq("test"), eq("test"), eq(INFO), notNull(), eq( "Hola!" ), eq(null), eq("yui") ) );
			inOrder().verify().that( target.log( eq("test"), eq("test"), eq(INFO), notNull(), eq( "Amigo {0} {1}" ), alike(["Santa", "Maria"]), eq("yui") ) );
			inOrder().verify().that( target.log( eq("test"), eq("test"), eq(WARN), notNull(), eq( "Como!" ), eq(null), eq("yui") ) );
			inOrder().verify().that( target.log( eq("test"), eq("test"), eq(ERROR), notNull(), eq( "Estaz!" ), eq(null), eq("yui") ) );
			inOrder().verify().that( target.log( eq("test"), eq("test"), eq(FATAL), notNull(), eq( "Santa domingo!" ), eq(null), eq("yui") ) );
			
			verifyNothingCalled( target );
		}
	}
}
