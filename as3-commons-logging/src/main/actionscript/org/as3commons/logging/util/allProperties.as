package org.as3commons.logging.util {
	import avmplus.getQualifiedClassName;
	import flash.utils.describeType;
	
	/**
	 * @author Martin Heidegger
	 */
	public function allProperties( value: * ): Array {
		var cls:String = getQualifiedClassName(value);
		var result: Array = storage[ cls ];
		var l: int = 0;
		if( !result ) {
			if( cls == "QName" ) {
				result = ["uri","localName"];
			} else {
				var xml: XML = describeType( value );
				if( xml.@isDynamic == "true" ) {
					result = DYNAMIC;
				} else {
					result = [];
					var properties: XMLList = (
												xml["factory"]["accessor"] + xml["accessor"]
											  ).( @access=="readwrite" || @access=="readonly" )
											+ xml["factory"]["variable"] + xml["variable"];
					
					for each( var property: XML in properties ) {
						result[l++] = XML( property.@name ).toString();
					}
				}
			}
			result.sort();
			storage[cls] = result;
		}
		if( result == DYNAMIC ) {
			result = [];
			for( var i: String in value ) {
				result.push(i);
			}
			result.sort();
			return result;
		} else {
			return result;
		}
	}
}

const DYNAMIC: Array = [];
const storage: Object = {};
