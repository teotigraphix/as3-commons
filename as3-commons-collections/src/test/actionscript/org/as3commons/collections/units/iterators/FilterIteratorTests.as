package org.as3commons.collections.units.iterators {
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.testhelpers.AbstractSpecialIteratorTestCase;
	import org.as3commons.collections.testhelpers.AbstractSpecialIteratorUnitTestCase;
	import org.as3commons.collections.testhelpers.TestItems;

	/**
	 * @author jes 19.03.2010
	 */
	public class FilterIteratorTests extends AbstractSpecialIteratorUnitTestCase {
		public function FilterIteratorTests(test : AbstractSpecialIteratorTestCase) {
			super(test);
		}

		/*
		 * Test next, has next
		 */

		public function test_next() : void {
			
			_specialIteratorTest.fillCollection(TestItems.itemArray(6));
			
			var iterator : IIterator = _specialIteratorTest.getFilterIterator();
			
			assertTrue(iterator.hasNext());
			assertStrictlyEquals(TestItems.object2, iterator.next());
			
			assertTrue(iterator.hasNext());
			assertStrictlyEquals(TestItems.object4, iterator.next());
			
			assertTrue(iterator.hasNext());
			assertStrictlyEquals(TestItems.object6, iterator.next());
			
			assertFalse(iterator.hasNext());
		}

		public function test_next_withoutHasNext() : void {
			
			_specialIteratorTest.fillCollection(TestItems.itemArray(6));
			
			var iterator : IIterator = _specialIteratorTest.getFilterIterator();
			
			assertStrictlyEquals(TestItems.object2, iterator.next());
			
			assertStrictlyEquals(TestItems.object4, iterator.next());
			
			assertStrictlyEquals(TestItems.object6, iterator.next());
			
			assertTrue(undefined === iterator.next());
		}

		public function test_next2() : void {
			
			_specialIteratorTest.fillCollection(TestItems.itemArray(7));
			
			var iterator : IIterator = _specialIteratorTest.getFilterIterator();
			
			assertTrue(iterator.hasNext());
			assertStrictlyEquals(TestItems.object2, iterator.next());
			
			assertTrue(iterator.hasNext());
			assertStrictlyEquals(TestItems.object4, iterator.next());
			
			assertTrue(iterator.hasNext());
			assertStrictlyEquals(TestItems.object6, iterator.next());
			
			assertFalse(iterator.hasNext());
		}

		public function test_next2_withoutHasNext() : void {
			
			_specialIteratorTest.fillCollection(TestItems.itemArray(6));
			
			var iterator : IIterator = _specialIteratorTest.getFilterIterator();
			
			assertStrictlyEquals(TestItems.object2, iterator.next());
			
			assertStrictlyEquals(TestItems.object4, iterator.next());
			
			assertStrictlyEquals(TestItems.object6, iterator.next());
			
			assertTrue(undefined === iterator.next());
		}

		public function test_next_withNoMatchingItems() : void {
			
			_specialIteratorTest.fillCollection(TestItems.itemArrayByIndices([1, 3, 5, 7, 9]));
			
			var iterator : IIterator = _specialIteratorTest.getFilterIterator();
			
			assertFalse(iterator.hasNext());
		}

	}
}
