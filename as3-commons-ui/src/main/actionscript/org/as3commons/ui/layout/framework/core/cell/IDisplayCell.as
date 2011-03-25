package org.as3commons.ui.layout.framework.core.cell {

	import flash.display.DisplayObject;

	/**
	 * @author Jens Struwe 19.03.2011
	 */
	public interface IDisplayCell extends ICell {
		
		function set displayObject(displayObject : DisplayObject) : void;

		function get displayObject() : DisplayObject;

	}
}
