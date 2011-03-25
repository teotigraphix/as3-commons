package org.as3commons.ui.layout.framework.core.parser {

	import org.as3commons.ui.layout.CellConfig;
	import org.as3commons.ui.layout.framework.core.cell.ICell;
	import org.as3commons.ui.layout.framework.core.config.CellConfigMerge;
	import org.as3commons.ui.layout.framework.core.row.IRow;

	/**
	 * @author Jens Struwe 17.03.2011
	 */
	public class AbstractMultilineLayoutParser extends AbstractLayoutParser {
		
		protected var _subRow : IRow;

		/*
		 * ILayoutParser
		 */
		
		override public function prepare() : void {
			super.prepare();
			
			_subRow = createSubRow();
		}
		
		override public function parseCell(cell : ICell) : void {
			// measure cell first
			cell.measure();
			// skip empty cells
			if (cell.isEmpty()) return;
			
			// create a new sub row if necessary
			if (!_subRow.accepts(cell, getCellConfig(_subRow.numItems, _layoutCell.row.numItems))) {
				// finish last row
				finishSubRow();
				// next row
				_subRow = createSubRow();
			}

			// assign cell config
			var cellConfig : CellConfig = getCellConfig(_subRow.numItems, _layoutCell.row.numItems);
			if (cellConfig) {
				CellConfigMerge.merge(cell.config, cellConfig);
				cell.measure();
			}

			// add item
			_subRow.add(cell);
		}
		
		override public function finish() : ICell {
			finishSubRow();
			
			return super.finish();
		}
		
		/*
		 * Protected
		 */
		
		protected function getCellConfig(hIndex : uint, vIndex : uint) : CellConfig {
			// Subclasses may return null with getCellConfig if they already fully control the
			// position of the cell within the layout.
			return _layout.getCellConfig(hIndex, vIndex);
		}

		protected function createSubRow() : IRow {
			// template method
			return null;
		}

		/*
		 * Private
		 */

		private function finishSubRow() : void {
			_subRow.measure();
			_subRow.parentRow = _layoutCell.row;
			_layoutCell.row.add(_subRow);
		}
	}

}
