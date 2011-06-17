package {
	import com.demonsters.debugger.MonsterDebugger;
	import flash.display.Sprite;
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LOGGER_FACTORY;
	import org.as3commons.logging.getLogger;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.setup.target.FirebugTarget;
	import org.as3commons.logging.setup.target.MonsterDebugger3TraceTarget;
	import org.as3commons.logging.setup.target.mergeTargets;
	import org.as3commons.logging.util.captureUncaughtErrors;

	
	public class FirebugTest extends Sprite {
		
		private const logger: ILogger = getLogger( FirebugTest );
		
		public function FirebugTest() {
			
			MonsterDebugger.initialize( this );
			
			LOGGER_FACTORY.setup = new SimpleTargetSetup( mergeTargets( new FirebugTarget(), new MonsterDebugger3TraceTarget() ) );
			
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
