package org.as3commons.collections.mocks {
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.fx.ArrayListFx;
	import org.as3commons.collections.units.ITestDuplicates;
	import org.as3commons.collections.units.ITestInsertionOrder;

	/**
	 * @author jes 19.03.2010
	 */
	public class ArrayListFxMock extends ArrayListFx implements
		ITestInsertionOrder,
		ITestDuplicates
	{

		override public function iterator(cursor : * = undefined) : IIterator {
			var index : uint = cursor is uint ? cursor : 0;
			return new ArrayListIteratorMock(this, index);
		}

		public function addMock(item : *) : void {
			add(item);
		}

		public function addFirstMock(item : *) : void {
			addFirst(item);
		}
		
		public function addLastMock(item : *) : void {
			addLast(item);
		}
		
	}
}
