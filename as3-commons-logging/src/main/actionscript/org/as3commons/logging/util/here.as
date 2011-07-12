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
	import flash.system.Capabilities;
	
	/**
	 * Extracts the current method name/linenumber from the calling position if
	 * possible.
	 * 
	 * <p>In the release player it is not possible to retreive the current location.</p>
	 * 
	 * <p>Note: It is just with the debug player possible to get the current target,
	 * see: Bug FP-644 in the adobe bug base.</p> 
	 * 
	 * <p>Warning: Performance intense task, use with care!</p> 
	 * 
	 * @author Martin Heidegger
	 * @since 2.5
	 * @see https://bugs.adobe.com/jira/browse/FP-644
	 */
	public function here(): String {
		if( Capabilities.isDebugger ) {
			var error: Error = new Error();
			var stackTrace: String = error.getStackTrace();
			if( stackTrace ) {
				// just in debug player
				var nextLine: int = stackTrace.indexOf("\n");
				// chop first two lines
				stackTrace = stackTrace.substr(nextLine+1);
				nextLine = stackTrace.indexOf("\n");
				stackTrace = stackTrace.substr(nextLine+1);
				nextLine = stackTrace.indexOf("\n");
				if( nextLine != -1 ) {
					stackTrace = stackTrace.substring(0, nextLine);
				} 
				var braces: int = stackTrace.indexOf("(");
				var name: String = stackTrace.substring(4,braces);
				if( braces != stackTrace.length-2 ) {
					 name += stackTrace.substring( stackTrace.lastIndexOf(":"), stackTrace.length-1 );
				}
				return name;
			}
		}
		return "";
	}
}