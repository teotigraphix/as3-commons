package org.as3commons.collections.fx {
	import org.as3commons.collections.SortedSetTest;
	import org.as3commons.collections.framework.ICollection;
	import org.as3commons.collections.mocks.SortedSetFxMock;
	import org.as3commons.collections.testhelpers.TestComparator;
	import org.as3commons.collections.units.fx.ICollectionFxTests;
	import org.as3commons.collections.units.fx.ISortOrderFxTests;

	/**
	 * @author jes 30.03.2010
	 */
	public class SortedSetFxTest extends SortedSetTest {

		/*
		 * AbstractCollectionTest
		 */

		override public function createCollection() : ICollection {
			return new SortedSetFxMock(new TestComparator());
		}

		/*
		 * Units
		 */

		/*
		 * Collection tests
		 */

		public function test_set_fx() : void {
			new ICollectionFxTests(this).runAllTests();
		}

		/*
		 * Order tests
		 */

		public function test_order_fx() : void {
			new ISortOrderFxTests(this).runAllTests();
		}

	}
}
