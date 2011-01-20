package org.as3commons.logging.setup.target {
	import org.as3commons.logging.LogLevel;
	import org.as3commons.logging.Logger;
	import org.as3commons.logging.level.DEBUG;
	import org.as3commons.logging.level.ERROR;
	import org.as3commons.logging.level.FATAL;
	import org.as3commons.logging.level.INFO;
	import org.as3commons.logging.level.WARN;
	import org.as3commons.logging.setup.ILogTarget;
	import org.as3commons.logging.setup.LogSetupLevel;

	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.logging.LogEventLevel;

	/**
	 * @author mh
	 */
	public class FlexLogTarget implements ILogTarget {
		
		private var _target:ILogger;
		
		public function FlexLogTarget(name: String) {
			_target = Log.getLogger(name);
		}
		
		public function applyTo(logger:Logger): void {
			var level: LogSetupLevel;
			try {
				var flexLevel: int = _target["level"];
				level = LogSetupLevel.NONE;
				if( flexLevel & LogEventLevel.DEBUG == LogEventLevel.DEBUG ) {
					level = level.or( LogSetupLevel.DEBUG );
				}
				if( flexLevel & LogEventLevel.INFO == LogEventLevel.INFO ) {
					level = level.or( LogSetupLevel.INFO );
				}
				if( flexLevel & LogEventLevel.WARN == LogEventLevel.WARN ) {
					level = level.or( LogSetupLevel.WARN );
				}
				if( flexLevel & LogEventLevel.ERROR == LogEventLevel.ERROR ) {
					level = level.or( LogSetupLevel.ERROR );
				}
				if( flexLevel & LogEventLevel.FATAL == LogEventLevel.FATAL ) {
					level = level.or( LogSetupLevel.FATAL );
				}
			} catch( error: Error ) {
				// It might be possible to guess the logLevel with Log. methods
				// but this doesn't apply to the ILogger instance.
				level = LogSetupLevel.ALL;
			}
			level.applyTo(logger, this);
		}
		
		public function log(name:String, shortName:String, level:LogLevel, timeStamp:Number, message:*, parameters:Array):void {
			var args: Array = parameters.concat();
			args.unshift( message["toString"]() );
			switch( level ) {
				case DEBUG:
					_target.debug.apply( _target, args );
					break;
				case INFO:
					_target.info.apply( _target, args );
					break;
				case WARN:
					_target.warn.apply( _target, args );
					break;
				case ERROR:
					_target.error.apply( _target, args );
					break;
				case FATAL:
					_target.fatal.apply( _target, args );
					break;
			}
		}
	}
}
