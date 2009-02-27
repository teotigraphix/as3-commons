package org.as3commons.logging.impl {
	
	import org.as3commons.logging.ILogger;
	
	/**
	 * Null object implementation of the the ILogger interface. This class is used internally by the LoggerFactory
	 * when its logger factory is set to null so that no logging happens.
	 * 
	 * @author Christophe Herreman
	 */
	public class NullLogger implements ILogger {
		
		/**
		 * Creates a new NullLogger.
		 */
		public function NullLogger() {
		}
		
		/**
		 * @inheritDoc
		 */
		public function debug(message:String, ...params):void {
		}
		
		/**
		 * @inheritDoc
		 */
		public function info(message:String, ...params):void {
		}
		
		/**
		 * @inheritDoc
		 */
		public function warn(message:String, ...params):void {
		}
		
		/**
		 * @inheritDoc
		 */
		public function error(message:String, ...params):void {
		}
		
		/**
		 * @inheritDoc
		 */
		public function fatal(message:String, ...params):void {
		}
	}
}