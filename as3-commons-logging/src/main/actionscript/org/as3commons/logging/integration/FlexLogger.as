package org.as3commons.logging.integration {
	import org.as3commons.logging.getNamedLogger;
	import mx.logging.LogEventLevel;
	import mx.logging.ILogger;

	import mx.logging.AbstractTarget;
	import mx.logging.ILoggingTarget;
	import mx.logging.LogEvent;

	import flash.utils.Dictionary;

	/**
	 * @author mh
	 */
	public class FlexLogger extends AbstractTarget implements ILoggingTarget {
		
		private var _loggerMap:Dictionary = new Dictionary();
		
		public function FlexLogger( level: int ) {
			super();
			this.level = level;
		}
		
		override public function addLogger(logger:ILogger):void {
			super.addLogger(logger);
			if( logger ) {
				_loggerMap[ logger ] = getNamedLogger(logger.category);
			}
		}
		
		override public function logEvent(event:LogEvent):void {
			var logger: org.as3commons.logging.ILogger = _loggerMap[ event.target ];
			if( event.level < LogEventLevel.FATAL ) {
				if( event.level < LogEventLevel.WARN ) {
					if( event.level < LogEventLevel.INFO ) {
						logger.debug( event.message );
					} else {
						logger.info( event.message );
					}
				} else {
					if( event.level < LogEventLevel.ERROR ) {
						logger.warn( event.message );
					} else {
						logger.error( event.message );
					}
				}
			} else {
				logger.fatal( event.message );
			}
		}
	}
}
