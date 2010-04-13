package org.as3commons.collections.units.iterators {
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.testhelpers.AbstractIteratorTest;
	import org.as3commons.collections.testhelpers.AbstractIteratorUnitTest;
	import org.as3commons.collections.testhelpers.TestItems;

	/**
	 * @author jes 18.03.2010
	 */
	public class IIteratorTests extends AbstractIteratorUnitTest {

		public function IIteratorTests(test : AbstractIteratorTest) {
			super(test);
		}

		/*
		 * Initial state
		 */

		public function test_init() : void {
			assertTrue(_test.getIterator() is IIterator);
		}
	
		public function test_init_withEmptyCollection() : void {
			var iterator : IIterator = _test.getIterator();
			assertFalse(iterator.hasNext());
			assertTrue(undefined === iterator.next());
		}
	
		/*
		 * Basic tests
		 */

		public function test_next() : void {
			_test.fillCollection(TestItems.itemArray(3));
			
			var iterator : IIterator = _test.getIterator();
			var items : Array = _test.toArray();

			iterator = _test.getIterator();

			assertTrue(iterator.hasNext());
			assertTrue(iterator.next() === items[0]);
	
			iterator.next();
	
			assertTrue(iterator.hasNext());
			assertTrue(iterator.next() === items[2]);
			
			assertFalse(iterator.hasNext());
			assertTrue(undefined === iterator.next());
		}

		/*
		 * Test null valued items
		 */

		public function test_null() : void {
			
			_test.fillCollection([null, TestItems.object1, TestItems.object2]);

			var iterator : IIterator = _test.getIterator();
			var items : Array = _test.toArray();

			assertTrue(iterator.hasNext());
			assertTrue(iterator.next() === items[0]);
	
			assertTrue(iterator.hasNext());
			assertTrue(iterator.next() === items[1]);

			assertTrue(iterator.hasNext());
			assertTrue(iterator.next() === items[2]);

		}

		/*
		 * Test all items returned
		 */

		public function test_returnsAllItemsAdded() : void {
			var items : Array = TestItems.itemArray(5);
			_test.fillCollection(items);
			
			var returnedItems : Array = new Array();
			
			var iterator : IIterator = _test.getIterator();
			while (iterator.hasNext()) {
				returnedItems.push(iterator.next());
			}
			
			assertTrue(_test.validateItems(returnedItems, items));
		}

	}
}
