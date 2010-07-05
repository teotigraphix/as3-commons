package org.as3commons.logging.setup {

	import org.as3commons.logging.LogLevel;
	/**
	 * @author Martin
	 */
	public interface ILogTarget {
		function log( name: String, shortName: String, level: LogLevel, timeStamp: Number, message: String, parameters: Array ): void;
	}
}
