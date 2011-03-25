package org.as3commons.ui.layout.framework.core.config {

	import org.as3commons.ui.layout.CellConfig;
	import org.as3commons.ui.layout.constants.Align;

	/**
	 * @author Jens Struwe 23.03.2011
	 */
	public class CellConfigMerge {
		
		public static function merge(toConfig : CellConfig, fromConfig : CellConfig) : CellConfig {
			if (!fromConfig) return toConfig;

			if (!toConfig) toConfig = new CellConfig();

			if (fromConfig.width) toConfig.width = fromConfig.width;
			if (fromConfig.height) toConfig.height = fromConfig.height;
			if (fromConfig.marginX) toConfig.marginX = fromConfig.marginX;
			if (fromConfig.marginY) toConfig.marginY = fromConfig.marginY;
			if (fromConfig.offsetX) toConfig.offsetX = fromConfig.offsetX;
			if (fromConfig.hAlign != Align.LEFT) toConfig.hAlign = fromConfig.hAlign;
			if (fromConfig.vAlign != Align.TOP) toConfig.vAlign = fromConfig.vAlign;

			return toConfig;
		}

	}
}
