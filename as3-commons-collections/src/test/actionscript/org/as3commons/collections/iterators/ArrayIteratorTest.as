package org.as3commons.collections.iterators {
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.mocks.ArrayIteratorMock;
	import org.as3commons.collections.testhelpers.AbstractIteratorTestCase;
	import org.as3commons.collections.units.iterators.IListIteratorTests;

	/**
	 * @author jes 19.03.2010
	 */
	public class ArrayIteratorTest extends AbstractIteratorTestCase {

		/*
		 * AbstractIteratorTest
		 */

		override public function createCollection() : * {
			return new Array();
		}

		override public function fillCollection(items : Array) : void {
			collection = items;
		}

		override public function getIterator(index : uint = 0) : IIterator {
			return new ArrayIteratorMock(collection, index);
		}

		override public function toArray() : Array {
			return collection;
		}

		/*
		 * Units
		 */

		/*
		 * CollectionIterator tests
		 */

		public function test_listIterator() : void {
			new IListIteratorTests(this).runAllTests();
		}

	}
}
