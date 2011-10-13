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
package org.as3commons.logging.setup.log4j {
	
	import org.as3commons.logging.setup.HierarchicalSetup;
	
	/**
	 * @author Martin Heidegger
	 * @since 2.7
	 */
	public function log4jPropertiesToSetup(properties:String):HierarchicalSetup {
		const log4j: Log4JStyleSetup = new Log4JStyleSetup();
		const lines: Array = properties.split("\n");
		const l: int = lines.length;
		for( var lineNo: int= 0; lineNo < l; ++lineNo ) {
			var line: String = lines[lineNo];
			line = line.replace(/^\s*/, ''); // trim left
			var char: String = line.charAt(0);
			if( char != "!" && char != "#" ) {
				var lineData: Object = /^\s*(?P<key>([^\s\\:=]|(\\\s)|(\\n)|(\\r)|(\\t)|(\\\u[a-fA-F0-9]{4,4})|(\\[^\s]))*)\s*[=:]?\s*(?P<value>.*)$/m.exec(line);
				if( lineData ) {
					var key: String = unescape(lineData["key"]);
					var value: String = unescape(lineData["value"]);
					// Add later lines
					while( value.charAt(value.length-1) == "\\" ) {
						++lineNo;
						value = value.substr(0,value.length-1) + "\n" + unescape(lines[lineNo]);
					}
					var path: Array = key.split(".");
					var root: String = path.shift();
					if( root == "log4j" ) {
						var target: Object = log4j;
						while( path.length > 1 ) {
							target = target[path.shift()];
						}
						if( path.length == 1 ) {
							target[path[0]] = value;
						}
					}
				}
			}
		}
		return log4j.compile();
	}
}

function unescape(str:String):String {
	str = str.replace(/\\u([a-fA-F0-0]{4,4})/g, unicodeReplace);
	str = str.replace(/\\r/g, "\r");
	str = str.replace(/\\t/g, "\t");
	str = str.replace(/\\b/g, "\b");
	str = str.replace(/\\n/g, "\n");
	str = str.replace(/\\\\/g, "\\");
	return str;
}

function unicodeReplace(...args:Array):String {
	return String.fromCharCode(parseInt(args[1],16));
}
