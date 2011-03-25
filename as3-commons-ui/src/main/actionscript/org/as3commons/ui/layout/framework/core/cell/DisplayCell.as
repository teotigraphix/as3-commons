package org.as3commons.ui.layout.framework.core.cell {

	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Jens Struwe 17.03.2011
	 */
	public class DisplayCell extends AbstractCell implements IDisplayCell {
		
		private var _visibleRect : Rectangle;
		private var _displayObject : DisplayObject;
		
		/*
		 * IDisplayCell
		 */
		
		public function set displayObject(displayObject : DisplayObject) : void {
			_displayObject = displayObject;
		}

		public function get displayObject() : DisplayObject {
			return _displayObject;
		}

		/*
		 * Protected
		 */
		
		override protected function measureCellContent() : void {
			_space.width = displayObject.width;
			_space.height = displayObject.height;
		}

		override protected function renderCellContent(position : Point) : void {
			if (_displayObject.parent != renderConfig.container) renderConfig.container.addChild(_displayObject);

			if (renderConfig.show) {
				if (renderConfig.showCallback != null) renderConfig.showCallback(_displayObject);
				else _displayObject.visible = true;
			}

			if (_renderConfig.renderCallback != null) {
				_renderConfig.renderCallback(displayObject, position.x, position.y);

			} else {
				displayObject.x = position.x;
				displayObject.y = position.y;
			}
			
			_visibleRect = new Rectangle(position.x, position.y, displayObject.width, displayObject.height);
		}
		
		/*
		 * IBox
		 */
		
		override public function get visibleRect() : Rectangle {
			return _visibleRect;
		}

	}
}
