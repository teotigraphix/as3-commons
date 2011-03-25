package org.as3commons.ui.layout.framework.core.row {

	import org.as3commons.ui.layout.framework.core.sizeitem.ISizeItem;
	/**
	 * @author Jens Struwe 16.03.2011
	 */
	public interface IRowItem extends ISizeItem {

		function set isFirst(isFirst : Boolean) : void;

		function get isFirst() : Boolean;

		function set isLast(isLast : Boolean) : void;

		function get isLast() : Boolean;

		function set nextRowItem(rowItem : IRowItem) : void;

		function get nextRowItem() : IRowItem;
		
	}
}
