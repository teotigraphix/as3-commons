package org.as3commons.ui.layout.framework.core.cell {

	import org.as3commons.ui.layout.CellConfig;
	import org.as3commons.ui.layout.framework.core.config.RenderConfig;
	import org.as3commons.ui.layout.framework.core.row.IRowItem;
	import org.as3commons.ui.layout.framework.core.sizeitem.ISizeItem;

	import flash.geom.Rectangle;


	/**
	 * @author Jens Struwe 16.03.2011
	 */
	public interface ICell extends ISizeItem, IRowItem {
		
		/*
		 * Config
		 */

		function get config() : CellConfig;

		function set renderConfig(renderConfig : RenderConfig) : void;

		function get renderConfig() : RenderConfig;

		/*
		 * Size
		 */

		function isEmpty() : Boolean;

		/*
		 * Data
		 */

		function get contentRect() : Rectangle;

	}
}
