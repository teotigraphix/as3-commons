package org.as3commons.ui.layout.framework.core.init {

	import flash.display.DisplayObject;
	import org.as3commons.ui.layout.Display;


	/**
	 * @author Jens Struwe 23.03.2011
	 */
	public class DisplayInitializer extends AbstractLayoutItemInitializer {

		/*
		 * Protected
		 */

		override protected function initOther(arg : *) : void {
			// display object
			if (arg is DisplayObject) {
				Display(_layoutItem).displayObject = arg;
			}
		}

	}
}
