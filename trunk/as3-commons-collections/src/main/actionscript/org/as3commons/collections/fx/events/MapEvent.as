package org.as3commons.collections.fx.events {
	import org.as3commons.collections.framework.IMap;

	/**
	 * Bindable map event.
	 * 
	 * <p><strong>Features</strong></p>
	 * 
	 * <p>The <code>MapEvent</code> provides additionally to the base collection event:</p>
	 * 
	 * <ul>
	 * <li>Reference to the bindable map.<br />
	 * <code>map</code></li>
	 * <li>Key of the affected item in insertion or removal operations.<br />
	 * <code>key</code></li>
	 * <li>An <code>IMapIterator</code><br />
	 * <code>iterator()</code></li>
	 * </ul>
	 * 
	 * @author jes 29.03.2010
	 * @see CollectionEvent CollectionEvent - Description of the base collection event properties.
	 */
	public class MapEvent extends CollectionEvent {

		/**
		 * The bindable map.
		 */
		public var map : IMap;

		/**
		 * The key of the affected item.
		 * 
		 * <p>Only set for the event kinds <code>CollectionEvent.ITEM_ADDED</code>,
		 * <code>CollectionEvent.ITEM_REPLACED</code>, <code>CollectionEvent.ITEM_REMOVED</code>.</p>
		 * 
		 * <p><code>undefined</code> if the event kind is <code>CollectionEvent.RESET</code>.</p>
		 */
		public var key : *;

		/**
		 * MapEvent constructor.
		 * 
		 * @param theKind The event kind.
		 * @param theMap The map.
		 * @param theKey The key of the item added, removed or replaced.
		 * @param theItem The affected item in a singular operation.
		 */
		public function MapEvent(
			theKind : String,
			theMap : IMap,
			theKey : * = undefined,
			theItem : * = undefined
		) {
			kind = theKind;
			map = theMap;
			key = theKey;
			item = theItem;
			
			numItems = kind == RESET ? -1 : 1;
		}

	}
}
