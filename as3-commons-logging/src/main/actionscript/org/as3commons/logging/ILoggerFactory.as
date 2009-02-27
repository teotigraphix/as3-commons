package org.as3commons.logging {
	
	/**
	 * Interface to be implemented by all logger factories.
	 * 
	 * @author Christophe Herreman
	 */
	public interface ILoggerFactory {
		
		/**
		 * Returns the logger created by this factory.
		 * 
		 * @param name the name of the logger
		 * @return the logger
		 */
		function getLogger(name:String):ILogger;
		
	}
}