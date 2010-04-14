package org.as3commons.collections {
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.testhelpers.AbstractIteratorTest;
	import org.as3commons.collections.units.iterators.IIteratorTests;

	/**
	 * @author jes 14.04.2010
	 */
	public class MapKeyIteratorTest extends AbstractIteratorTest {

		/*
		 * AbstractIteratorTest
		 */

		override public function createCollection() : * {
			return new Map();
		}

		override public function fillCollection(items : Array) : void {
			Map(collection).clear();
			for each (var item : * in items) {
				Map(collection).add(item, item);
			}
		}

		override public function getIterator(index : uint = 0) : IIterator {
			return Map(collection).keyIterator();
		}

		override public function toArray() : Array {
			return Map(collection).keysToArray();
		}

		/*
		 * Units
		 */

		/*
		 * IIterator tests
		 */

		public function test_iterator() : void {
			new IIteratorTests(this).runAllTests();
		}

	}
}
