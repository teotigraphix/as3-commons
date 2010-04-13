package org.as3commons.collections.units.iterators {
	import org.as3commons.collections.framework.ICollectionIterator;

	/**
	 * @author jes 01.04.2010
	 */
	public interface ITestIteratorNextPreviousLookup extends ICollectionIterator {
		
		function get previousMock() : *;
		
		function get nextMock() : *;
		
	}
}
