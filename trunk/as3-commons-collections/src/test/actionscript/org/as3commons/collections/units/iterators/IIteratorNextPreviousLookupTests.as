package org.as3commons.collections.units.iterators {
	import org.as3commons.collections.testhelpers.AbstractIteratorTest;
	import org.as3commons.collections.testhelpers.AbstractIteratorUnitTest;
	import org.as3commons.collections.testhelpers.TestItems;

	/**
	 * @author jes 01.04.2010
	 */
	public class IIteratorNextPreviousLookupTests extends AbstractIteratorUnitTest {

		public function IIteratorNextPreviousLookupTests(test : AbstractIteratorTest) {
			super(test);
		}

		/*
		 * Initial state
		 */

		public function test_init() : void {
			assertTrue(_test.getIterator() is ITestIteratorNextPreviousLookup);
		}

		/*
		 * Test nextKey
		 */

		public function test_nextItem_previousItem() : void {
			_test.fillCollection(TestItems.itemArray(3));

			var iterator : ITestIteratorNextPreviousLookup = _test.getIterator() as ITestIteratorNextPreviousLookup;
			var items : Array = _test.allItems(iterator);

			assertTrue(undefined === iterator.current);

			assertTrue(undefined === iterator.previousMock);
			assertStrictlyEquals(items[0], iterator.nextMock);

			assertStrictlyEquals(items[0], iterator.next());
			assertStrictlyEquals(items[0], iterator.current);

			assertStrictlyEquals(items[0], iterator.previousMock);
			assertStrictlyEquals(items[1], iterator.nextMock);

			assertStrictlyEquals(items[1], iterator.next());
			assertStrictlyEquals(items[1], iterator.current);

			assertStrictlyEquals(items[1], iterator.previousMock);
			assertStrictlyEquals(items[2], iterator.nextMock);

			assertStrictlyEquals(items[2], iterator.next());
			assertStrictlyEquals(items[2], iterator.current);

			assertStrictlyEquals(items[2], iterator.previousMock);
			assertTrue(undefined === iterator.nextMock);

			assertTrue(undefined === iterator.next());
			assertTrue(undefined === iterator.current);

			assertStrictlyEquals(items[2], iterator.previousMock);
			assertTrue(undefined === iterator.nextMock);

			assertStrictlyEquals(items[2], iterator.previous());
			assertStrictlyEquals(items[2], iterator.current);

			assertStrictlyEquals(items[1], iterator.previousMock);
			assertStrictlyEquals(items[2], iterator.nextMock);

			assertStrictlyEquals(items[1], iterator.previous());
			assertStrictlyEquals(items[1], iterator.current);

			assertStrictlyEquals(items[0], iterator.previousMock);
			assertStrictlyEquals(items[1], iterator.nextMock);

			assertStrictlyEquals(items[0], iterator.previous());
			assertStrictlyEquals(items[0], iterator.current);

			assertTrue(undefined === iterator.previousMock);
			assertStrictlyEquals(items[0], iterator.nextMock);

			assertTrue(undefined === iterator.previous());
			assertTrue(undefined === iterator.current);

			assertTrue(undefined === iterator.previousMock);
			assertStrictlyEquals(items[0], iterator.nextMock);
		}

	}
}
