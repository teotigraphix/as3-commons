package org.as3commons.logging {
	
	import org.as3commons.logging.util.toLogName;
	
	public function getClassLogger(input: *): ILogger {
		return LOGGER_FACTORY.getLogger(toLogName(input));
	}
}

