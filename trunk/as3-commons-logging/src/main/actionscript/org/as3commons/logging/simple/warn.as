package org.as3commons.logging.simple {
	/**
	 * @author mh
	 */
	public function warn( message: *, ...parameters:Array ): void {
		DIRECT_LOGGER.warn.apply( [message].concat( parameters ) );
	}
}
