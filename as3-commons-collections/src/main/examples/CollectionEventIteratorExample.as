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
	import org.as3commons.collections.framework.IListIterator;
	import org.as3commons.collections.fx.ArrayListFx;
	import org.as3commons.collections.fx.events.CollectionEvent;
	import flash.display.Sprite;

	public class CollectionEventIteratorExample extends Sprite {

		public function CollectionEventIteratorExample() {
			var list : ArrayListFx = new ArrayListFx();
			list.array = [1, 2, 4, 5];
			list.addEventListener(CollectionEvent.COLLECTION_CHANGED, changedHandler);

			list.addAt(2, 3); // 1, 2, 3, 4, 5
			list.replaceAt(3, 6); // 1, 2, 3, 6, 5
			list.removeAt(4); // 1, 2, 3, 6
			list.reverse(); // 6, 3, 2, 1
		}
		
		private function changedHandler(event : CollectionEvent) : void {
			var iterator : IListIterator = event.iterator() as IListIterator;
			
			switch (event.kind) {
				case CollectionEvent.ITEM_ADDED: // 1 2 ^ 3 4 5
					trace (iterator.previousIndex); // 1
					trace (iterator.nextIndex); // 2
					trace (iterator.next()); // 3
					break;

				case CollectionEvent.ITEM_REPLACED: // 1 2 3 ^ 6 5
					trace (iterator.previousIndex); // 2
					trace (iterator.nextIndex); // 3
					trace (iterator.next()); // 6
					break;

				case CollectionEvent.ITEM_REMOVED: // 1 2 3 6 ^
					trace (iterator.previousIndex); // 3
					trace (iterator.nextIndex); // -1
					trace (iterator.next()); // undefined
					break;

				case CollectionEvent.RESET:
					trace (iterator); // null
					break;
			}
		}
	}
}
