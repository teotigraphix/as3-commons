package org.as3commons.ui.layout.framework.core.row {

	import org.as3commons.ui.layout.framework.core.sizeitem.SizeItem;

	/**
	 * @author Jens Struwe 17.03.2011
	 */
	public class AbstractRowItem extends SizeItem implements IRowItem {

		private var _nextRowItem : IRowItem;
		protected var _isFirst : Boolean;
		protected var _isLast : Boolean;

		/*
		 * IRowItem
		 */

		public function set isFirst(isFirst : Boolean) : void {
			_isFirst = isFirst;
		}

		public function get isFirst() : Boolean {
			return _isFirst;
		}

		public function set isLast(isLast : Boolean) : void {
			_isLast = isLast;
		}

		public function get isLast() : Boolean {
			return _isLast;
		}

		public function set nextRowItem(row : IRowItem) : void {
			_nextRowItem = row;
		}

		public function get nextRowItem() : IRowItem {
			return _nextRowItem;
		}

	}
}
