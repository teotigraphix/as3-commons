package org.as3commons.ui.layout.framework.core.row {

	import flash.geom.Rectangle;
	import org.as3commons.ui.layout.CellConfig;


	/**
	 * @author Jens Struwe 21.03.2011
	 */
	public interface IRow extends IRowItem {

		/*
		 * Config
		 */

		function get config() : RowConfig;

		/*
		 * Add
		 */

		function accepts(rowItem : IRowItem, cellConfig : CellConfig = null) : Boolean;
		
		function add(rowItem : IRowItem) : void;
		
		function fillWithEmptyCell(cellSize : Rectangle) : void;
		
		function set parentRow(parentRow : IRow) : void;
		
		function get numItems() : uint;
		
		function get firstRowItem() : IRowItem;

	}
}
