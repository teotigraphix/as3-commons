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
package org.as3commons.emit {
	import flash.utils.Dictionary;

	import org.as3commons.lang.Assert;
	import org.as3commons.lang.DictionaryUtils;
	import org.as3commons.lang.builder.ToStringBuilder;

	/**
	 * Cache for Class definitions.
	 *
	 * <p>Maintains a cache of class definitions by the class definitions
	 * qualified name.</p>
	 *
	 * @author Andrew Lewisohn
	 */
	internal class ClassCache {

		//--------------------------------------------------------------------------
		//
		//  Variable
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 * Map of class definitions to class definitions.
		 */
		private var cache:Dictionary = new Dictionary();

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 * Constructor.
		 */
		public function ClassCache() {
		}

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		/**
		 * Clears all classes from the cache.
		 */
		internal function clear():void {
			cache = new Dictionary();
		}

		/**
		 * Return <code>true</code> if there is a cached class definition for the
		 * given key.
		 *
		 * @param key the class definition used as a key (never <code>null</code>)
		 */
		internal function contains(key:Class):Boolean {
			Assert.notNull(key, "argument 'key' must not be null");
			return (cache[key] != null);
		}

		/**
		 * Obtain a cached class definition for the given key.
		 *
		 * @param key the qualified name of the class definition
		 * 	(never <code>null</code>)
		 * @return the corresponding class definition,
		 * 	or <code>null</code> if not found in the cache.
		 * @see #remove()
		 */
		internal function get(key:Class):Class {
			Assert.notNull(key, "argument 'key' must not be null");
			return cache[key];
		}

		/**
		 * Explicitly add a class deifinition to the cache under the given key.
		 *
		 * @param key the qualified name of the class definition
		 * 	(never <code>null</code>)
		 * @param context the class definition to store(never <code>null</code>)
		 */
		internal function put(key:Class, cls:Class):void {
			Assert.notNull(key, "argument 'key' must not be null");
			Assert.notNull(cls, "argument 'cls' must not be null");
			cache[key] = cls;
		}

		/**
		 * Remove the class definition with the given key.
		 *
		 * @param key key the qualified name of the class definition
		 * 	(never <code>null</code>)
		 * @return the corresponding class definition or <code>null</code>
		 * 	if not found in the cache.
		 */
		internal function remove(key:Class):Class {
			Assert.notNull(key, "argument 'key' must not be null");
			var cls:Class = cache[key];
			delete cache[key];
			return cls;
		}

		/**
		 * Determine the number of contexts currently stored in the cache. If the
		 * cache contains more than <tt>Number.MAX_VALUE</tt> elements, returns
		 * <tt>Number.MAX_VALUE</tt>.
		 */
		internal function size():int {
			return DictionaryUtils.getKeys(cache).length;
		}

		/**
		 * Generates a text string, which contains the size of the cache.
		 */
		public function toString():String {
			return new ToStringBuilder(this).append(size(), "size").toString();
		}
	}
}