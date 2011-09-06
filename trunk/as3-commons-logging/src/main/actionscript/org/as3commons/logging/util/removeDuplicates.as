package org.as3commons.logging.util {
	
	import flash.utils.Dictionary;
	
	/**
	 * @author mh
	 */
	public function removeDuplicates(arr:Array):void {
		var contains: Dictionary = new Dictionary();
		var l: int = arr.length;
		for( var i: int = 0; i < l; ++i) {
			var entry: * = arr[i];
			if( contains[entry] ) {
				arr.splice(i,1);
				--i;
				--l;
			} else {
				contains[entry] = true;
			}
		}
	}
}
