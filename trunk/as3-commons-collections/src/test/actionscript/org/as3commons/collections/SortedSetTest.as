package org.as3commons.collections {
	import org.as3commons.collections.framework.ICollection;
	import org.as3commons.collections.framework.ISortedSet;
	import org.as3commons.collections.mocks.SortedSetMock;
	import org.as3commons.collections.testhelpers.AbstractCollectionTestCase;
	import org.as3commons.collections.testhelpers.TestComparator;
	import org.as3commons.collections.units.ISetTests;
	import org.as3commons.collections.units.ISortOrderDuplicateEqualsTests;

	/**
	 * @author jes 30.03.2010
	 */
	public class SortedSetTest extends AbstractCollectionTestCase {

		/*
		 * AbstractCollectionTest
		 */

		override public function createCollection() : ICollection {
			return new SortedSetMock(new TestComparator());
		}

		override public function fillCollection(items : Array) : void {
			collection.clear();
			
			for each (var item : * in items) {
				ISortedSet(collection).add(item);
			}
		}

		/*
		 * Units
		 */

		/*
		 * Set tests
		 */

		public function test_set() : void {
			new ISetTests(this).runAllTests();
		}

		/*
		 * Order tests
		 */

		public function test_order() : void {
			new ISortOrderDuplicateEqualsTests(this).runAllTests();
		}

	}
}
