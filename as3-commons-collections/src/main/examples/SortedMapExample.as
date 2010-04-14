/**
 * Copyright 2010 The original author or authors.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package {
	import org.as3commons.collections.SortedMap;
	import org.as3commons.collections.framework.ICollectionIterator;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.framework.IMapIterator;
	import org.as3commons.collections.utils.NumericComparator;
	import flash.display.Sprite;

	public class SortedMapExample extends Sprite {

		public function SortedMapExample() {
			
			var map : SortedMap = new SortedMap(new NumericComparator());
			
			// Add
			
			map.add("threeA", 3);
			map.add("four", 4);
			map.add("one", 1);
			map.add("threeB", 3);
			map.add("five", 5);
			map.add("two", 2);
			map.add("threeC", 3);
			trace (map.keysToArray()); // one,two,threeA,threeB,threeC,four,five
			trace (map.toArray()); // 1,2,3,3,3,4,5
			
			// Replace

			map.replaceFor("one", 4);
			map.replaceFor("threeB", -3);
			trace (map.keysToArray()); // threeB,two,threeA,threeC,four,one,five
			trace (map.toArray()); // -3,2,3,3,4,4,5

			// Inspection
			
			trace (map.first); // -3
			trace (map.last); // 5

			trace (map.hasEqual(3)); // true
			trace (map.hasEqual(6)); // false
			trace (map.equalKeys(3)); // threeA,threeC
			
			trace (map.lesserKey(-4)); // undefined
			trace (map.lesserKey(-3)); // undefined
			trace (map.lesserKey(-2)); // threeB
			trace (map.lesserKey(4)); // threeC
			
			trace (map.higherKey(2)); // threeA
			trace (map.higherKey(3)); // four
			trace (map.higherKey(5)); // undefined
			trace (map.higherKey(6)); // undefined
			
			// Iterator

			var iterator : IIterator = map.iterator();
			trace (iterator is IIterator); // true
			trace (iterator is ICollectionIterator); // true
			trace (iterator is IMapIterator); // true
			
			while (iterator.hasNext()) {
				trace (iterator.next()); // -3,2,3,3,4,4,5
			}

			// Remove

			map.removeFirst();
			map.removeFirst();
			map.removeLast();
			map.removeLast();
			trace (map.keysToArray()); // threeA,threeC,four
			trace (map.toArray()); // 3,3,4
		}
	}
}
