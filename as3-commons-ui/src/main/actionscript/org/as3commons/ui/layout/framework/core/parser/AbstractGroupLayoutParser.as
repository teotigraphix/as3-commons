package org.as3commons.ui.layout.framework.core.parser {

	import org.as3commons.ui.layout.framework.IGroupLayout;
	import org.as3commons.ui.layout.framework.core.cell.ICell;
	import org.as3commons.ui.layout.framework.core.config.CellConfigMerge;
	import org.as3commons.ui.layout.framework.core.row.IRow;

	/**
	 * @author Jens Struwe 17.03.2011
	 */
	public class AbstractGroupLayoutParser extends AbstractLayoutParser {
		
		protected var _RowType : Class;
		
		/*
		 * ILayoutParser
		 */
		
		override public function parseCell(cell : ICell) : void {
			CellConfigMerge.merge(cell.config, _layout.getCellConfig(_layoutCell.row.numItems));
			cell.measure();

			_layoutCell.row.add(cell);
		}
		
		/*
		 * Protected
		 */
		 
		override protected function createRow() : IRow {
			var row : IRow = new _RowType();

			row.config.minWidth = _layout.minWidth;
			row.config.minHeight = _layout.minHeight;
			row.config.gap = IGroupLayout(_layout).gap;
			row.config.hAlign = _layout.hAlign;
			row.config.vAlign = _layout.vAlign;

			return row;
		}

	}
}
