package org.as3commons.collections {
	import org.as3commons.collections.framework.ICollection;
	import org.as3commons.collections.mocks.TreapMock;
	import org.as3commons.collections.testhelpers.AbstractCollectionTestCase;
	import org.as3commons.collections.testhelpers.TestComparator;
	import org.as3commons.collections.units.ICollectionTests;
	import org.as3commons.collections.units.ISortOrderTests;

	/**
	 * @author jes 29.03.2010
	 */
	public class TreapTest extends AbstractCollectionTestCase {

		/*
		 * AbstractCollectionTest
		 */

		override public function createCollection() : ICollection {
			return new TreapMock(new TestComparator());
		}

		override public function fillCollection(items : Array) : void {
			collection.clear();
			
			for each (var item : * in items) {
				TreapMock(collection).add(item);
			}
		}

		/*
		 * Units
		 */

		/*
		 * ICollection tests
		 */

		public function test_collection() : void {
			new ICollectionTests(this).runAllTests();
		}

		/*
		 * Order tests
		 */

		public function test_order() : void {
			new ISortOrderTests(this).runAllTests();
		}

	}
}
