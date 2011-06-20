package org.as3commons.logging.simple {
	/**
	 * @author mh
	 */
	public function fatal( message: *, ...parameters:Array ): void {
		DIRECT_LOGGER.fatal.apply( [message].concat( parameters ) );
	}
}
