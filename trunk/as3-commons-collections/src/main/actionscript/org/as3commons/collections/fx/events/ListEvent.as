package org.as3commons.collections.fx.events {
	import org.as3commons.collections.framework.ICollectionIterator;
	import org.as3commons.collections.framework.IList;

	/**
	 * Bindable list event.
	 * 
	 * <p><strong>Features</strong></p>
	 * 
	 * <p>The <code>ListEvent</code> provides additionally to the base collection event:</p>
	 * 
	 * <ul>
	 * <li>Reference to the bindable list.<br />
	 * <code>list</code></li>
	 * <li>Index of the affected item or items in insertion or removal operations.<br />
	 * <code>index</code></li>
	 * <li>An <code>IListIterator</code><br />
	 * <code>iterator()</code></li>
	 * </ul>
	 * 
	 * @author jes 01.03.2010
	 * @see CollectionEvent CollectionEvent - Description of the base collection event properties.
	 */
	public class ListEvent extends CollectionEvent {
		
		/**
		 * The bindable list.
		 */
		public var list : IList;

		/**
		 * The index where the modification occurred.
		 * 
		 * <p>Only set for the event kinds <code>CollectionEvent.ITEM_ADDED</code>,
		 * <code>CollectionEvent.ITEM_REPLACED</code>, <code>CollectionEvent.ITEM_REMOVED</code>.</p>
		 * 
		 * <p><code>-1</code> if the event kind is <code>CollectionEvent.RESET</code>.</p>
		 */
		public var index : int;

		/**
		 * ArrayListEvent constructor.
		 * 
		 * @param theKind The event kind.
		 * @param theList The list.
		 * @param theIndex The position of modification.
		 * @param theNumItems The number of affected items.
		 * @param theItem The affected item in a singular operation.
		 * @param theItems The affected items in a bulk operation.
		 */
		public function ListEvent(
			theKind : String,
			theList : IList,
			theIndex : int = -1,
			theNumItems : int = -1,
			theItem : * = undefined,
			theItems : Array = undefined
		) {
			kind = theKind;
			list = theList;
			index = theIndex;
			numItems = theNumItems;
			item = theItem;
			items = theItems;
		}

		/**
		 * @inheritDoc
		 */
		override public function iterator() : ICollectionIterator {
			if (kind == RESET) return null;
			return list.iterator(index) as ICollectionIterator;
		}
	}
}
