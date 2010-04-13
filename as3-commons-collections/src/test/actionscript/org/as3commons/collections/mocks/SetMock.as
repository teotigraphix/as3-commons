package org.as3commons.collections.mocks {
	import org.as3commons.collections.Set;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.units.ITestCollection;

	/**
	 * @author jes 26.03.2010
	 */
	public class SetMock extends Set implements
		ITestCollection
	{
		public function SetMock() {
			super();
		}
		
		override public function iterator(cursor : * = undefined) : IIterator {
			return new SetIteratorMock(this);
		}

		public function addMock(item : *) : void {
			add(item);
		}
	}
}
