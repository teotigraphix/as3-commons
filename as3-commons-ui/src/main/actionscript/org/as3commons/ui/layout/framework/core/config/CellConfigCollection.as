package org.as3commons.ui.layout.framework.core.config {

	import org.as3commons.ui.layout.CellConfig;

	/**
	 * @author Jens Struwe 21.03.2011
	 */
	public class CellConfigCollection {
		
		private var _width : uint;
		private var _height : uint;
		private var _cellConfigs : Object;

		public function CellConfigCollection() {
			_cellConfigs = new Object();
		}
		
		/*
		 * Public
		 */

		public function setConfig(cellConfig : CellConfig, hIndex : int = -1, vIndex : int = -1) : void {
			var x : uint = hIndex + 1;
			var y : uint = vIndex + 1;

			if (x >= _width || y >= _height) resize(x + 1, y + 1);
			_cellConfigs[y * _width + x] = cellConfig;
		}

		public function getConfig(hIndex : int = -1, vIndex : int = -1) : CellConfig {
			var x : uint = hIndex + 1;
			var y : uint = vIndex + 1;
			if (x >= _width) x = 0;
			if (y >= _height) y = 0;

			var cellConfig : CellConfig;
			if (x && y) cellConfig = CellConfigMerge.merge(cellConfig, _cellConfigs[y * _width + x]);
			if (x) cellConfig = CellConfigMerge.merge(cellConfig, _cellConfigs[x]);
			if (y) cellConfig = CellConfigMerge.merge(cellConfig, _cellConfigs[y * _width]);
			cellConfig = CellConfigMerge.merge(cellConfig, _cellConfigs[0]);

			return cellConfig;
		}
		
		/*
		 * Private
		 */

		private function resize(width : uint, height : uint) : void {

			width = Math.max(width, _width);
			height = Math.max(height, _height);
			var cellConfigs : Object = new Object();
			var x : uint;
			var y : uint;
			var oldIndex : uint;

			for (var property : String in _cellConfigs) {
				oldIndex = parseInt(property);
				x = oldIndex % width;
				y = Math.floor(oldIndex / width);

				cellConfigs[y * width + x] = _cellConfigs[oldIndex];
			}
			
			_cellConfigs = cellConfigs; 
			_width = width;
			_height = height;


		}
		
	}
}
