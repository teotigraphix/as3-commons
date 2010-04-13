package org.as3commons.collections.framework.core {

	/**
	 * Sorted map node.
	 * 
	 * @author jes 18.04.2009
	 */
	public class SortedMapNode extends SortedNode {
		
		/**
		 * The key.
		 */
		public var key : *;

		/**
		 * SortedMapNode constructor.
		 * 
		 * @param theKey The key of the data of the node.
		 * @param theItem The data of the node.
		 */
		public function SortedMapNode(theKey : *, theItem : *) {
			super(theItem);

			key = theKey;
		}

	}
}
