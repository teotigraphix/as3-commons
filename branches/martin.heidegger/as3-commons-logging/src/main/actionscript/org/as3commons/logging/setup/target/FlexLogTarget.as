package org.as3commons.logging.setup.target {
	import org.as3commons.logging.LogLevel;
	import org.as3commons.logging.level.DEBUG;
	import org.as3commons.logging.level.ERROR;
	import org.as3commons.logging.level.FATAL;
	import org.as3commons.logging.level.INFO;
	import org.as3commons.logging.level.WARN;
	import org.as3commons.logging.setup.ILogTarget;

	import mx.logging.ILogger;

	/**
	 * @author mh
	 */
	public class FlexLogTarget implements ILogTarget {
		
		private var _target:ILogger;
		
		public function FlexLogTarget( target: ILogger ) {
			_target = target;
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
