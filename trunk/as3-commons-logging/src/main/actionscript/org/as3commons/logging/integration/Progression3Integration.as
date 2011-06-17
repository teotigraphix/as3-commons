package org.as3commons.logging.integration {
	/**
	 * @author mh
	 */
	public function Progression3Integration( message: String ): void {
		var level: String;
		if( message.indexOf(ERROR) == 0 ) {
			logger.error( message.substr(ERROR.length) );
		} else if( message.indexOf(LOG) == 0 ) {
			logger.info( message.substr(LOG.length) );
		} else if( message.indexOf(WARNING) == 0 ) {
			logger.warn( message.substr(WARNING.length) );
		} else {
			logger.debug( message );
		}
	}
}

import jp.progression.core.debug.Verbose;

import org.as3commons.logging.ILogger;
import org.as3commons.logging.getLogger;

const ERROR: String = "[ERROR] ";
const LOG: String = "[LOG] ";
const WARNING: String = "[WARNING] ";
const logger: ILogger = getLogger( Verbose, "Progression" );