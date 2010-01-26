package org.as3commons.logging.impl {
	import org.as3commons.logging.ILogTarget;
	import org.as3commons.logging.LogLevel;

	import flash.errors.IllegalOperationError;

	/**
	 * Abstract base class for ILogger implementations.
	 *
	 * @author Christophe Herreman
	 */
	public class AbstractLogTarget implements ILogTarget {
		
		private var _logLevel: LogLevel = LogLevel.ALL;

		/**
		 * Subclasses must override this method and provide a concrete log implementation.
		 */
		public function log(name: String, level:LogLevel, timeMs: Number, message:String, params:Array):void {
			throw new IllegalOperationError("The 'log' method is abstract and must be overridden in '" + this + "'" );
		}
		
		public function set logLevel( logLevel: LogLevel ): void {
			_logLevel = logLevel;
		}

		public function get logLevel(): LogLevel
		{
			return _logLevel;
		}
	}
}