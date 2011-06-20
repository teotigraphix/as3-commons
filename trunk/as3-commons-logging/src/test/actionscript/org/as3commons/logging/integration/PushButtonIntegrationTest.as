package org.as3commons.logging.integration {
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.debug.LogEntry;
	import com.pblabs.engine.debug.Logger;

	import org.as3commons.logging.LOGGER_FACTORY;
	import org.as3commons.logging.level.DEBUG;
	import org.as3commons.logging.level.ERROR;
	import org.as3commons.logging.level.INFO;
	import org.as3commons.logging.level.WARN;
	import org.as3commons.logging.setup.ILogTarget;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.util.alike;
	import org.mockito.MockitoTestCase;
	/**
	 * @author mh
	 */
	public class PushButtonIntegrationTest extends MockitoTestCase {
		
		public function PushButtonIntegrationTest() {
			super([ILogTarget]);
		}
		
		override public function setUp(): void {
			PBE.IS_SHIPPING_BUILD = true;
			Logger.startup();
		}
		
		public function testIntegration(): void {
			var target: ILogTarget = mock( ILogTarget );
			
			LOGGER_FACTORY.setup = new SimpleTargetSetup( target );
			
			Logger.registerListener( new PushButtonIntegration() );
			
			Logger.print( Logger, "Print" );
			Logger.printFooter( Logger, "Hello Footer" );
			Logger.printHeader( Logger, "Hello Header" );
			Logger.printCustom( Logger, "method", "Hello Custom", LogEntry.ERROR );
			Logger.debug( Logger, "method", "A Debug" );
			Logger.info(  Logger, "method", "A Info" );
			Logger.warn(  Logger, "method", "A Warn" );
			Logger.error( Logger, "method", "A Error" );
			
			inOrder().verify().that( target.log( eq("com.pblabs.engine.debug.Logger"), eq("Logger"), eq(DEBUG), notNull(), eq( "Print" ), alike([]), eq("pushbutton") ) );
			inOrder().verify().that( target.log( eq("com.pblabs.engine.debug.Logger"), eq("Logger"), eq(DEBUG), notNull(), eq( "Hello Footer" ), alike([]), eq("pushbutton") ) );
			inOrder().verify().that( target.log( eq("com.pblabs.engine.debug.Logger"), eq("Logger"), eq(DEBUG), notNull(), eq( "Hello Header" ), alike([]), eq("pushbutton") ) );
			inOrder().verify().that( target.log( eq("com.pblabs.engine.debug.Logger"), eq("Logger"), eq(ERROR), notNull(), eq( "method - Hello Custom" ), alike([]), eq("pushbutton") ) );
			inOrder().verify().that( target.log( eq("com.pblabs.engine.debug.Logger"), eq("Logger"), eq(DEBUG), notNull(), eq( "method - A Debug" ), alike([]), eq("pushbutton") ) );
			inOrder().verify().that( target.log( eq("com.pblabs.engine.debug.Logger"), eq("Logger"), eq(INFO), notNull(), eq( "method - A Info" ), alike([]), eq("pushbutton") ) );
			inOrder().verify().that( target.log( eq("com.pblabs.engine.debug.Logger"), eq("Logger"), eq(WARN), notNull(), eq( "method - A Warn" ), alike([]), eq("pushbutton") ) );
			inOrder().verify().that( target.log( eq("com.pblabs.engine.debug.Logger"), eq("Logger"), eq(ERROR), notNull(), eq( "method - A Error" ), alike([]), eq("pushbutton") ) );
		}
	}
}