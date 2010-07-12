package org.as3commons.logging {
	/**
	 * @author mh
	 */
	public function getNamedLogger(name:String):ILogger {
		return LoggerFactory.getNamedLogger(name);
	}
}
