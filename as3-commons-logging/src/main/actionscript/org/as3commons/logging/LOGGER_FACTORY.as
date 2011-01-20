package org.as3commons.logging {
	
	import org.as3commons.logging.setup.target.TraceTarget;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	
	/**
	 * @author Martin Heidegger
	 */
	public const LOGGER_FACTORY: LoggerFactory = new LoggerFactory( new SimpleTargetSetup(TraceTarget.INSTANCE) );
}
