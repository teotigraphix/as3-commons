package org.as3commons.collections.framework.core {

	/**
	 * Linked map node.
	 * 
	 * @author jes 20.03.2009
	 */
	public class LinkedMapNode extends LinkedNode {
		
		/**
		 * The key.
		 */
		public var key : *;

		/**
		 * Creates a new linked map node.
		 * 
		 * @param theKey The key of the data of the node.
		 * @param theItem The data of the node.
		 */
		public function LinkedMapNode(theKey : *, theItem : *) {
			key = theKey;
			super(theItem);
		}
	}
}
