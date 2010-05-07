/*
* Copyright 2009-2010 the original author or authors.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*      http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
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
		return new ToStringBuilder(this)
			.append(size(), "size")
			.toString();
	}
}
}