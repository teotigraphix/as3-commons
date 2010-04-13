package org.as3commons.collections {
	import org.as3commons.collections.framework.ICollection;
	import org.as3commons.collections.framework.ISet;
	import org.as3commons.collections.mocks.SetMock;
	import org.as3commons.collections.testhelpers.AbstractCollectionTest;
	import org.as3commons.collections.units.ISetTests;

	/**
	 * @author jes 26.03.2010
	 */
	public class SetTest extends AbstractCollectionTest {

		/*
		 * AbstractCollectionTest
		 */

		override public function createCollection() : ICollection {
			return new SetMock();
		}

		override public function fillCollection(items : Array) : void {
			collection.clear();
			for each (var item : * in items) {
				ISet(collection).add(item);
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

	}
}
