package org.as3commons.collections.testhelpers {
	import org.as3commons.collections.framework.IComparator;

	/**
	 * @author jes 22.03.2010
	 */
	public class NullComparator implements IComparator {
		public function compare(item1 : *, item2 : *) : int {
			return 0;
		}
	}
}
