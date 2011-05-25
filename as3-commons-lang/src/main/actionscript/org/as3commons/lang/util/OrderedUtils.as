/*
 * Copyright 2007-2011 the original author or authors.
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
package org.as3commons.lang.util {
	import org.as3commons.lang.IOrdered;

	/**
	 * Static helper methods for working with the <code>IOrdered</code> interface.
	 * @author Roland Zwaga
	 * @see org.as3commons.lang.IOrdered IOrdered
	 */
	public final class OrderedUtils {

		/**
		 * The property name that is used to sort objects that implement the <code>IOrdered</code> interface.
		 */
		public static const ORDERED_PROPERTYNAME:String = "order";

		/**
		 * Helper method to sort an <code>Array</code> of object instances, some of which
		 * may implement the <code>IOrdered</code> interface. All objects that implement
		 * <code>IOrdered</code> will be sorted and put at the start a new <code>Array</code>, the
		 * remaining objects will be concatenated to this and the resulting <code>Array</code>
		 * is returned.
		 * @param source The specified <code>Array</code> of object instances.
		 * @return The sorted <code>Array</code> of object instances.
		 * @see org.as3commons.lang.IOrdered IOrdered
		 */
		public static function sortOrderedArray(source:Array):Array {
			var ordered:Array = [];
			var unordered:Array = [];
			for each (var obj:Object in source) {
				if (obj is IOrdered) {
					ordered[ordered.length] = obj;
				} else {
					unordered[unordered.length] = obj;
				}
			}
			ordered.sortOn(ORDERED_PROPERTYNAME, Array.NUMERIC);
			return ordered.concat(unordered);
		}
	}
}
