package org.as3commons.ui.layout {

	import org.as3commons.ui.layout.framework.ITable;
	import org.as3commons.ui.layout.framework.core.AbstractMultilineLayout;
	import org.as3commons.ui.layout.framework.core.cell.ILayoutCell;
	import org.as3commons.ui.layout.framework.core.parser.ILayoutParser;
	import org.as3commons.ui.layout.framework.core.parser.SingleRowTableParser;
	import org.as3commons.ui.layout.framework.core.parser.TableParser;

	/**
	 * @author Jens Struwe 09.03.2011
	 */
	public class Table extends AbstractMultilineLayout implements ITable {

		private var _numColumns : uint;

		/*
		 * ITable
		 */
		
		// Config - Max Size
		
		public function set numColumns(numColumns : uint) : void {
			_numColumns = numColumns;
		}

		public function get numColumns() : uint {
			return _numColumns;
		}

		// Info

		public function get numTableRows() : uint {
			return _cell ? ILayoutCell(_cell).row.numItems : 0;
		}

		/*
		 * Info
		 */

		override public function toString() : String {
			return "[Table]" + super.toString();
		}

		/*
		 * Protected
		 */

		override protected function createParser() : ILayoutParser {
			if (_numColumns) return new TableParser();
			else return new SingleRowTableParser();
		}

	}
}
