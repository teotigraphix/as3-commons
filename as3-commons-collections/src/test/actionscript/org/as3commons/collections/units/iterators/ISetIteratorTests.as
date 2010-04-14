package org.as3commons.collections.units.iterators {
	import org.as3commons.collections.framework.ISetIterator;
	import org.as3commons.collections.testhelpers.AbstractIteratorTestCase;
	import org.as3commons.collections.units.iterators.ICollectionIteratorTests;

	/**
	 * @author jes 01.04.2010
	 */
	public class ISetIteratorTests extends ICollectionIteratorTests {

		public function ISetIteratorTests(test : AbstractIteratorTestCase) {
			super(test);
		}

		/*
		 * Units
		 */

		/*
		 * NextPreviousLookup tests
		 */

		public function test_nextPreviousLookup() : void {
			new IIteratorNextPreviousLookupTests(_test).runAllTests();
		}

		/*
		 * ISetIterator
		 */

		/*
		 * Initial state
		 */

		public function test_init_listIterator() : void {
			assertTrue(_test.getIterator() is ISetIterator);
		}

	}
}
