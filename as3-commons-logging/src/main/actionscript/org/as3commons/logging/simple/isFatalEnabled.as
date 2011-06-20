package org.as3commons.logging.simple {
	/**
	 * @author mh
	 */
	public function isFatalEnabled(): Boolean {
		return DIRECT_LOGGER.warnEnabled;
	}
}
