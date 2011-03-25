package org.as3commons.ui.layout {

	import org.as3commons.ui.layout.framework.IDynamicTable;
	import org.as3commons.ui.layout.framework.core.AbstractMultilineLayout;
	import org.as3commons.ui.layout.framework.core.cell.ILayoutCell;
	import org.as3commons.ui.layout.framework.core.parser.DynamicTableParser;
	import org.as3commons.ui.layout.framework.core.parser.ILayoutParser;
	import org.as3commons.ui.layout.framework.core.parser.SingleRowTableParser;
	import org.as3commons.ui.layout.framework.core.row.IRow;

	/**
	 * @author Jens Struwe 21.03.2011
	 */
	public class DynTable extends AbstractMultilineLayout implements IDynamicTable {

		private var _maxContentWidth : uint;

		/*
		 * ILayout
		 */

		override public function setCellConfig(cellConfig : CellConfig, hIndex : int = -1, vIndex : int = -1) : void {
			cellConfig.width = cellConfig.height = 0;
			cellConfig.marginX = cellConfig.marginY = 0;
			cellConfig.offsetX = cellConfig.offsetY = 0;
			super.setCellConfig(cellConfig);
		}

		/*
		 * IDynamicTable
		 */
		
		// Config - Max Size
		
		public function set maxContentWidth(maxContentWidth : uint) : void {
			_maxContentWidth = maxContentWidth;
		}

		public function get maxContentWidth() : uint {
			return _maxContentWidth;
		}

		// Info

		public function get numTableRows() : uint {
			return _cell ? ILayoutCell(_cell).row.numItems : 0;
		}

		public function get numTableColumns() : uint {
			if (!_cell) return 0;
			var row : IRow = ILayoutCell(_cell).row.firstRowItem as IRow;
			if (!row) return 0;
			return row.numItems;
		}

		/*
		 * Protected
		 */

		override protected function createParser() : ILayoutParser {
			if (_maxContentWidth) return new DynamicTableParser();
			else return new SingleRowTableParser();
		}

	}
}
