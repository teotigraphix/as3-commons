package {
	import org.as3commons.logging.setup.target.FirebugTarget;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.LOGGER_FACTORY;
	import org.as3commons.logging.util.captureUncaughtErrors;
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.getLogger;

	import flash.display.Sprite;
	
	public class FirebugTest extends Sprite {
		
		private const logger: ILogger = getLogger( FirebugTest );
		
		public function FirebugTest() {
			
			LOGGER_FACTORY.setup = new SimpleTargetSetup( new FirebugTarget() );
			
			captureUncaughtErrors( loaderInfo );
			
			logger.info(1);
			logger.warn(true);
			logger.error({
				my: {
					house: { isin: { the: { middle: "of the street" } } },
					where: { isyour: "house?" }
				}
			});
			logger.debug("My Text {0}ly is a {1}{2} and {1}{3}", true, {nice:"andwarm"}, "house", 1.0 );
			
			throw new Error("And here some uncaught exception\n");
		}

	}
}
