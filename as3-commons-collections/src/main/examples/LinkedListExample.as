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
	import org.as3commons.collections.LinkedList;
	import org.as3commons.collections.framework.ICollectionIterator;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.framework.ILinkedList;
	import org.as3commons.collections.framework.ILinkedListIterator;
	import flash.display.Sprite;

	public class LinkedListExample extends Sprite {

		public function LinkedListExample() {
			var list : ILinkedList = new LinkedList();
			
			// Add
			
			list.add(4);
			list.add(1);
			list.add(3);
			list.add(5);
			list.add(2);
			trace (list.toArray()); // 4,1,3,5,2
			
			list.addFirst(6);
			list.addLast(7);
			trace (list.toArray()); // 6,4,1,3,5,2,7

			// Inspection
			
			trace (list.first); // 6
			trace (list.last); // 7
			
			// Iterator

			var iterator : IIterator = list.iterator();
			trace (iterator is IIterator); // true
			trace (iterator is ICollectionIterator); // true
			trace (iterator is ILinkedListIterator); // true
			
			while (iterator.hasNext()) {
				trace (iterator.next()); // 6,4,1,3,5,2,7
			}

			// Linked list iterator

			var lli : ILinkedListIterator = list.iterator() as ILinkedListIterator;
			trace (lli.previousItem + " [" + lli.current + "] " + lli.nextItem);
			while (lli.hasNext()) {
				lli.next();
				trace (lli.previousItem + " [" + lli.current + "] " + lli.nextItem);
			}

			// undefined [undefined] 6
			// 6 [6] 4
			// 4 [4] 1
			// 1 [1] 3
			// 3 [3] 5
			// 5 [5] 2
			// 2 [2] 7
			// 7 [7] undefined

			// Remove

			list.removeFirst();
			list.removeFirst();
			list.removeLast();
			list.removeLast();
			trace (list.toArray()); // 1,3,5
		}
	}
}
