package org.as3commons.collections {
	import org.as3commons.collections.framework.ICollection;
	import org.as3commons.collections.framework.ISortedMap;
	import org.as3commons.collections.mocks.SortedMapMock;
	import org.as3commons.collections.testhelpers.AbstractCollectionTest;
	import org.as3commons.collections.testhelpers.TestComparator;
	import org.as3commons.collections.testhelpers.UniqueMapKey;
	import org.as3commons.collections.units.IMapTests;
	import org.as3commons.collections.units.ISortOrderDuplicatesTests;

	/**
	 * @author jes 30.03.2010
	 */
	public class SortedMapTest extends AbstractCollectionTest {

		/*
		 * AbstractCollectionTest
		 */

		override public function createCollection() : ICollection {
			return new SortedMapMock(new TestComparator());
		}

		override public function fillCollection(items : Array) : void {
			collection.clear();
			for each (var item : * in items) {
				ISortedMap(collection).add(UniqueMapKey.key, item);
			}
		}

		/*
		 * Units
		 */

		/*
		 * Map tests
		 */

		public function test_map() : void {
			new IMapTests(this).runAllTests();
		}

		/*
		 * Order tests
		 */

		public function test_order() : void {
			new ISortOrderDuplicatesTests(this).runAllTests();
		}

	}
}
