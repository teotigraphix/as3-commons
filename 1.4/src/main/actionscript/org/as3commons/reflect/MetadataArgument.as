/*
 * Copyright (c) 2007-2009-2010 the original author or authors
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
package org.as3commons.reflect {
	import flash.utils.Dictionary;

	import org.as3commons.lang.Assert;
	import org.as3commons.lang.IEquals;

	/**
	 * Holds a key/value pair of metadata information.
	 *
	 * @author Christophe Herreman
	 */
	public class MetadataArgument implements IEquals {

		public var key:String;
		public var value:String;

		private static const _cache:Dictionary = new Dictionary();

		/**
		 * Creates a new MetadataArgument
		 *
		 * @param key the metadata key
		 * @param value the metadata value
		 */
		public function MetadataArgument(key:String, value:String) {
			this.key = key;
			this.value = value;
		}

		public function equals(other:Object):Boolean {
			Assert.state(other is MetadataArgument, "other argument must be of type MetadataArgument");
			var otherArgument:MetadataArgument = MetadataArgument(other);
			return ((otherArgument.key == this.key) && (otherArgument.value == this.value));
		}

		public static function newInstance(key:String, value:String):MetadataArgument {
			return getFromCache(key, value);
		}

		private static function addToCache(metadataArgument:MetadataArgument):void {
			var cacheKey:String = metadataArgument.key.toLowerCase();
			var instances:Array = _cache[cacheKey];
			if (instances == null) {
				instances = [];
				instances[0] = metadataArgument;
				_cache[cacheKey] = instances;
			} else {
				instances[instances.length] = metadataArgument;
			}
		}

		private static function getFromCache(key:String, value:String):MetadataArgument {
			var metadataArgument:MetadataArgument = new MetadataArgument(key, value);
			var instances:Array = _cache[key.toLowerCase()];
			if (instances == null) {
				addToCache(metadataArgument);
			} else {
				var found:Boolean = false;
				for each (var mda:MetadataArgument in instances) {
					if (mda.equals(metadataArgument)) {
						metadataArgument = mda;
						found = true;
						break;
					}
				}
				if (!found) {
					addToCache(metadataArgument);
				}
			}
			return metadataArgument;
		}

	}
}
