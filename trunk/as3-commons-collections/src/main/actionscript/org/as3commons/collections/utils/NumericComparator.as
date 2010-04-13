package org.as3commons.collections.utils {
	import org.as3commons.collections.framework.IComparator;

	/**
	 * Numeric comparator.
	 * 
	 * <p>The succession order may be specified in a constructor parameter.</p>
	 *    
	 * @author jes 13.03.2009
	 * @see org.as3commons.collections.framework.IComparator IComparator interface - Description of the comparator features.
	 */
	public class NumericComparator implements IComparator {
		
		/**
		 * Constant defining ascending order (default).
		 */
		public static const ORDER_ASC : String = "asc";

		/**
		 * Constant defining descending order.
		 */
		public static const ORDER_DESC : String = "desc";
		
		/**
		 * Sort order.
		 */
		protected var _order : String;
		
		/**
		 * NumericComparator constructor.
		 * 
		 * @param order The order of items. <code>NumericComparator.ORDER_ASC</code> (default)
		 * or <code>NumericComparator.ORDER_DESC</code>.
		 */
		public function NumericComparator(order : String = ORDER_ASC) {
			_order = order;
		}

		/**
		 * Compares two numbers.
		 * 
		 * @param item1 The first number.
		 * @param item1 The second number.
		 * @return <code>-1</code> if the first number is lesser, <code>1</code> if greater and
		 * <code>0</code> if both are equal.
		 * @throws UncomparableType if either of the items is not a number.
		 */
		public function compare(item1 : *, item2 : *) : int {
			
			if (isNaN(item1)) throw new UncomparableType(Number, item1);
			if (isNaN(item2)) throw new UncomparableType(Number, item2);
			
			var n1 : Number = _order == ORDER_ASC ? item1 : item2;
			var n2 : Number = _order == ORDER_ASC ? item2 : item1;
			
			if (n1 < n2) return -1;
			else if (n1 > n2) return 1;
			else return 0;
		}

	}
}
