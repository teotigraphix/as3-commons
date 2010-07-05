package org.as3commons.logging.setup.target {
	import flash.utils.Dictionary;

	import org.as3commons.logging.setup.ILogTarget;
	/**
	 * @author mh
	 */
	public function mergeTargets( ...targets ):ILogTarget {
		var contains: Dictionary = new Dictionary();
		var target: ILogTarget = null;
		while( targets.length > 0 ) {
			var current: ILogTarget = targets.shift() as ILogTarget;
			if( current && !contains[current] ) {
				contains[current] = true;
				if( target ) {
					target = new MergedTarget( target, current );
				} else {
					target = current;
				}
			}
		}
		return target;
	}
}
