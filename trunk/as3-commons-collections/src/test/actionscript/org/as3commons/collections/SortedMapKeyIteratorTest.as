package org.as3commons.collections {
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.testhelpers.AbstractIteratorTestCase;
	import org.as3commons.collections.testhelpers.TestComparator;
	import org.as3commons.collections.units.iterators.IIteratorTests;

	/**
	 * @author jes 14.04.2010
	 */
	public class SortedMapKeyIteratorTest extends AbstractIteratorTestCase {

		/*
		 * AbstractIteratorTest
		 */

		override public function createCollection() : * {
			return new SortedMap(new TestComparator());
		}

		override public function fillCollection(items : Array) : void {
			SortedMap(collection).clear();
			for each (var item : * in items) {
				SortedMap(collection).add(item, item);
			}
		}

		override public function getIterator(index : uint = 0) : IIterator {
			return SortedMap(collection).keyIterator();
		}

		override public function toArray() : Array {
			return SortedMap(collection).keysToArray();
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
