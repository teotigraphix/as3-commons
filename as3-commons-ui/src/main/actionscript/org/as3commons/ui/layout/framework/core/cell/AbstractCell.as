package org.as3commons.ui.layout.framework.core.cell {

	import org.as3commons.ui.layout.CellConfig;
	import org.as3commons.ui.layout.constants.Align;
	import org.as3commons.ui.layout.framework.core.config.RenderConfig;
	import org.as3commons.ui.layout.framework.core.row.AbstractRowItem;

	import flash.geom.Point;
	import flash.geom.Rectangle;


	/**
	 * @author Jens Struwe 16.03.2011
	 */
	public class AbstractCell extends AbstractRowItem implements ICell {
		
		protected var _config : CellConfig;
		protected var _renderConfig : RenderConfig;
		
		protected var _measured : Rectangle;

		protected var _contentRect : Rectangle;
		
		public function AbstractCell() {
			_config = new CellConfig();
		}
		
		/*
		 * ICell
		 */

		// Config
		
		public function get config() : CellConfig {
			return _config;
		}
		
		public function set renderConfig(renderConfig : RenderConfig) : void {
			_renderConfig = renderConfig;
		}

		public function get renderConfig() : RenderConfig {
			return _renderConfig;
		}

		// Size

		public function isEmpty() : Boolean {
			return !_space || !_space.width || !_space.height;
		}

		// Data

		public function get contentRect() : Rectangle {
			return _contentRect;
		}

		/*
		 * IBox
		 */

		override public function measure() : void {
			_space = new Rectangle();

			measureCellContent();

			// measured size
			_measured = _space.clone();

			// space
			if (_config.width) _space.width = _config.width;
			if (_config.height) _space.height = _config.height;
			_space.offset(_config.marginX, _config.marginY);
		}

		override public function render() : void {
			var offsetX : int = _config.marginX + _config.offsetX;
			var offsetY : int = _config.marginY + _config.offsetY;

			// content
			_contentRect = new Rectangle();
			_contentRect.offsetPoint(_position);
			_contentRect.offsetPoint(_measured.topLeft);
			_contentRect.offset(offsetX, offsetY);
			_contentRect.size = _space.size;
			
			// content position
			var position : Point = _position.clone();
			position.offset(offsetX, offsetY);
			alignCellContent(position);
			renderCellContent(position);
		}
		
		/*
		 * Protected
		 */

		protected function measureCellContent() : void {
			// template method
		}

		protected function renderCellContent(position : Point) : void {
			// template method
		}

		/*
		 * Private
		 */

		private function alignCellContent(position : Point) : void {
			var diff : uint;
			
			if (_config.hAlign != Align.LEFT) {
				if (_contentRect.width > _measured.width) {
					diff = _contentRect.width - _measured.width;
					switch (_config.hAlign) {
						case Align.CENTER:
							position.x += Math.round(diff / 2);
							break;
						case Align.RIGHT:
							position.x += diff;
							break;
					}
				}
			}
			
			if (_config.vAlign != Align.TOP) {
				if (_contentRect.height > _measured.height) {
					diff = _contentRect.height - _measured.height;
					switch (_config.vAlign) {
						case Align.MIDDLE:
							position.y += Math.round(diff / 2);
							break;
						case Align.BOTTOM:
							position.y += diff;
							break;
					}
				}
			}
		}

	}
}
