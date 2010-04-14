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
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.iterators.FilterIterator;
	import flash.display.Sprite;

	public class FilterIteratorExample extends Sprite {

		public function FilterIteratorExample() {
			var list : ArrayList = new ArrayList();
			var iterator : IIterator;

			list.array = [1, 2, 3, 4, 5, 6];
			iterator = new FilterIterator(list, evenFilter);
			while (iterator.hasNext()) {
				trace (iterator.next()); // 2, 4, 6
			}
		}

		private function evenFilter(item : *) : Boolean {
			// lets pass only even numbers
			return item % 2 == 0;
		}
	}
}
