package org.as3commons.collections {
	import org.as3commons.collections.framework.ICollection;
	import org.as3commons.collections.framework.ILinkedList;
	import org.as3commons.collections.mocks.LinkedListMock;
	import org.as3commons.collections.testhelpers.AbstractCollectionTest;
	import org.as3commons.collections.units.ICollectionTests;
	import org.as3commons.collections.units.IDuplicatesTests;
	import org.as3commons.collections.units.IInsertionOrderDuplicatesTests;

	/**
	 * @author jes 25.03.2010
	 */
	public class LinkedListTest extends AbstractCollectionTest {

		/*
		 * AbstractCollectionTest
		 */

		override public function createCollection() : ICollection {
			return new LinkedListMock();
		}

		override public function fillCollection(items : Array) : void {
			collection.clear();
			
			for each (var item : * in items) {
				ILinkedList(collection).add(item);
			}
		}

		private function get _linkedList() : ILinkedList {
			return collection as ILinkedList;
		}
		
		/*
		 * Units
		 */

		/*
		 * Collection tests
		 */

		public function test_collection() : void {
			new ICollectionTests(this).runAllTests();
		}

		/*
		 * Duplicates tests
		 */

		public function test_duplicates() : void {
			new IDuplicatesTests(this).runAllTests();
		}

		/*
		 * Order tests
		 */

		public function test_order() : void {
			new IInsertionOrderDuplicatesTests(this).runAllTests();
		}

		/*
		 * ILinkedList
		 */

		/*
		 * Initial state
		 */

		public function test_init() : void {
			assertTrue(_linkedList is ILinkedList);
		}

	}
}
