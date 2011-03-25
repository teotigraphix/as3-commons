package org.as3commons.ui.layout.framework.core.init {

	import flash.display.DisplayObject;
	import org.as3commons.ui.layout.framework.ILayout;
	import org.as3commons.ui.layout.framework.ILayoutItem;


	/**
	 * @author Jens Struwe 23.03.2011
	 */
	public class LayoutInitializer extends AbstractLayoutItemInitializer {
		
		/*
		 * Protected
		 */

		override protected function initOther(arg : *) : void {
			// item or list of items to be added
			if (arg is Array || arg is DisplayObject || arg is ILayoutItem) {
				layout.add(arg);
			// config object
			} else if (arg is CellConfigInitObject) {
				var cellConfigInitObject : CellConfigInitObject = arg;
				layout.setCellConfig(cellConfigInitObject.cellConfig, cellConfigInitObject.hIndex, cellConfigInitObject.vIndex);
			}
		}
		
		/*
		 * Private
		 */

		private function get layout() : ILayout {
			return _layoutItem as ILayout;
		}
		
	}
}
