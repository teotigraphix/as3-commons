package org.as3commons.collections.framework.core {
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.framework.ILinkedList;
	import org.as3commons.collections.framework.ILinkedListIterator;
	import org.as3commons.collections.mocks.LinkedListMock;
	import org.as3commons.collections.testhelpers.AbstractIteratorTest;
	import org.as3commons.collections.units.iterators.ICollectionIteratorTests;
	import org.as3commons.collections.units.iterators.IIteratorInsertionOrderTests;
	import org.as3commons.collections.units.iterators.IIteratorNextPreviousLookupTests;

	/**
	 * @author jes 19.03.2010
	 */
	public class LinkedListIteratorTest extends AbstractIteratorTest {

		/*
		 * AbstractIteratorTest
		 */

		override public function createCollection() : * {
			return new LinkedListMock();
		}

		override public function fillCollection(items : Array) : void {
			ILinkedList(collection).clear();
			
			for each (var item : * in items) {
				ILinkedList(collection).add(item);
			}
		}

		override public function getIterator(index : uint = 0) : IIterator {
			return ILinkedList(collection).iterator(index);
		}

		override public function toArray() : Array {
			return ILinkedList(collection).toArray();
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
		 * IIteratorInsertionOrderTests tests
		 */

		public function test_iteratorInsertionOrder() : void {
			new IIteratorInsertionOrderTests(this).runAllTests();
		}

		/*
		 * NextPreviousLookup tests
		 */

		public function test_nextPreviousLookup() : void {
			new IIteratorNextPreviousLookupTests(this).runAllTests();
		}

		/*
		 * ILinkedListIterator
		 */

		/*
		 * Initial state
		 */

		public function test_init() : void {
			assertTrue(getIterator() is ILinkedListIterator);
		}

	}
}
