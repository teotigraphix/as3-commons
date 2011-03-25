package org.as3commons.ui.layout.framework.core.sizeitem {

	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Jens Struwe 11.03.2011
	 */
	public interface ISizeItem {

		/*
		 * Measure
		 */
		
		function measure() : void;

		function get space() : Rectangle;

		/*
		 * Render
		 */

		function get position() : Point;
		
		function render() : void;

		/*
		 * Data
		 */

		function get visibleRect() : Rectangle;

	}
}
