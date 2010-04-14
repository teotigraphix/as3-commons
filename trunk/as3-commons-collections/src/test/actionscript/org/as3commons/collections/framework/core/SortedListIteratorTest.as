package org.as3commons.collections.framework.core {
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.framework.ISortedList;
	import org.as3commons.collections.mocks.SortedListMock;
	import org.as3commons.collections.testhelpers.AbstractIteratorTestCase;
	import org.as3commons.collections.testhelpers.TestComparator;
	import org.as3commons.collections.units.iterators.IListIteratorTests;

	/**
	 * @author jes 19.03.2010
	 */
	public class SortedListIteratorTest extends AbstractIteratorTestCase {

		/*
		 * AbstractIteratorTest
		 */

		override public function createCollection() : * {
			return new SortedListMock(new TestComparator());
		}

		override public function fillCollection(items : Array) : void {
			ISortedList(collection).clear();
			
			for each (var item : * in items) {
				ISortedList(collection).add(item);
			}
		}

		override public function getIterator(index : uint = 0) : IIterator {
			return SortedListMock(collection).iterator(index);
		}

		override public function toArray() : Array {
			return ISortedList(collection).toArray();
		}

		/*
		 * Units
		 */

		/*
		 * ListIterator tests
		 */

		public function test_listIterator() : void {
			new IListIteratorTests(this).runAllTests();
		}

	}
}
