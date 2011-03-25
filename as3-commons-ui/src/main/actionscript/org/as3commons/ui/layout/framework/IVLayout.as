package org.as3commons.ui.layout.framework {


	/**
	 * @author Jens Struwe 21.03.2011
	 */
	public interface IVLayout extends IMultilineLayout {

		/*
		 * Config - Max Size
		 */
		
		function set maxItemsPerColumn(maxItemsPerColumn : uint) : void;
		
		function get maxItemsPerColumn() : uint;
		
		function set maxContentHeight(maxContentHeight : uint) : void;
		
		function get maxContentHeight() : uint;

		/*
		 * Info
		 */

		function get numLayoutColumns() : uint;

	}
}
