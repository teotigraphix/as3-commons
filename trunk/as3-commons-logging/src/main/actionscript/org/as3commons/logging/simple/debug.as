package org.as3commons.logging.simple {
	/**
	 * @author mh
	 */
	public function debug( message: *, ...parameters:Array ): void {
		DIRECT_LOGGER.debug.apply( [message].concat( parameters ) );
	}
}
