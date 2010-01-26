package org.as3commons.logging {
	import org.as3commons.logging.impl.AirFileLogger;
	import flash.display.Sprite;

	/**
	 * @author mh
	 */
	public class AirTest extends Sprite {
		private static const logger: ILogger = LoggerFactory.getClassLogger( AirTest );
		public function AirTest() {
			LoggerFactory.loggerFactory = new AirFileLogger();
			logger.info( "hi!" );
		}
	}
}
