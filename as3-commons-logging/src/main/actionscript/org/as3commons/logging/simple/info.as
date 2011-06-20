package org.as3commons.logging.simple {
	/**
	 * @author mh
	 */
	public function info( message: *, ...parameters:Array ): void {
		DIRECT_LOGGER.info.apply( [message].concat( parameters ) );
	}
}
