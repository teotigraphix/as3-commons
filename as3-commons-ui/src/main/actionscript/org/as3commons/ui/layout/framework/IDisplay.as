package org.as3commons.ui.layout.framework {

	import flash.display.DisplayObject;


	/**
	 * @author Jens Struwe 21.03.2011
	 */
	public interface IDisplay extends ILayoutItem {

		/*
		 * Config - DisplayObject
		 */
		
		function set displayObject(displayObject : DisplayObject) : void;
		
		function get displayObject() : DisplayObject;

		/*
		 * Config - Size
		 */
		
		function set width(width : uint) : void;
		
		function get width() : uint;
		
		function set height(height : uint) : void;
		
		function get height() : uint;

	}
}
