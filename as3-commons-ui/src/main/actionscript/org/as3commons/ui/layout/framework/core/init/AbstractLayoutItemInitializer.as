package org.as3commons.ui.layout.framework.core.init {

	import org.as3commons.ui.layout.framework.ILayoutItem;

	/**
	 * @author Jens Struwe 23.03.2011
	 */
	public class AbstractLayoutItemInitializer {
		
		protected var _layoutItem : ILayoutItem;
		private var _inLayout : Boolean = true;
		private var _hide : Boolean = true;
		
		public function init(layoutItem : ILayoutItem, args : Array) : void {
			_layoutItem = layoutItem;

			for (var i : uint = 0; i < args.length; i++) {
				// config property
				if (args[i] is String) {
					initProperty(args[i], args[i + 1]);
					i++;
	
				// display object
				} else {
					initOther(args[i]);
				}
			}
			
			if (!_inLayout) {
				_layoutItem.excludeFromLayout(_hide);
			}
		}
		
		/*
		 * Protected
		 */

		protected function initOther(arg : *) : void {
			// template method
		}
		
		/*
		 * Private
		 */

		private function initProperty(property : String, value : *) : void {
			if (property == "inLayout") {
				_inLayout = value;
			} else if (property == "visible") {
				_hide = !value;
			} else {
				try {
					_layoutItem[property] = value;
				} catch (e : Error) {
				}
			}
		}
		
	}
}
