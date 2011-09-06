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
package org.as3commons.logging.util.xml {
	
	import org.as3commons.logging.setup.ILogTarget;
	
	/**
	 * @author Martin Heidegger
	 * @since 2.6
	 * @see org.as3commons.logging.util.xml#xmlToSetup()
	 */
	public function xmlToTarget(xml:XML, targetTypes:Object):ILogTarget {
		if (xml.namespace() == xmlNs && xml.localName() == "target" ) {
			var type: Class = targetTypes[QName(xml.@type).toString()];
			if (type) {
				var args: Array = [];
				for each (var arg: XML in xml.xmlNs::arg) {
					var argString: String;
					var argValue: * = null;
					if (arg.hasOwnProperty("@value") ) {
						argString = QName(arg.@value).toString();
					} else {
						argString = arg.toString();
					}
					if(argString != "") {
						argValue = parseInt(argString);
						if (isNaN(argValue)) {
							argValue = parseFloat(argString);
							if (isNaN(argValue)){
								if(bool.test(argString)) {
									argValue = argString.toLowerCase() == "true";
								} else {
									argValue = argString;
								}
							}
						}
					}
					args.push(argValue);
				}
				if (args.length == 0) {
					return new type();
				}
				if (args.length == 1) {
					return new type(args[0]);
				}
				if (args.length == 2) {
					return new type(args[0], args[1]);
				}
				if (args.length == 3) {
					return new type(args[0], args[1], args[2]);
				}
				if (args.length == 4) {
					return new type(args[0], args[1], args[2], args[3]);
				}
				if (args.length == 5) {
					return new type(args[0], args[1], args[2], args[3], args[4]);
				}
				if (args.length == 6) {
					return new type(args[0], args[1], args[2], args[3], args[4],
						args[5]);
				}
				if (args.length == 7) {
					return new type(args[0], args[1], args[2], args[3], args[4],
						args[5], args[6]);
				}
				if (args.length == 8) {
					return new type(args[0], args[1], args[2], args[3], args[4],
						args[5], args[6], args[7]);
				}
				if (args.length == 9) {
					return new type(args[0], args[1], args[2], args[3], args[4],
						args[5], args[6], args[7], args[8]);
				}
				if (args.length == 10) {
					return new type(args[0], args[1], args[2], args[3], args[4],
						args[5], args[6], args[7], args[8], args[9]);
				}
				if (args.length == 11) {
					return new type(args[0], args[1], args[2], args[3], args[4],
						args[5], args[6], args[7], args[8], args[9], args[10]);
				}
				if (args.length == 12) {
					return new type(args[0], args[1], args[2], args[3], args[4],
						args[5], args[6], args[7], args[8], args[9], args[10], args[11]);
				}
				if (args.length == 13) {
					return new type(args[0], args[1], args[2], args[3], args[4],
						args[5], args[6], args[7], args[8], args[9], args[10], args[11],
						args[12]);
				}
				if (args.length == 14) {
					return new type(args[0], args[1], args[2], args[3], args[4],
						args[5], args[6], args[7], args[8], args[9], args[10], args[11],
						args[12], args[13]);
				}
			}
		}
		return null;
	}
}
var bool: RegExp = /^(true|false)$/i;