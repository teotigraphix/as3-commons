package org.as3commons.collections.framework.core {
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.mocks.TreapMock;
	import org.as3commons.collections.testhelpers.AbstractIteratorTest;
	import org.as3commons.collections.testhelpers.TestComparator;
	import org.as3commons.collections.units.iterators.ICollectionIteratorTests;
	import org.as3commons.collections.units.iterators.IIteratorNextPreviousLookupTests;

	/**
	 * @author jes 30.03.2010
	 */
	public class TreapIteratorTest extends AbstractIteratorTest {

		/*
		 * AbstractIteratorTest
		 */

		override public function createCollection() : * {
			return new TreapMock(new TestComparator());
		}

		override public function fillCollection(items : Array) : void {
			collection.clear();
			
			for each (var item : * in items) {
				TreapMock(collection).add(item);
			}
		}

		override public function getIterator(index : uint = 0) : IIterator {
			return TreapMock(collection).iterator();
		}

		override public function toArray() : Array {
			return TreapMock(collection).toArray();
		}

		/*
		 * Units
		 */

		/*
		 * CollectionIterator tests
		 */

		public function test_collectionIterator() : void {
			new ICollectionIteratorTests(this).runAllTests();
		}

		/*
		 * NextPreviousLookup tests
		 */

		public function test_nextPreviousLookup() : void {
			new IIteratorNextPreviousLookupTests(this).runAllTests();
		}
	}
}
