package org.as3commons.logging.simple {
	/**
	 * @author mh
	 */
	public function error( message: *, ...parameters:Array ): void {
		DIRECT_LOGGER.error.apply( [message].concat( parameters ) );
	}
}
