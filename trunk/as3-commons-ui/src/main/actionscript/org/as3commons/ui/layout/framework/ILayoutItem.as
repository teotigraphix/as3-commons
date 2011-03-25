package org.as3commons.ui.layout.framework {

	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * @author Jens Struwe 21.03.2011
	 */
	public interface ILayoutItem {

		/*
		 * Config - ID
		 */
		
		function set id(id : String) : void;
		
		function get id() : String;

		/*
		 * Config - Margin, Offset
		 */
		
		function set marginX(marginX : int) : void;
		
		function get marginX() : int;
		
		function set marginY(marginY : int) : void;
		
		function get marginY() : int;
		
		function set offsetX(offsetX : int) : void;
		
		function get offsetX() : int;
		
		function set offsetY(offsetY : int) : void;
		
		function get offsetY() : int;
		
		/*
		 * Config - Align
		 */
		
		function set hAlign(hAlign : String) : void;
		
		function get hAlign() : String;
		
		function set vAlign(vAlign : String) : void;
		
		function get vAlign() : String;
		
		/*
		 * Config - Include, Exclude
		 */

		function get inLayout() : Boolean;

		function excludeFromLayout(hide : Boolean = true) : void;
		
		function includeInLayout(show : Boolean = true) : void;
		
		/*
		 * Layout
		 */

		function set renderCallback(renderCallback : Function) : void;

		function get renderCallback() : Function;

		function set hideCallback(hideCallback : Function) : void;

		function get hideCallback() : Function;

		function set showCallback(showCallback : Function) : void;

		function get showCallback() : Function;

		/*
		 * Info Data
		 */

		function get position() : Point;

		function get contentRect() : Rectangle;
		
		function get visibleRect() : Rectangle;

	}
}
