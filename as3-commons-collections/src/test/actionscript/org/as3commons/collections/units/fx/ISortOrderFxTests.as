package org.as3commons.collections.units.fx {
	import org.as3commons.collections.framework.ICollectionFx;
	import org.as3commons.collections.framework.ICollectionIterator;
	import org.as3commons.collections.fx.events.CollectionEvent;
	import org.as3commons.collections.testhelpers.AbstractCollectionTest;
	import org.as3commons.collections.testhelpers.CollectionEventListener;
	import org.as3commons.collections.testhelpers.TestItems;
	import org.as3commons.collections.units.ITestSortOrder;

	/**
	 * @author jes 22.03.2010
	 */
	public class ISortOrderFxTests extends IOrderBaseFxTests {

		public function ISortOrderFxTests(test : AbstractCollectionTest) {
			super(test);
		}
		
		private function get _sortOrder() : ITestSortOrder {
			return _test.collection as ITestSortOrder;
		}

		/*
		 * Initial state
		 */

		public function test_init_sortOrder() : void {
			assertTrue(_test.collection is ITestSortOrder);
			assertTrue(_test.collection is ICollectionFx);
		}

		/*
		 * Test add
		 */
		
		public function test_add() : void {
			var listener : CollectionEventListener = new CollectionEventListener(_sortOrder);
			
			assertFalse(listener.eventReceived);
			_sortOrder.addMock(TestItems.object2);
			assertTrue(listener.eventReceived);
			assertEquals(1, listener.numEvents);
			event = listener.event;
			assertEquals(CollectionEvent.ITEM_ADDED, event.kind);
			assertStrictlyEquals(TestItems.object2, event.item);
			assertEquals(1, event.numItems);
			assertTrue(event.iterator() is ICollectionIterator);
			assertStrictlyEquals(TestItems.object2, event.iterator().next());
			assertTrue(listener.validateSize(1));

			assertFalse(listener.eventReceived);
			_sortOrder.addMock(TestItems.object1);
			assertTrue(listener.eventReceived);
			assertEquals(1, listener.numEvents);
			var event : CollectionEvent = listener.event;
			assertEquals(CollectionEvent.ITEM_ADDED, event.kind);
			assertStrictlyEquals(TestItems.object1, event.item);
			assertEquals(1, event.numItems);
			assertTrue(event.iterator() is ICollectionIterator);
			assertStrictlyEquals(TestItems.object1, event.iterator().next());
			assertTrue(listener.validateSize(2));

		}

	}
}
