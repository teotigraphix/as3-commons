package org.as3commons.logging.util {
	
	import flash.events.ErrorEvent;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Introspects a object, makes it js transferable and returns it.
	 * 
	 * @param value any object
	 * @return js valid representation
	 */
	public function introspect( value: *, map: Dictionary, levels: uint ): * {
		if( value is Boolean ) {
			return value;
		}
		if( value is Error || value is ErrorEvent ) {
			return new ErrorHolder( value );
		}
		var result: Object = map[ value ];
		if( !result ) {
			map[ value ] = result = {};
			var props: Array = allProperties( value );
			for each( var prop: String in props ) {
				var child: * = value[ prop ];
				if( child is Function || child is Class ) {
					child = getQualifiedClassName( child );
				}
				if( child is String ) {
					child = String( child ).split("\\").join("\\\\");
				} else if( child is Object && !( child is Number || child is Boolean ) ) {
					if( levels > 0 ) {
						child = introspect( child, map, levels - 1 );
					} else {
						// Next Loop, introspection amount done
						continue;
					}
				}
				result[ prop ] = child;
			}
		}
		return result;
	}
}
