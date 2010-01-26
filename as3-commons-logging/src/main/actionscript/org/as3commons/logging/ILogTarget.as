package org.as3commons.logging {

	/**
	 * @author Martin
	 */
	public interface ILogTarget {
		function debug( name: String, message: String, parameters: Array ): void;
		function info( name: String, message: String, parameters: Array ): void;
		function warn( name: String, message: String, parameters: Array ): void;
		function error( name: String, message: String, parameters: Array ): void;
		function fatal( name: String, message: String, parameters: Array ): void;
		function get debugEnabled(): Boolean;
		function get infoEnabled(): Boolean;
		function get warnEnabled(): Boolean;
		function get errorEnabled(): Boolean;
		function get fatalEnabled(): Boolean;
	}
}
