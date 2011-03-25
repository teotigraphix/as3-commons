package org.as3commons.ui.layout.framework.core.parser {

	import org.as3commons.ui.layout.framework.IHLayout;
	import org.as3commons.ui.layout.framework.core.row.HRow;
	import org.as3commons.ui.layout.framework.core.row.IRow;
	import org.as3commons.ui.layout.framework.core.row.VRow;

	/**
	 * @author Jens Struwe 17.03.2011
	 */
	public class HLayoutParser extends AbstractMultilineLayoutParser {

		/*
		 * Protected
		 */
		 
		override protected function createRow() : IRow {
			var row : IRow = new VRow();

			row.config.minHeight = _layout.minHeight;
			row.config.gap = IHLayout(_layout).vGap;
			row.config.vAlign = _layout.vAlign;

			return row;
		}

		override protected function createSubRow() : IRow {
			var row : IRow = new HRow();

			row.config.minWidth = _layout.minWidth;
			row.config.maxContentSize = IHLayout(_layout).maxContentWidth;
			row.config.maxItems = IHLayout(_layout).maxItemsPerRow;
			row.config.gap = IHLayout(_layout).hGap;
			row.config.hAlign = _layout.hAlign;
			row.config.vAlign = _layout.vAlign;

			return row;
		}

	}
}
