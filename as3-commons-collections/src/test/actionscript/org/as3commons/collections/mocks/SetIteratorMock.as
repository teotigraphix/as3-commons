package org.as3commons.collections.mocks {
	import org.as3commons.collections.Set;
	import org.as3commons.collections.framework.core.SetIterator;
	import org.as3commons.collections.units.iterators.ITestIteratorNextPreviousLookup;

	/**
	 * @author jes 01.04.2010
	 */
	public class SetIteratorMock extends SetIterator implements
		ITestIteratorNextPreviousLookup
	{
		public function SetIteratorMock(theSet : Set) {
			super(theSet);
		}

		public function get previousMock() : * {
			return previousItem;
		}
		
		public function get nextMock() : * {
			return nextItem;
		}

	}
}
