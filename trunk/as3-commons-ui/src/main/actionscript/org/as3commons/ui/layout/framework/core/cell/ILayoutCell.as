package org.as3commons.ui.layout.framework.core.cell {

	import org.as3commons.ui.layout.framework.core.row.IRow;

	/**
	 * @author Jens Struwe 17.03.2011
	 */
	public interface ILayoutCell extends ICell {
		
		function set row(row : IRow) : void;

		function get row() : IRow;
		
	}
}
