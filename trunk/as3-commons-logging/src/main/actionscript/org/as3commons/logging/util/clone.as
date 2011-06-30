package org.as3commons.logging.util {
	
	import flash.utils.Dictionary;
	
	/**
	 * @author Martin Heidegger
	 */
	public function clone( object: *, cloned: Dictionary = null ): * {
		if( object is QName ) {
			return {
				localName: object["localName"],
				uri: object["uri"]
			};
		}
		var theClone: * = null;
		if( cloned ) {
			theClone = cloned[ object ];
		}
		if( !theClone ) {
			if( object is String || object is Boolean || object is Namespace || object is Number || object == null || object is Function ) {
				return object;
			} else {
				if( !cloned ) {
					cloned = new Dictionary();
				}
				if( object is Array ) {
					var resultArr: Array = [];
					var arr: Array = object;
					var l: int = arr.length;
					for( var i: int = 0; i<l; ++i ) {
						resultArr[i] = clone(arr[i], cloned || (cloned = new Dictionary()));
					}
					theClone = resultArr;
				} else {
					try {
						theClone = object["clone"]();
					} catch( e: Error ) {
						try {
							BYTE_ARRAY.position = 0;
							BYTE_ARRAY.writeObject(object);
							BYTE_ARRAY.position = 0;
							theClone = BYTE_ARRAY.readObject();
						} catch( e2: Error ) {
							var resultObj: Object = {};
							var props: Array = allProperties( object );
							for( var prop: String in object ) {
								resultObj[prop] = clone(object[prop], cloned || (cloned = new Dictionary()));
							}
							theClone = resultObj;
						}
					}
				}
				cloned[object] = theClone;
			}
		}
		return theClone;
	}
}
import flash.utils.ByteArray;

const BYTE_ARRAY: ByteArray = new ByteArray();