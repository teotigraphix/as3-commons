package org.as3commons.collections.iterators {
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.framework.IRecursiveIterator;
	import org.as3commons.collections.testhelpers.AbstractSpecialIteratorTestCase;
	import org.as3commons.collections.units.iterators.IIteratorTests;
	import org.as3commons.collections.units.iterators.RecursiveIteratorTests;

	/**
	 * @author jes 19.03.2010
	 */
	public class RecursiveIteratorTest extends AbstractSpecialIteratorTestCase {

		/*
		 * AbstractIteratorTest
		 */

		override public function getIterator(index : uint = 0) : IIterator {
			return new RecursiveIterator(collection);
		}

		override public function getRecursiveIterator() : IRecursiveIterator {
			return new RecursiveIterator(collection);
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
		 * RecursiveIterator
		 */

		public function test_recursiveIterator() : void {
			new RecursiveIteratorTests(this).runAllTests();
		}

	}
}
