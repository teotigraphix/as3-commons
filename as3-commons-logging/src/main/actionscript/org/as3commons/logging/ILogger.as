package org.as3commons.logging {
	
	/**
	 * The main logging interface to abstract logger implementations.
	 * 
	 * @author Christophe Herreman
	 */
	public interface ILogger {
		
		/**
		 * Returns the name of this logger.
		 */
		function get name():String;
		
		function debug(message:String, ... params):void;
		
		function info(message:String, ... params):void;
		
		function warn(message:String, ... params):void;
		
		function error(message:String, ... params):void;
		
		function fatal(message:String, ... params):void;
		
	}
}