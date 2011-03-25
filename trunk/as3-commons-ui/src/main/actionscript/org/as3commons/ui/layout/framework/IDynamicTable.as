package org.as3commons.ui.layout.framework {

	/**
	 * @author Jens Struwe 21.03.2011
	 */
	public interface IDynamicTable extends IMultilineLayout {

		/*
		 * Config - Max Size
		 */
		
		function set maxContentWidth(maxContentWidth : uint) : void;
		
		function get maxContentWidth() : uint;

		/*
		 * Info
		 */

		function get numTableRows() : uint;

		function get numTableColumns() : uint;

	}
}
