package {
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.setup.target.TraceTarget;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.LOGGER_FACTORY;
	import org.as3commons.logging.api.getLogger;
	import org.as3commons.logging.setup.HierarchicalSetup;
	import org.as3commons.logging.setup.log4j.log4jPropertiesToSetup;
	import org.as3commons.logging.setup.target.AirFileTarget;

	import flash.display.Sprite;
	
	/**
	 * <code>Log4JTest</code>
	 *
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @since
	 */
	public class Log4JTest extends Sprite {
		public function Log4JTest() {
			
			var logger: ILogger = getLogger("hello World");
			
			AirFileTarget;
			
			LOGGER_FACTORY.setup = new SimpleTargetSetup(new TraceTarget() );
			
			LOGGER_FACTORY.setup = log4jPropertiesToSetup(
				"log4j.rootLogger = DEBUG, FILE;\n" +
				"log4j.appender.FILE = org.as3commons.logging.setup.target::AirFileTarget"
			);
		
			//LOGGER_FACTORY.setup = log4jPropertiesToSetup( event.result );
		
			logger.debug( "test" );
			logger.warn( "test" );
			logger.error( "test" );
		
		    /*var fileTarget:AirFileTarget = new AirFileTarget();
		     var regExp:RegExp = new RegExp( "^org\\.|^com\\.traficon|^TMSNG\\." );
		     LOGGER_FACTORY.setup = new RegExpSetup().addTargetRule( regExp, fileTarget );
		
			var fileTarget:AirFileTarget = new AirFileTarget();
			var setup:HierarchicalSetup = new HierarchicalSetup();
			setup.setHierarchy("", fileTarget);
			LOGGER_FACTORY.setup = setup;
			
			logger.debug( "test 2" );
			logger.warn( "test 2" );
			logger.error( "test 2" );*/
		}

	}
}
