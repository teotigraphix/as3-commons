package org.as3commons.logging.integration {
	/**
	 * @author mh
	 */
	public function Progression4Integration( ...messages: Array ): void {
		var message: String;
		var level: String;
		if( messages.length == 3 ) {
			level = messages[1];
			message = messages[2];
		} else if( messages.length == 2 ){
			level = messages[0];
			message = messages[1];
		} else {
			message = messages[0];
		}
		if( level == "  [warn]" ) {
			logger.warn( message );
		} else if( level == "  [error]" ) {
			logger.error( message );
		} else if( level == "  [info]" ) {
			logger.info( message );
		} else {
			logger.debug( message );
		}
	}
}

import jp.nium.core.debug.Logger;

import org.as3commons.logging.ILogger;
import org.as3commons.logging.getLogger;

const logger: ILogger = getLogger( Logger, "Progression" );