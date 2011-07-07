package {
	import mx.logging.ILogger;
	import mx.logging.Log;

	import flash.display.Sprite;
	import flash.utils.getQualifiedClassName;
	/**
	 * @author mh
	 */
	public class SizeFlexMin extends Sprite {
		
		public static const logger : ILogger = Log.getLogger(getQualifiedClassName(SizeFlexMin));
		
		public function SizeFlexMin() {
			logger.debug( "Hello World" );
		}
	}
}
