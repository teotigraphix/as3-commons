package {
	import flash.display.Sprite;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.LOGGER_FACTORY;
	import org.as3commons.logging.api.getLogger;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.setup.target.TraceTarget;
	import org.as3commons.logging.util.logRuntimeInfo;

	/**
	 * @author mh
	 */
	public class SizeAS3Min extends Sprite {
		
		public static const logger: ILogger = getLogger(SizeAS3Min);
		
		public function SizeAS3Min() {
			LOGGER_FACTORY.setup = new SimpleTargetSetup( new TraceTarget() );
			logger.debug("Hello World");
			logRuntimeInfo(stage);
		}
	}
}