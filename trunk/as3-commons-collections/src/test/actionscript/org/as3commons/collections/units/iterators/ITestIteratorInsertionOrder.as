package org.as3commons.collections.units.iterators {
	import org.as3commons.collections.framework.ICollectionIterator;

	/**
	 * @author jes 22.03.2010
	 */
	public interface ITestIteratorInsertionOrder extends ICollectionIterator {

		function addBeforeMock(item : *) : Boolean;

		function addAfterMock(item : *) : Boolean;

		function replace(item : *) : Boolean;

	}
}
