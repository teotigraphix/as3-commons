package org.as3commons.collections.framework.core {

	/**
	 * Linked node.
	 * 
	 * @author jes 13.03.2009
	 */
	public class LinkedNode {
		
		/**
		 * The node's data.
		 */
		public var item : *;

		/**
		 * The predecessor.
		 */
		public var left : LinkedNode;

		/**
		 * The successor.
		 */
		public var right : LinkedNode;

		/**
		 * LinkedNode constructor.
		 * 
		 * @param theItem The data of the node.
		 */
		public function LinkedNode(theItem : *) {
			item = theItem;
		}
	}
}
