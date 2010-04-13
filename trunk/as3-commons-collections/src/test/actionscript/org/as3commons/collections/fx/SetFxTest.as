package org.as3commons.collections.fx {
	import org.as3commons.collections.SetTest;
	import org.as3commons.collections.framework.ICollection;
	import org.as3commons.collections.mocks.SetFxMock;
	import org.as3commons.collections.units.fx.ICollectionFxTests;

	/**
	 * @author jes 26.03.2010
	 */
	public class SetFxTest extends SetTest {

		/*
		 * AbstractCollectionTest
		 */

		override public function createCollection() : ICollection {
			return new SetFxMock();
		}

		/*
		 * Units
		 */

		/*
		 * CollectionFx tests
		 */

		public function test_collection_fx() : void {
			new ICollectionFxTests(this).runAllTests();
		}

	}
}
