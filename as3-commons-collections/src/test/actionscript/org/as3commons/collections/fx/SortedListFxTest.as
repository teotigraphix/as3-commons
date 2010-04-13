package org.as3commons.collections.fx {
	import org.as3commons.collections.SortedListTest;
	import org.as3commons.collections.framework.ICollection;
	import org.as3commons.collections.mocks.SortedListFxMock;
	import org.as3commons.collections.testhelpers.TestComparator;
	import org.as3commons.collections.units.fx.IListFxTests;

	/**
	 * @author jes 22.03.2010
	 */
	public class SortedListFxTest extends SortedListTest {

		/*
		 * AbstractCollectionTest
		 */

		override public function createCollection() : ICollection {
			return new SortedListFxMock(new TestComparator());
		}

		/*
		 * Units
		 */

		/*
		 * ListFx
		 */

		public function test_list_fx() : void {
			new IListFxTests(this).runAllTests();
		}

	}
}
