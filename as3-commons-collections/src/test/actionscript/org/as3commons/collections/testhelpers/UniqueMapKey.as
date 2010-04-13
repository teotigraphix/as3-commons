package org.as3commons.collections.testhelpers {

	/**
	 * @author jes 30.03.2010
	 */
	public class UniqueMapKey {
		
		private static var _count : uint = 0;
		
		public static function get key() : uint {
			return ++_count;
		}
	}
}
