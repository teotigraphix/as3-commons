package org.as3commons.collections.fx {
	import org.as3commons.collections.MapTest;
	import org.as3commons.collections.framework.ICollection;
	import org.as3commons.collections.mocks.MapFxMock;
	import org.as3commons.collections.units.fx.IMapFxTests;

	/**
	 * @author jes 29.03.2010
	 */
	public class MapFxTest extends MapTest {

		/*
		 * AbstractCollectionTest
		 */

		override public function createCollection() : ICollection {
			return new MapFxMock();
		}

		/*
		 * Units
		 */

		/*
		 * MapFx
		 */

		public function test_map_fx() : void {
			new IMapFxTests(this).runAllTests();
		}

	}
}
