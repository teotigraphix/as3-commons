package org.as3commons.collections.units {
	import org.as3commons.collections.framework.IInsertionOrder;

	/**
	 * @author jes 18.03.2010
	 */
	public interface ITestInsertionOrder extends IInsertionOrder, ITestOrder {

		function addFirstMock(item : *) : void;

		function addLastMock(item : *) : void;

	}
}
