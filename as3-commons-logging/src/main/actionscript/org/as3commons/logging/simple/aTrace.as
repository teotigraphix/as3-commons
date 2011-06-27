
package org.as3commons.logging.simple {
	
	public function aTrace( ...args:Array ): void {
		if( isInfoEnabled() ) {
			info( args.join(" ") );
		}
	}
}
