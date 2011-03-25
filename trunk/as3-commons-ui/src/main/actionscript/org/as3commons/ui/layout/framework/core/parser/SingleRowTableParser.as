package org.as3commons.ui.layout.framework.core.parser {

	import org.as3commons.ui.layout.framework.IMultilineLayout;
	import org.as3commons.ui.layout.framework.core.row.HRow;
	import org.as3commons.ui.layout.framework.core.row.IRow;

	/**
	 * @author Jens Struwe 19.03.2011
	 */
	public class SingleRowTableParser extends AbstractGroupLayoutParser {

		/*
		 * Protected
		 */
		 
		override protected function createRow() : IRow {
			var row : IRow = new HRow();

			row.config.minWidth = _layout.minWidth;
			row.config.minHeight = _layout.minHeight;
			row.config.gap = IMultilineLayout(_layout).hGap;
			row.config.hAlign = _layout.hAlign;
			row.config.vAlign = _layout.vAlign;

			return row;
		}

	}
}
