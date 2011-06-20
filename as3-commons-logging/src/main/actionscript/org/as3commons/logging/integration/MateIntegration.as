package org.as3commons.logging.integration {
	
	import com.asfusion.mate.events.MateLogEvent;
	import mx.logging.ILogger;
	import com.asfusion.mate.core.MateManager;
	import com.asfusion.mate.utils.debug.IMateLogger;
	
	import org.as3commons.logging.getLogger;

	import mx.logging.ILoggingTarget;
	import mx.logging.LogEvent;
	import mx.logging.LogEventLevel;
	
	/**
	 * @author mh
	 */
	public class MateIntegration implements ILoggingTarget {
		
		private const _cache: Object = {};
		private var _filters: Array;
		private var _level: int;
		
		public function MateIntegration() {
			// Same like MateLogger, just to have fun :)
			MateManager.instance.debugger = this;
		}
		
		public function get filters() : Array {
			return _filters;
		}
		
		public function set filters( value:Array ):void {
			_filters = value;
		}
		
		public function get level():int {
			return _level;
		}
		
		public function set level( value:int ):void {
			_level = value;
		}
		
		/**
		 *  Sets up this target with the specified logger.
		 *  This allows this target to receive log events from the specified logger.
		 *
		 *  @param logger The ILogger that this target should listen to.
		 */
		public function addLogger(logger:ILogger):void {
			if(logger) {
				logger.addEventListener( LogEvent.LOG, logHandler,false,0,true);
			}
		}
		
		/**
		 *  Stops this target from receiving events from the specified logger.
		 *
		 *  @param logger The ILogger that this target should ignore.
		 */		
		public function removeLogger( logger:ILogger ):void {
			if(logger) {
				logger.addEventListener( LogEvent.LOG, logHandler,false,0,true);
			}
		}
		
		private function logHandler( event:LogEvent ):void {
			var category: String = IMateLogger( event.target ).category;
			var e: MateLogEvent = MateLogEvent( event );
			var logger: org.as3commons.logging.ILogger = _cache[ category ] || (_cache[ category ] = getLogger( category, "mate" ) );
			switch( event.level ) {
				case LogEventLevel.DEBUG:
					logger.debug.apply( null, [event.message].concat(e.parameters) );
					break;
				case LogEventLevel.INFO:
					logger.info.apply( null, [event.message].concat(e.parameters) );
					break;
				case LogEventLevel.WARN:
					logger.warn.apply( null, [event.message].concat(e.parameters) );
					break;
				case LogEventLevel.ERROR:
					logger.error.apply( null, [event.message].concat(e.parameters) );
					break;
				case LogEventLevel.FATAL:
					logger.fatal.apply( null, [event.message].concat(e.parameters) );
					break;
			}
		}
	}
}
