package org.as3commons.collections.framework.core {
	import org.as3commons.collections.Set;
	import org.as3commons.collections.framework.ISetIterator;
	import org.as3commons.collections.iterators.ArrayIterator;

	/**
	 * Internal <code>Set</code> iterator implementation.
	 * 
	 * @author jes 01.04.2010
	 */
	public class SetIterator extends ArrayIterator implements ISetIterator {

		/**
		 * The set to enumerate.
		 */
		protected var _set : Set;

		/**
		 * SetIterator constructor.
		 * 
		 * @param theSet The set to enumerate.
		 */
		public function SetIterator(theSet : Set) {
			_set = theSet;
			super(_set.toArray());
		}
		
		/*
		 * ISetIterator
		 */
		
		/**
		 * @inheritDoc
		 */
		public function get previousItem() : * {
			return _array[previousIndex];
		}
		
		/**
		 * @inheritDoc
		 */
		public function get nextItem() : * {
			return _array[_next];
		}
	
		/*
		 * Protected
		 */

		/**
		 * @inheritDoc
		 */
		override protected function removeCurrent() : void {
			_set.remove(super.current);
			super.removeCurrent();
		}

	}
}
