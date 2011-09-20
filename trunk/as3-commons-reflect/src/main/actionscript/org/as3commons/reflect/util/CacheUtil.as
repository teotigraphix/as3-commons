/*
 * Copyright (c) 2007-2011 the original author or authors
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
package org.as3commons.reflect.util {
	import flash.system.ApplicationDomain;

	import org.as3commons.lang.HashArray;
	import org.as3commons.reflect.Metadata;

	import org.as3commons.reflect.as3commons_reflect;

	public class CacheUtil {

		private static var _appDomains:Array = [];

		// --------------------------------------------------------------------
		//
		// Class Methods
		//
		// --------------------------------------------------------------------

		public static function getApplicationDomainIndex(applicationDomain:ApplicationDomain):int {
			if (_appDomains.indexOf(applicationDomain) == -1) {
				_appDomains.push(applicationDomain);
			}
			return _appDomains.indexOf(applicationDomain);
		}

		public static function getMetadataString(metadataArray:HashArray):String {
			var result:String = "";

			if (metadataArray) {
				var md:Array = metadataArray.getArray();
				for each (var metadata:Metadata in md) {
					result += Metadata.getCacheKey(metadata) + ","
				}
			}

			return result;
		}

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function CacheUtil() {
		}


	}
}
