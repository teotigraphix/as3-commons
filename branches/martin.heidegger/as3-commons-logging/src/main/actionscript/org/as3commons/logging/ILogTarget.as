package org.as3commons.logging {

	/**
	 * @author Martin
	 */
	public interface ILogTarget {
		function log( name: String, level: LogLevel, timeMs: Number, message: String, parameters: Array ): void;
		function get logLevel(): LogLevel;
	}
}
