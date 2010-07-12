package org.as3commons.logging {
	/**
	 * @author mh
	 */
	public function getLogger(input:*):ILogger {
		return LoggerFactory.getLogger(input);
	}
}
