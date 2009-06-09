package org.as3commons.logging.impl {
	
	import org.as3commons.logging.LogLevel;
	import org.as3commons.logging.util.MessageUtil;
	import org.osflash.thunderbolt.Logger;
	
	/**
	 * Logger adapter for the ThunderBolt logger.
	 *
	 * @author Christophe Herreman
	 */
	public class ThunderBoltLogger extends AbstractLogger {
		
		public static var logObjects:Boolean = false;
		
		/**
		 * Creates a new ThunderBoltLogger
		 */
		public function ThunderBoltLogger(name:String = "") {
			super(name);
		}
		
		/**
		 *
		 */
		override protected function log(level:uint, message:String, params:Array):void {
			try {
				message = name + " - " + MessageUtil.toString(message, params);
				
				if (logObjects) {
					Logger.log(getLevel(level), message, params);
				} else {
					Logger.log(getLevel(level), message);
				}
			} catch (e:Error) {
				Logger.error("Cannot log via ThunderBoltLogger: " + e.message);
			}
		}
		
		/**
		 * Gets the ThunderBolt log level from a as3commons log level.
		 *
		 * @param level the as3commons-logging log level
		 * @return the ThunderBolt log level
		 */
		private function getLevel(level:uint):String {
			switch (level) {
				case LogLevel.DEBUG:
					return Logger.LOG;
				case LogLevel.INFO:
					return Logger.INFO;
				case LogLevel.WARN:
					return Logger.WARN;
				case LogLevel.ERROR:
				case LogLevel.FATAL:
					return Logger.ERROR;
				default:
					return Logger.LOG;
			}
		}
	}
}