package org.as3commons.logging.integration {
	
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.getLogger;
	import org.swizframework.utils.logging.AbstractSwizLoggingTarget;
	import org.swizframework.utils.logging.SwizLogEvent;
	import org.swizframework.utils.logging.SwizLogEventLevel;
	import org.swizframework.utils.logging.SwizLogger;
	
	/**
	 * @author mh
	 */
	public class SwizIntegration extends AbstractSwizLoggingTarget {
		
		private const _cache: Object = {};
		
		override protected function logEvent( event:SwizLogEvent ):void {
			var category: String = SwizLogger( event.target ).category.replace("::", ".");
			var logger: ILogger = _cache[ category ] || (_cache[ category ] = getLogger( category, "swiz" ) );
			switch( event.level ) {
				case SwizLogEventLevel.DEBUG:
					logger.debug( event.message );
					break;
				case SwizLogEventLevel.INFO:
					logger.info( event.message );
					break;
				case SwizLogEventLevel.WARN:
					logger.warn( event.message );
					break;
				case SwizLogEventLevel.ERROR:
					logger.error( event.message );
					break;
				case SwizLogEventLevel.FATAL:
					logger.fatal( event.message );
					break;
			}
		}
	}
}
