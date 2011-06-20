package org.as3commons.logging.simple {
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.getLogger;
	/**
	 * @author mh
	 */
	public class LogSupport {
		
		private var _logger:ILogger;
		
		public function LogSupport(person:String=null ) {
			_logger = getLogger(this,person);
		}
		
		protected function debug( message: *, ...parameters:Array ): void {
			_logger.debug.apply( [message].concat( parameters ) );
		}
		
		protected function get debugEnabled(): Boolean {
			return _logger.debugEnabled;
		}
		
		protected function info( message: *, ...parameters:Array ): void {
			_logger.info.apply( [message].concat( parameters ) );
		}
		
		protected function get infoEnabled(): Boolean {
			return _logger.infoEnabled;
		}
		
		protected function warn( message: *, ...parameters:Array ): void {
			_logger.warn.apply( [message].concat( parameters ) );
		}
		
		protected function get warnEnabled(): Boolean {
			return _logger.warnEnabled;
		}
		
		protected function error( message: *, ...parameters:Array ): void {
			_logger.error.apply( [message].concat( parameters ) );
		}
		
		protected function get errorEnabled(): Boolean {
			return _logger.errorEnabled;
		}
		
		protected function fatal( message: *, ...parameters:Array ): void {
			_logger.fatal.apply( [message].concat( parameters ) );
		}
		
		protected function get fatalEnabled(): Boolean {
			return _logger.fatalEnabled;
		}
	}
}
