package org.as3commons.collections.testhelpers {
	import flexunit.framework.TestCase;

	import org.as3commons.collections.framework.ICollectionIterator;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.framework.IMapIterator;
	import org.as3commons.collections.units.ITestOrder;
	import org.as3commons.collections.units.ITestSortOrder;
	import org.as3commons.collections.utils.ArrayUtils;

	/**
	 * @author jes 18.03.2010
	 */
	public class AbstractIteratorTestCase extends TestCase {

		/*
		 * Test to override
		 */

		public function fillCollection(items : Array) : void {
		}

		public function createCollection() : * {
			return null;
		}

		public function getIterator(index : uint = 0) : IIterator {
			return null;
		}

		public function toArray() : Array {
			return null;
		}


		/*
		 * Test neutralisation
		 */

		public var collection : *;
		
		override public function setUp() : void {
			TestItems.init();
			collection = createCollection();
		}

		override public function tearDown() : void {
			TestItems.cleanUp();
		}

		/*
		 * Test public interface
		 */

		public function allItems(iterator : ICollectionIterator) : Array {
			var items : Array = new Array();
			while (iterator.hasNext()) {
				items.push(iterator.next());
			}
			iterator.start();
			return items;
		}

		public function allKeys(iterator : IMapIterator) : Array {
			var keys : Array = new Array();
			while (iterator.hasNext()) {
				iterator.next();
				keys.push(iterator.key);
			}
			iterator.start();
			return keys;
		}

		public function validateItems(expectedItems : Array, items : Array = null) : Boolean {
			if (!items) items = toArray();
			
			if (collection is ITestSortOrder) {
				ArrayUtils.mergeSort(expectedItems, new TestComparator());
				return ArrayUtils.arraysEqual(expectedItems, items);

			} else if (collection is ITestOrder) {
				return ArrayUtils.arraysEqual(expectedItems, items);

			} else {
				return ArrayUtils.arraysMatch(expectedItems, items);
			}
		}

		public function validateTestItems(expectedItems : Array, items : Array = null) : Boolean {
			if (!items) items = toArray();
			
			if (collection is ITestSortOrder) {
				expectedItems.sort(new TestComparator().compare);
				return TestItems.itemsEqual(expectedItems, items);

			} else if (collection is ITestOrder) {
				return TestItems.itemsEqual(expectedItems, items);

			} else {
				return TestItems.itemsMatch(expectedItems, items);
			}
		}

	}
}
