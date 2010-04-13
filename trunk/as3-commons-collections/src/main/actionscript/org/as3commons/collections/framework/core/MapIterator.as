package org.as3commons.collections.framework.core {
	import org.as3commons.collections.Map;
	import org.as3commons.collections.framework.IMapIterator;
	import org.as3commons.collections.iterators.ArrayIterator;

	/**
	 * Internal <code>Map</code> iterator implementation.
	 * 
	 * @author jes 01.04.2010
	 */
	public class MapIterator extends ArrayIterator implements IMapIterator {

		/**
		 * The map to enumerate.
		 */
		protected var _map : Map;

		/**
		 * MapIterator constructor.
		 * 
		 * @param map The map to enumerate.
		 */
		public function MapIterator(map : Map) {
			_map = map;
			super(_map.keysToArray());
		}
		
		/*
		 * IMapIterator
		 */
		
		/**
		 * @inheritDoc
		 */
		public function get previousKey() : * {
			return _array[previousIndex];
		}
		
		/**
		 * @inheritDoc
		 */
		public function get nextKey() : * {
			return _array[_next];
		}
	
		/**
		 * @inheritDoc
		 */
		public function get key() : * {
			return super.current;
		}
	
		/*
		 * ICollectionIterator
		 */
		
		/**
		 * @inheritDoc
		 */
		override public function previous() : * {
			return _map.itemFor(super.previous());
		}
	
		/**
		 * @inheritDoc
		 */
		override public function get current() : * {
			return _map.itemFor(super.current);
		}
	
		/**
		 * @inheritDoc
		 */
		override public function next() : * {
			return _map.itemFor(super.next());
		}
	
		/*
		 * Protected
		 */
		
		/**
		 * @inheritDoc
		 */
		override protected function removeCurrent() : void {
			_map.removeKey(super.current);
			super.removeCurrent();
		}
	}
}
