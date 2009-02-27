package org.as3commons.logging.impl {
	
	import flash.events.EventDispatcher;
	
	import org.as3commons.logging.ILogger;
	
	/**
	 * Default AS3Commons logging implementation of the ILogger interface that writes messages to the console using
	 * the trace() method. If no ILoggerFactory is set on the LoggerFactory, then this is the logger that will be used.
	 * 
	 * @author Christophe Herreman
	 */
	public class DefaultLogger implements ILogger {
		
		public static const LOG_LEVEL_DEBUG:int	= 1;
		public static const LOG_LEVEL_INFO:int	= 2;
		public static const LOG_LEVEL_WARN:int	= 3;
		public static const LOG_LEVEL_ERROR:int	= 4;
		public static const LOG_LEVEL_FATAL:int	= 5;
		
		public static const LOG_LEVEL_ALL:int	= (LOG_LEVEL_DEBUG - 1);
		
		public static const LOG_LEVEL_OFF:int	= (LOG_LEVEL_FATAL + 1);
		
		private var _name:String;
		private var _level:int;
		
		/**
		 * Creates a new DefaultLogger.
		 */
		public function DefaultLogger(name:String) {
			_name = name;
		}
		
		public function set level(value:int):void {
			_level = value;
		}
		
		public function log(level:int, message:String, ... params):void {
			if (level >= this._level) {
				//var message:String = "";
				
				var msg:String = "";
				
				// add datetime
				msg += (new Date()).toString() + " ";
				
				// add level
				switch (level) {
					case LOG_LEVEL_DEBUG:
						msg += "[DEBUG] ";
						break;
					case LOG_LEVEL_INFO:
						msg += "[INFO]  ";
						break;
					case LOG_LEVEL_WARN:
						msg += "[WARN]  ";
						break;
					case LOG_LEVEL_ERROR:
						msg += "[ERROR] ";
						break;
					case LOG_LEVEL_FATAL:
						msg += "[FATAL] ";
						break;
				}
				
				// add name
				msg += _name + " - ";
				
				// replace placeholders in message
				var numParams:int = params.length;
				for (var i:int = 0; i < numParams; i++) {
					message = message.replace(new RegExp("\\{" + i + "\\}", "g"), params[i]);
				}
				msg += message;
				
				// trace the message
				trace(msg);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function debug(message:String, ...params):void {
			log(LOG_LEVEL_DEBUG, message, params);
		}
		
		/**
		 * @inheritDoc
		 */
		public function info(message:String, ...params):void {
			log(LOG_LEVEL_INFO, message, params);
		}
		
		/**
		 * @inheritDoc
		 */
		public function warn(message:String, ...params):void {
			log(LOG_LEVEL_WARN, message, params);
		}
		
		/**
		 * @inheritDoc
		 */
		public function error(message:String, ...params):void {
			log(LOG_LEVEL_ERROR, message, params);
		}
		
		/**
		 * @inheritDoc
		 */
		public function fatal(message:String, ...params):void {
			log(LOG_LEVEL_FATAL, message, params);
		}
	}
}