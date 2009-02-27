package org.as3commons.logging {
	
	import flash.utils.getQualifiedClassName;
	
	import org.as3commons.logging.impl.DefaultLoggerFactory;
	import org.as3commons.logging.impl.NullLogger;
	
	/**
	 * Use the LoggerFactory to obtain a logger.
	 * 
	 * @author Christophe Herreman
	 */
	public class LoggerFactory implements ILoggerFactory {
		
		private static var _instance:LoggerFactory;
		
		private var _loggerFactory:ILoggerFactory = new DefaultLoggerFactory();
		private var _loggers:Array /* of ILogger */ = [];
		
		/**
		 * Constructs a new LoggerFactory.
		 */
		public function LoggerFactory() {
		}
		
		/**
		 * Returns a logger for the given name.
		 */
		public static function getLogger(name:String):ILogger {
			return getInstance().getLogger(name);
		}
		
		/**
		 * Sets the logger factory for the logging system.
		 */
		public static function set loggerFactory(value:ILoggerFactory):void {
			getInstance()._loggerFactory = value;
		}
		
		/**
		 * 
		 */
		private static function getInstance():LoggerFactory {
			if (!_instance) {
				_instance = new LoggerFactory();
			}
			return _instance;
		}
		
		/**
		 * 
		 */
		public function getLogger(name:String):ILogger {
			var result:ILogger = _loggers[name];
			
			if (!result) {
				if (_loggerFactory) {
					result = _loggerFactory.getLogger(name);
				} else {
					result = new NullLogger();
				}
				
				// cache the logger
				_loggers[name] = result;
			}
			
			return result;
		}
	}
}