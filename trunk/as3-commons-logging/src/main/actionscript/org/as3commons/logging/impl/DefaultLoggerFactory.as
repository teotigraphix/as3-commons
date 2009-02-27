package org.as3commons.logging.impl {
	
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.ILoggerFactory;
	
	/**
	 * Default AS3Commons logger factory. If no logger factory is set on LoggerFactory, then this is the factory
	 * that will be used.
	 * 
	 * @author Christophe Herreman
	 */
	public class DefaultLoggerFactory implements ILoggerFactory {
		
		/**
		 * Creates a new DefaultLoggerFactory
		 */
		public function DefaultLoggerFactory() {
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function getLogger(name:String):ILogger {
			return new DefaultLogger(name);
		}
	}
}