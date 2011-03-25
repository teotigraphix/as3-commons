package org.as3commons.ui.layout.framework.core.parser {

	import org.as3commons.ui.layout.VLayout;
	import org.as3commons.ui.layout.framework.IVLayout;
	import org.as3commons.ui.layout.framework.core.row.HRow;
	import org.as3commons.ui.layout.framework.core.row.IRow;
	import org.as3commons.ui.layout.framework.core.row.VRow;

	/**
	 * @author Jens Struwe 17.03.2011
	 */
	public class VLayoutParser extends AbstractMultilineLayoutParser {

		/*
		 * Protected
		 */
		 
		override protected function createRow() : IRow {
			var row : IRow = new HRow();

			row.config.minWidth = _layout.minWidth;
			row.config.gap = IVLayout(_layout).hGap;
			row.config.hAlign = _layout.hAlign;

			return row;
		}

		override protected function createSubRow() : IRow {
			var row : IRow = new VRow();

			row.config.minHeight = _layout.minHeight;
			row.config.maxContentSize = VLayout(_layout).maxContentHeight;
			row.config.maxItems = IVLayout(_layout).maxItemsPerColumn;
			row.config.gap = IVLayout(_layout).vGap;
			row.config.hAlign = _layout.hAlign;
			row.config.vAlign = _layout.vAlign;

			return row;
		}

	}
}
