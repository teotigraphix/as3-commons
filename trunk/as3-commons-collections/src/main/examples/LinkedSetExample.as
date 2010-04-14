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
	import org.as3commons.collections.LinkedSet;
	import org.as3commons.collections.framework.ICollectionIterator;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.framework.IMapIterator;
	import org.as3commons.collections.framework.IOrderedMapIterator;
	import flash.display.Sprite;

	public class LinkedSetExample extends Sprite {

		public function LinkedSetExample() {
			var theSet : LinkedSet = new LinkedSet();
			
			// Add
			
			theSet.add(4);
			theSet.add(1);
			theSet.add(3);
			theSet.add(5);
			theSet.add(2);
			trace (theSet.toArray()); // 4,1,3,5,2
			
			theSet.addBefore(3, 6);
			theSet.addAfter(5, 7);
			trace (theSet.toArray()); // 4,1,6,3,5,7,2

			theSet.addFirst(8);
			theSet.addLast(9);
			trace (theSet.toArray()); // 8,4,1,6,3,5,7,2,9

			// Inspection
			
			trace (theSet.first); // 8
			trace (theSet.last); // 9
			
			// Iterator

			var iterator : IIterator = theSet.iterator();
			trace (iterator is IIterator); // true
			trace (iterator is ICollectionIterator); // true
			trace (iterator is IMapIterator); // true
			trace (iterator is IOrderedMapIterator); // true
			
			while (iterator.hasNext()) {
				trace (iterator.next()); // 8,4,1,6,3,5,7,2,9
			}

			// Remove

			theSet.removeFirst();
			theSet.removeFirst();
			theSet.removeLast();
			theSet.removeLast();
			trace (theSet.toArray()); // 1,6,3,5,7
		}
	}
}
