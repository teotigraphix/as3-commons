/*
 * Copyright (c) 2008-2009 the original author or authors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package org.as3commons.logging.util {
	import flash.utils.Dictionary;
	
	/**
	 * Creates a json string from a given object.
	 * 
	 * <p>We are using a extended json fromat that uses references, much alike
	 * the dojo format.</p> 
	 * 
	 * @author Martin Heidegger
	 * @since 2.5
	 * @see http://www.sitepen.com/blog/2008/06/17/json-referencing-in-dojo/
	 * @see http://dojotoolkit.org/reference-guide/dojox/json/ref.html
	 * @see http://dojotoolkit.org/api/1.5/dojox/json/ref
	 */
	public function jsonXify(object:*, levels:int=5): String {
		object = objectify(object,new Dictionary(), levels);
		referenceMap = new Dictionary();
		counter = 0;
		var result: String = doJsonIfy(object,levels);
		referenceMap = null;
		if(result.charAt(0)!="{") {
			result = '{data:'+result+'}';
		}
		return result;
	}
}

import flash.utils.Dictionary;
var referenceMap: Dictionary;
var counter: int;
function doJsonIfy(object:*,levels:int):String {
	var result:String;
	if( object is String ) {
		result = '"'+(object as String).split('"').join('\"')+'"';
	} else if(object is Number || object is Boolean || object == null) {
		result = object;
	} else if(object is Array) {
		result='[';
		if( levels < 0 ) {
			result='"Depth exceeded."';
		} else {
			var l:int = object["length"];
			for( var i:int=0;i<l;++i ) {
				if(i!=0) {
					result+=',';
				}
				result+=doJsonIfy(object[i],levels-1);
			}
		}
		result+=']';
	} else {
		var id: int =referenceMap[object];
		if( id > 0 ) {
			result = '{"$ref":'+id+'}';
		} else {
			counter+=1;
			referenceMap[object] = counter;
			var first:Boolean = true;
			result='{id:'+counter;
			for( var prop:String in object ) {
				result+=',"'+prop.split('"').join('\"')+'":'+doJsonIfy(object[prop],levels);
			}
			result+='}';
		}
	}
	return result;
}
