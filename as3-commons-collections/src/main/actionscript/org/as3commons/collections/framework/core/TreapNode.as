package org.as3commons.collections.framework.core {

	/**
	 * Treap node.
	 * 
	 * @author jes 18.04.2009
	 */
	public class TreapNode {
		
		/**
		 * The item.
		 */
		public var item : *;

		/**
		 * The parent item.
		 */
		public var parent : TreapNode;

		/**
		 * The left subtree.
		 */
		public var left : TreapNode;

		/**
		 * The right subtree.
		 */
		public var right : TreapNode;

		/**
		 * The node priority.
		 */
		public var priority : uint;
		
		/**
		 * Creates a new Treap node.
		 * 
		 * @param theItem The data of the node.
		 * @param theParent The parent node.
		 */
		public function TreapNode(theItem : *, theParent : TreapNode = null) {
			item = theItem;
			parent = theParent;
			priority = Math.random() * uint.MAX_VALUE;
		}

	}
}
