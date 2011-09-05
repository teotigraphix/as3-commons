package org.as3commons.logging.setup {
	import org.as3commons.logging.api.ILogSetup;

	import flash.utils.Dictionary;
	/**
	 * @author mh
	 */
	public function mergeSetups( ...targets ):ILogSetup {
		var contains: Dictionary = new Dictionary();
		var target: ILogSetup = null;
		while( targets.length > 0 ) {
			var currentRaw: * = targets.shift();
			if( currentRaw is Array ) {
				currentRaw = mergeSetups.apply(null, currentRaw);
			}
			var current: ILogSetup = currentRaw as ILogSetup;
			if( current && !contains[current] ) {
				contains[current] = true;
				if( target ) {
					target = new MergedSetup( target, current );
				} else {
					target = current;
				}
			}
		}
		return target;
	}
}
