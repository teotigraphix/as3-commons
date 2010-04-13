package org.as3commons.collections.fx.events {
	import org.as3commons.collections.framework.ISet;

	/**
	 * Bindable set event.
	 * 
	 * <p><strong>Features</strong></p>
	 * 
	 * <p>The <code>SetEvent</code> provides additionally to the base collection event:</p>
	 * 
	 * <ul>
	 * <li>Reference to the bindable set.<br />
	 * <code>set</code></li>
	 * <li>An <code>ISetIterator</code><br />
	 * <code>iterator()</code></li>	 * </ul>
	 * 
	 * @author jes 29.03.2010
	 * @see CollectionEvent CollectionEvent - Description of the base collection event properties.
	 */
	public class SetEvent extends CollectionEvent {

		/**
		 * The bindable set.
		 */
		public var set : ISet;

		/**
		 * SetEvent constructor.
		 * 
		 * @param theKind The event kind.
		 * @param theSet The set.
		 * @param theItem The affected item in a singular operation.
		 */
		public function SetEvent(
			theKind : String,
			theSet : ISet,
			theItem : * = undefined
		) {
			kind = theKind;
			set = theSet;
			item = theItem;
			
			numItems = kind == RESET ? -1 : 1;
		}

	}
}
