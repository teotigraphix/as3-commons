package org.as3commons.ui.layout.framework.core.cell {

	import org.as3commons.ui.layout.framework.core.row.IRow;

	import flash.geom.Point;
	import flash.geom.Rectangle;



	/**
	 * @author Jens Struwe 17.03.2011
	 */
	public class LayoutCell extends AbstractCell implements ILayoutCell {
		
		private var _row : IRow;
		
		/*
		 * ILayoutCell
		 */
		
		public function set row(row : IRow) : void {
			_row = row;
		}

		public function get row() : IRow {
			return _row;
		}
		
		/*
		 * IBox
		 */
		
		override public function get visibleRect() : Rectangle {
			return _row.visibleRect;
		}

		/*
		 * Protected
		 */
		
		override protected function measureCellContent() : void {
			_space = row.space.clone();
		}

		override protected function renderCellContent(position : Point) : void {
			_row.position.x = position.x;
			_row.position.y = position.y;
			_row.render();
		}

	}
}
