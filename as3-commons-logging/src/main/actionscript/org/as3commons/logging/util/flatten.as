package org.as3commons.logging.util {
	/**
	 * @author mh
	 */
	public function flatten(arr: Array): void {
		for( var i: int = arr.length-1; i>=0; --i ) {
			var child: * = arr[i];
			if( child is Array ) {
				var childArr: Array = child as Array;
				flatten(childArr);
				childArr.unshift(1);
				childArr.unshift(i);
				arr.splice.apply(null,childArr);
			}
		}
	}
}
