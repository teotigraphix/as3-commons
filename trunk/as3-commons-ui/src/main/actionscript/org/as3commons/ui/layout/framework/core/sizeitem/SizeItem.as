package org.as3commons.ui.layout.framework.core.sizeitem {

	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Jens Struwe 17.03.2011
	 */
	public class SizeItem implements ISizeItem {

		protected var _space : Rectangle;
		protected var _position : Point;

		public function SizeItem() {
			_position = new Point();
		}

		/*
		 * IBox
		 */

		// Measure
		
		public function measure() : void {
			// template method
		}

		public function get space() : Rectangle {
			return _space;
		}
		
		// Render

		public function get position() : Point {
			return _position;
		}

		public function render() : void {
			// template method
		}

		// Data

		public function get visibleRect() : Rectangle {
			// template method
			return null;
		}

	}
}
