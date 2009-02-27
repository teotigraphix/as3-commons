package org.as3commons.logging.impl {
	
	import mx.logging.Log;
	
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.ILoggerFactory;
	
	/**
	 * Logger factory that creates a logger from the Flex mx.logging.* package.
	 * 
	 * @author Christophe Herreman
	 */
	public class FlexLoggerFactory implements ILoggerFactory {
		
		/**
		 * Creates a new FlexLoggerFactory.
		 */
		public function FlexLoggerFactory() {
		}
		
		/**
		 * @inheritDoc
		 */
		public function getLogger(name:String):ILogger {
			return new FlexLogger(Log.getLogger(name));
		}
	}
}