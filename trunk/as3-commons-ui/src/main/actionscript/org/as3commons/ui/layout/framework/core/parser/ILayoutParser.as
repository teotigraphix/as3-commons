package org.as3commons.ui.layout.framework.core.parser {

	import org.as3commons.ui.layout.framework.ILayout;
	import org.as3commons.ui.layout.framework.core.cell.ICell;

	/**
	 * @author Jens Struwe 16.03.2011
	 */
	public interface ILayoutParser {

		function set layout(layout : ILayout) : void;

		/*
		 * Parsing
		 */

		function prepare() : void;

		function parseCell(cell : ICell) : void;

		function finish() : ICell;

	}
}
