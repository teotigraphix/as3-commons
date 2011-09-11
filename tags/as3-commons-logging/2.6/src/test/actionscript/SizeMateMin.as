package {
	import mx.logging.ILogger;
	import mx.logging.Log;

	import flash.display.Sprite;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author mh
	 */
	public class SizeMateMin extends Sprite {
		
		public static const logger: ILogger = Log.getLogger(getQualifiedClassName(SizeMateMin));
		
		public function SizeMateMin() {
			logger.debug("Hello World");
		}
	}
}
