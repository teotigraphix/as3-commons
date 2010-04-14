package org.as3commons.collections {
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.testhelpers.AbstractIteratorTest;
	import org.as3commons.collections.units.iterators.IIteratorTests;

	/**
	 * @author jes 14.04.2010
	 */
	public class LinkedMapKeyIteratorTest extends AbstractIteratorTest {

		/*
		 * AbstractIteratorTest
		 */

		override public function createCollection() : * {
			return new LinkedMap();
		}

		override public function fillCollection(items : Array) : void {
			LinkedMap(collection).clear();
			for each (var item : * in items) {
				LinkedMap(collection).add(item, item);
			}
		}

		override public function getIterator(index : uint = 0) : IIterator {
			return LinkedMap(collection).keyIterator();
		}

		override public function toArray() : Array {
			return LinkedMap(collection).keysToArray();
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
