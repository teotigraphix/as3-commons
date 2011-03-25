package org.as3commons.ui.layout.framework {

	/**
	 * @author Jens Struwe 21.03.2011
	 */
	public interface ITable extends IMultilineLayout {

		/*
		 * Config - Max Size
		 */
		
		function set numColumns(numColumns : uint) : void;
		
		function get numColumns() : uint;
		
		/*
		 * Info
		 */

		function get numTableRows() : uint;

	}
}
