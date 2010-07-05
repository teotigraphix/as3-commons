package org.as3commons.logging.setup.target {
	import org.as3commons.logging.LogLevel;
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
		
		public function log(name:String, shortName:String, level:LogLevel, timeStamp:Number, message:String, parameters:Array):void {
			var args: Array = parameters.concat();
			args.unshift(message);
			switch( level ) {
				case LogLevel.DEBUG:
					_target.debug.apply( _target, args );
					break;
				case LogLevel.INFO:
					_target.info.apply( _target, args );
					break;
				case LogLevel.WARN:
					_target.warn.apply( _target, args );
					break;
				case LogLevel.ERROR:
					_target.error.apply( _target, args );
					break;
				case LogLevel.FATAL:
					_target.fatal.apply( _target, args );
					break;
			}
		}
	}
}
