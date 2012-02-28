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
	
	/**
	 * Creates a json string from a given object.
	 * 
	 * <p>It uses a extended json fromat that uses references, much alike
	 * the dojo format. In this format references are identified using a id property.
	 * and </p>
	 * 
	 * <p>This method 
	 * 
	 * @author Martin Heidegger
	 * @since 2.5
	 * @see http://www.sitepen.com/blog/2008/06/17/json-referencing-in-dojo/
	 * @see http://dojotoolkit.org/reference-guide/dojox/json/ref.html
	 * @see http://dojotoolkit.org/api/1.5/dojox/json/ref
	 */
	public function jsonXify(object:*, levels:int=5): String {
		refCounter = 0;
		buffer = [];
		bufferIndex = -1;
		
		result = null;
		
		doJsonIfy(object, levels);
		if(result) {
			result = result + buffer.join("");
		} else {
			result = buffer.join("");
		}
		if(result.charAt(0)!="{") {
			result = '{data:'+result+'}';
		}
		refMap = null;
		return result;
	}
}

import flash.utils.Dictionary;
var refMap: Dictionary;
var refCounter: int;
var buffer: Array;
var bufferIndex: int;
var result: String;
function doJsonIfy(object:*,levels:int):void {
	if( object is String ) {
		buffer[++bufferIndex] = '"';
		buffer[++bufferIndex] = (object as String).split('"').join('\"');
		buffer[++bufferIndex] = '"';
	} else if(object is Number || object is Boolean || object == null) {
		buffer[++bufferIndex] = String(object);
	} else if(object is Array) {
		buffer[++bufferIndex] = '[';
		if( levels < 0 ) {
			buffer[++bufferIndex] = '"Depth exceeded."';
		} else {
			var l:int = object["length"];
			for( var i:int=0;i<l;++i ) {
				if(i!=0) {
					buffer[++bufferIndex] = ',';
				}
				doJsonIfy(object[i],levels-1);
			}
		}
		buffer[++bufferIndex] = ']';
	} else {
		var id: int = (refMap||=new Dictionary())[object];
		if( id > 0 ) {
			buffer[++bufferIndex] = '{"$ref":';
			buffer[++bufferIndex] = id.toString(16);
			buffer[++bufferIndex] = '}';
		} else {
			(refMap||=new Dictionary())[object] = ++refCounter;
			var first:Boolean = true;
			buffer[++bufferIndex] = '{_:';
			buffer[++bufferIndex] = refCounter.toString(36);
			for( var prop:String in object ) {
				if( prop != "_" ) {
					buffer[++bufferIndex] = ',"';
					buffer[++bufferIndex] = prop.split('"').join('\"');
					buffer[++bufferIndex] = '":';
				} else {
					//logger.warn("Can not process properties called '$id'.");
				}
				doJsonIfy(object[prop],levels);
			}
			buffer[++bufferIndex] = '}';
		}
	}
	if( bufferIndex > 32760 ) {
		if( result ) {
			result = result + buffer.join("");
		} else {
			result = buffer.join("");
		}
		buffer = [];
		bufferIndex = -1;
	}
}
