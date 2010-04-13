package org.as3commons.collections.framework.core {

	/**
	 * Sorted node.
	 * 
	 * @author jes 18.04.2009
	 */
	public class SortedNode {
		
		/**
		 * The item.
		 */
		public var item : *;

		/**
		 * The parent item.
		 */
		public var parent : SortedNode;

		/**
		 * The left subtree.
		 */
		public var left : SortedNode;

		/**
		 * The right subtree.
		 */
		public var right : SortedNode;

		/**
		 * The node priority.
		 */
		public var priority : uint;

		/**
		 * The node order.
		 * 
		 * <p>Since a sorted collection may contain multiple equal items, the
		 * <code>order</code> is used to compare to items.</p>
		 */
		public var order : uint;
		
		/**
		 * Node count.
		 */
		private static var _order : uint = 0; 
		
		/**
		 * SortedNode constructor.
		 * 
		 * @param theItem The data of the node.
		 */
		public function SortedNode(theItem : *) {
			item = theItem;
			priority = Math.random() * uint.MAX_VALUE;
			order = ++_order;
		}

	}
}
