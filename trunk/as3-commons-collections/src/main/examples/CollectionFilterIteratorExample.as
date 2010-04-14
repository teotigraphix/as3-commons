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
	import org.as3commons.collections.ArrayList;
	import org.as3commons.collections.framework.ICollectionIterator;
	import org.as3commons.collections.iterators.CollectionFilterIterator;
	import flash.display.Sprite;

	public class CollectionFilterIteratorExample extends Sprite {

		public function CollectionFilterIteratorExample() {
			var list : ArrayList = new ArrayList();
			var iterator : ICollectionIterator;

			// ^ = cursor, [n] = current
			
			// Navigation

			list.array = [1, 2, 3, 4, 5, 6];
			iterator = new CollectionFilterIterator(list, evenFilter);
			
			                       //  ^  1  2  3  4  5  6
			iterator.next();       //  1 [2] ^  3  4  5  6
			iterator.next();       //  1  2  3 [4] ^  5  6
			iterator.next();       //  1  2  3  4  5 [6] ^
			iterator.next();       //  1  2  3  4  5  6  ^
			iterator.previous();   //  1  2  3  4  5  ^ [6]
			iterator.previous();   //  1  2  3  ^ [4] 5  6
			iterator.start();      //  ^  1  2  3  4  5  6
			iterator.end();        //  1  2  3  4  5  6  ^
			
			// Remove

			iterator = new CollectionFilterIterator(list, evenFilter);
			
			                       //  ^  1  2  3  4  5  6
			iterator.next();       //  1 [2] ^  3  4  5  6
			iterator.next();       //  1  2  3 [4] ^  5  6
			iterator.remove();     //  1  2  3  ^  5  6
			iterator.next();       //  1  2  3  5 [6] ^
			iterator.remove();     //  1  2  3  5  ^
			iterator.previous();   //  1  ^ [2] 3  5
			iterator.remove();     //  1  ^  3  5
			iterator.previous();   //  ^  1  3  5
			iterator.next();       //  1  3  5  ^
			
			// Remove during iteration

			list.array = [1, 2, 3, 4, 5, 6];
			iterator = new CollectionFilterIterator(list, evenFilter);
			var item : *;
			while (iterator.hasNext()) {
				item = iterator.next();
				trace (item); // 2, 4, 6
				if (item == 2) iterator.remove();
				if (item == 6) iterator.remove();
			}
			trace (list.toArray()); // 1,3,4,5

			// Reverse iteration

			list.array = [1, 2, 3, 4, 5, 6];
			iterator = new CollectionFilterIterator(list, evenFilter);
			iterator.end();
			while (iterator.hasPrevious()) {
				trace (iterator.previous()); // 6, 4, 2
			}
		}
		
		private function evenFilter(item : *) : Boolean {
			// lets pass only even numbers
			return item % 2 == 0;
		}
	}
}
