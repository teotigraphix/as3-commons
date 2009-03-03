package org.as3commons.logging.impl {
	
	import mx.logging.ILogger;
	
	import org.as3commons.logging.ILogger;
	
	/**
	 * Logger decorator for the logging API in the Flex framework.
	 * 
	 * @author Christophe Herreman
	 */
	public class FlexLogger implements ILogger {
		
		/** The decorated flex framework logger */
		private var _logger:mx.logging.ILogger;
		
		/**
		 * Creates a new FlexLogger
		 */
		public function FlexLogger(logger:mx.logging.ILogger) {
			_logger = logger;
		}
		
		/**
		 * @inheritDoc
		 */
		public function debug(message:String, ...params):void {
			var args:Array = params.concat();
			args.unshift(message);
			_logger.debug.apply(_logger, args);
		}
		
		/**
		 * @inheritDoc
		 */
		public function info(message:String, ...params):void {
			var args:Array = params.concat();
			args.unshift(message);
			_logger.info.apply(_logger, args);
		}
		
		/**
		 * @inheritDoc
		 */
		public function warn(message:String, ...params):void {
			var args:Array = params.concat();
			args.unshift(message);
			_logger.warn.apply(_logger, args);
		}
		
		/**
		 * @inheritDoc
		 */
		public function error(message:String, ...params):void {
			var args:Array = params.concat();
			args.unshift(message);
			_logger.error.apply(_logger, args);
		}
		
		/**
		 * @inheritDoc
		 */
		public function fatal(message:String, ...params):void {
			var args:Array = params.concat();
			args.unshift(message);
			_logger.fatal.apply(_logger, args);
		}
	}
}