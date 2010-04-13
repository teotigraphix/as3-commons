package org.as3commons.collections.units.iterators {
	import org.as3commons.collections.framework.ICollectionIterator;
	import org.as3commons.collections.testhelpers.AbstractIteratorTest;
	import org.as3commons.collections.testhelpers.TestItems;

	/**
	 * @author jes 19.03.2010
	 */
	public class ICollectionIteratorStartIndexTests extends IIteratorStartIndexTests {

		public function ICollectionIteratorStartIndexTests(test : AbstractIteratorTest) {
			super(test);
		}

		/*
		 * Test start index
		 */

		public function test_startIndex_collectionIterator() : void {
			_test.fillCollection(TestItems.itemArray(6));
			
			var iterator : ICollectionIterator = _test.getIterator(2) as ICollectionIterator;
			
			assertTrue(iterator.hasNext());
			assertTrue(iterator.hasPrevious());
			assertStrictlyEquals(TestItems.object3, iterator.next());
		}

		public function test_startIndex2() : void {
			_test.fillCollection(TestItems.itemArray(6));
			
			var iterator : ICollectionIterator = _test.getIterator(2) as ICollectionIterator;
			
			assertTrue(iterator.hasNext());
			assertTrue(iterator.hasPrevious());
			assertStrictlyEquals(TestItems.object2, iterator.previous());
		}

		public function test_startIndex_wrong_collectionIterator() : void {
			_test.fillCollection(TestItems.itemArray(6));
			
			var iterator : ICollectionIterator = _test.getIterator(12) as ICollectionIterator;
			
			assertTrue(iterator.hasPrevious());
			assertFalse(iterator.hasNext());
			assertStrictlyEquals(TestItems.object6, iterator.previous());
		}

		public function test_startIndex_rightAfterLast_collectionIterator() : void {
			_test.fillCollection(TestItems.itemArray(6));
			
			var iterator : ICollectionIterator = _test.getIterator(6) as ICollectionIterator;
			
			assertTrue(iterator.hasPrevious());
			assertFalse(iterator.hasNext());
			assertStrictlyEquals(TestItems.object6, iterator.previous());
		}

		public function test_startIndex_atStart_collectionIterator() : void {
			_test.fillCollection(TestItems.itemArray(6));
			
			var iterator : ICollectionIterator = _test.getIterator(0) as ICollectionIterator;
			
			assertFalse(iterator.hasPrevious());
			assertTrue(iterator.hasNext());
			assertStrictlyEquals(TestItems.object1, iterator.next());
		}

		public function test_startIndex_atEnd_collectionIterator() : void {
			_test.fillCollection(TestItems.itemArray(6));
			
			var iterator : ICollectionIterator = _test.getIterator(5) as ICollectionIterator;
			
			assertTrue(iterator.hasPrevious());
			assertTrue(iterator.hasNext());
			assertStrictlyEquals(TestItems.object6, iterator.next());
		}

		public function test_startIndex_atEnd2() : void {
			_test.fillCollection(TestItems.itemArray(6));
			
			var iterator : ICollectionIterator = _test.getIterator(5) as ICollectionIterator;
			
			assertTrue(iterator.hasPrevious());
			assertTrue(iterator.hasNext());
			assertStrictlyEquals(TestItems.object5, iterator.previous());
		}

	}
}
