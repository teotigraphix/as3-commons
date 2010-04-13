package org.as3commons.collections.iterators {
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.testhelpers.AbstractSpecialIteratorTest;
	import org.as3commons.collections.units.iterators.FilterIteratorTests;
	import org.as3commons.collections.units.iterators.IIteratorTests;

	/**
	 * @author jes 19.03.2010
	 */
	public class FilterIteratorTest extends AbstractSpecialIteratorTest {

		/*
		 * AbstractIteratorTest
		 */

		override public function getIterator(index : uint = 0) : IIterator {
			return new FilterIterator(collection, null);
		}

		override public function getFilterIterator() : IIterator {
			return new FilterIterator(collection, filter);
		}

		/*
		 * Units
		 */

		/*
		 * Iterator tests
		 */

		public function test_iterator() : void {
			new IIteratorTests(this).runAllTests();
		}

		/*
		 * FilterIterator tests
		 */

		public function test_filterIterator() : void {
			new FilterIteratorTests(this).runAllTests();
		}

	}
}
