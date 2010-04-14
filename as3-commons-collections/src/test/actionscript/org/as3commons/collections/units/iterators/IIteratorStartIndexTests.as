package org.as3commons.collections.units.iterators {
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.testhelpers.AbstractIteratorTestCase;
	import org.as3commons.collections.testhelpers.AbstractIteratorUnitTestCase;
	import org.as3commons.collections.testhelpers.TestItems;

	/**
	 * @author jes 19.03.2010
	 */
	public class IIteratorStartIndexTests extends AbstractIteratorUnitTestCase {

		public function IIteratorStartIndexTests(test : AbstractIteratorTestCase) {
			super(test);
		}

		/*
		 * Test start index
		 */

		public function test_startIndex() : void {
			_test.fillCollection(TestItems.itemArray(6));
			
			var iterator : IIterator = _test.getIterator(2);
			
			assertTrue(iterator.hasNext());
			assertStrictlyEquals(TestItems.object3, iterator.next());
		}

		public function test_startIndex_wrong() : void {
			_test.fillCollection(TestItems.itemArray(6));
			
			var iterator : IIterator = _test.getIterator(12);
			
			assertFalse(iterator.hasNext());
		}

		public function test_startIndex_rightAfterLast() : void {
			_test.fillCollection(TestItems.itemArray(6));
			
			var iterator : IIterator = _test.getIterator(6);
			
			assertFalse(iterator.hasNext());
		}

		public function test_startIndex_atStart() : void {
			_test.fillCollection(TestItems.itemArray(6));
			
			var iterator : IIterator = _test.getIterator(0);
			
			assertTrue(iterator.hasNext());
			assertStrictlyEquals(TestItems.object1, iterator.next());
		}

		public function test_startIndex_atEnd() : void {
			_test.fillCollection(TestItems.itemArray(6));
			
			var iterator : IIterator = _test.getIterator(5);
			
			assertTrue(iterator.hasNext());
			assertStrictlyEquals(TestItems.object6, iterator.next());
		}

	}
}
