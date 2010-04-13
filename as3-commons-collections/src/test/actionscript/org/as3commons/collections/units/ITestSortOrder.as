package org.as3commons.collections.units {
	import org.as3commons.collections.framework.ISortOrder;

	/**
	 * @author jes 19.03.2010
	 */
	public interface ITestSortOrder extends ISortOrder, ITestOrder {
		
		function lesser(item : *) : *;

		function higher(item : *) : *;

		function equalItems(item : *) : Array;

	}
}
