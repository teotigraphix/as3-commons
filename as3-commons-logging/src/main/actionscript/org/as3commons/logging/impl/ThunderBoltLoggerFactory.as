package org.as3commons.logging.impl {
	
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.ILoggerFactory;
	import org.osflash.thunderbolt.Logger;
	
	/**
	 * Logger factory for the ThunderBolt logger.
	 *
	 * @author Christophe Herreman
	 */
	public class ThunderBoltLoggerFactory implements ILoggerFactory {
		
		/**
		 * Creates a new ThunderBoltLoggerFactory
		 */
		public function ThunderBoltLoggerFactory() {
			Logger.includeTime = true;
			Logger.showCaller = false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getLogger(name:String):ILogger {
			return new ThunderBoltLogger(name);
		}
	}
}