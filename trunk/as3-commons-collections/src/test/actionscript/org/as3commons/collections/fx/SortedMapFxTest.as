package org.as3commons.collections.fx {
	import org.as3commons.collections.SortedMapTest;
	import org.as3commons.collections.framework.ICollection;
	import org.as3commons.collections.mocks.SortedMapFxMock;
	import org.as3commons.collections.testhelpers.TestComparator;
	import org.as3commons.collections.units.fx.IMapFxTests;
	import org.as3commons.collections.units.fx.ISortOrderFxTests;

	/**
	 * @author jes 30.03.2010
	 */
	public class SortedMapFxTest extends SortedMapTest {

		/*
		 * AbstractCollectionTest
		 */

		override public function createCollection() : ICollection {
			return new SortedMapFxMock(new TestComparator());
		}

		/*
		 * Units
		 */

		/*
		 * MapFx tests
		 */

		public function test_map_fx() : void {
			new IMapFxTests(this).runAllTests();
		}

		/*
		 * OrderFx tests
		 */

		public function test_order_fx() : void {
			new ISortOrderFxTests(this).runAllTests();
		}

	}
}
