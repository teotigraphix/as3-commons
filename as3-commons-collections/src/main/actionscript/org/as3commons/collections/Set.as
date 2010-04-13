package org.as3commons.collections {
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.framework.ISet;
	import org.as3commons.collections.framework.core.SetIterator;

	import flash.utils.Dictionary;

	/**
	 * Basic set implementation.
	 * 
	 * <p><strong>Description</strong></p>
	 * 
	 * <p>The <code>Set</code> maintains a dictionary as its source.</p>
	 * 
	 * <p><strong>Runtime of operations</strong></p>
	 * 
	 * <ul>
	 * <li>Adding of items - constant runtime O(1).<br />
	 * <code>add()</code></li>
	 * <li>Item lookup operations - constant runtime O(1).<br />
	 * has(), remove()</code></li>
	 * </ul>
	 * 
	 * <p><strong>Notes</strong></p>
	 * 
	 * <p>The <code>iterator()</code> method does not support (ignores) the cursor parameter.</p>
	 * 
	 * <p>The <code>iterator()</code> method retuns an <code>ISetIterator</code>.</p>
	 * 
	 * <p><code>null</code> is allowed.</p>
	 * 
	 * <p id="link_SetExample"><strong>Set example</strong></p>
	 * 
	 * <p>This example shows the specific behaviour of a <code>Set</code>.
	 * The general work with collections and iterators is more detailed illustrated
	 * in the <code>ArrayList</code> examples below.</p>
	 * 
	 * {{EXAMPLE: SetExample}}
	 * 
	 * <p id="link_ArrayListExample"><strong>ArrayList example</strong></p>
	 * 
	 * {{EXAMPLE: ArrayListExample}}
	 * 
	 * <p id="link_ArrayListIteratorExample"><strong>ArrayListIterator example</strong></p>
	 * 
	 * {{EXAMPLE: ArrayListIteratorExample}}
	 * 
	 * @author jes 24.03.2010
	 * @see org.as3commons.collections.framework.ISet ISet interface - Detailed description of the base set features.
	 * @see org.as3commons.collections.framework.ISetIterator ISetIterator interface - Detailed description of the base set iterator features.
	 */
	public class Set implements ISet {

		/**
		 * The non string items.
		 */
		private var _items : Dictionary;

		/**
		 * The string items.
		 */
		private var _stringItems : Object;

		/**
		 * The set size.
		 */
		private var _size : uint = 0;
		
		/**
		 * Set constructor.
		 */
		public function Set() {
			_items = new Dictionary();
			_stringItems = new Object();
		}
		
		/*
		 * ISet
		 */

		/**
		 * @inheritDoc
		 */
		public function add(item : *) : Boolean {
			if (item is String) {
				if (_stringItems[item] !== undefined) return false;
				_stringItems[item] = item;

			} else {
				if (_items[item] !== undefined) return false;
				_items[item] = item;
			}
			
			_size++;
			return true;
		}
		
		/*
		 * ICollection
		 */
		
		/**
		 * @inheritDoc
		 */
		public function get size() : uint {
			return _size;
		}
		
		/**
		 * @inheritDoc
		 */
		public function has(item : *) : Boolean {
			if (item is String) return _stringItems[item] !== undefined;
			return _items[item] !== undefined;
		}
		
		/**
		 * @inheritDoc
		 */
		public function toArray() : Array {
			var items : Array = new Array();
			var item : *;
			for each (item in _stringItems) {
				items.push(item);
			}
			for each (item in _items) {
				items.push(item);
			}
			return items;
		}
		
		/**
		 * @inheritDoc
		 */
		public function remove(item : *) : Boolean {
			if (item is String) {
				if (_stringItems[item] === undefined) return false;
				delete _stringItems[item];

			} else {
				if (_items[item] === undefined) return false;
				delete _items[item];
			}
			
			_size--;
			return true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function clear() : Boolean {
			if (!_size) return false;
			_items = new Dictionary();
			_stringItems = new Object();
			_size = 0;
			return true;
		}
		
		/*
		 * IIterable
		 */

		/**
		 * @inheritDoc
		 */
		public function iterator(cursor : * = undefined) : IIterator {
			return new SetIterator(this);
		}
	}
}
