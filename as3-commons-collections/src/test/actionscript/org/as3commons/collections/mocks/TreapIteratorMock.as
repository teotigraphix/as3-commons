package org.as3commons.collections.mocks {
	import org.as3commons.collections.Treap;
	import org.as3commons.collections.framework.core.TreapIterator;
	import org.as3commons.collections.framework.core.TreapNode;
	import org.as3commons.collections.units.iterators.ITestIteratorNextPreviousLookup;

	/**
	 * @author jes 01.04.2010
	 */
	public class TreapIteratorMock extends TreapIterator implements
		ITestIteratorNextPreviousLookup
	{
		public function TreapIteratorMock(treap : Treap, node : TreapNode) {
			super(treap, node);
		}

		public function get previousMock() : * {
			return previousItem;
		}
		
		public function get nextMock() : * {
			return nextItem;
		}

	}
}
