package org.as3commons.ui.layout {

	import org.as3commons.ui.layout.framework.IHLayout;
	import org.as3commons.ui.layout.framework.core.AbstractMultilineLayout;
	import org.as3commons.ui.layout.framework.core.cell.ILayoutCell;
	import org.as3commons.ui.layout.framework.core.parser.HLayoutParser;
	import org.as3commons.ui.layout.framework.core.parser.ILayoutParser;

	/**
	 * @author Jens Struwe 09.03.2011
	 */
	public class HLayout extends AbstractMultilineLayout implements IHLayout {
		
		private var _maxItemsPerRow : uint;
		private var _maxContentWidth : uint;

		/*
		 * IHLayout
		 */
		
		// Config - Max Size
		
		public function set maxItemsPerRow(maxItemsPerRow : uint) : void {
			_maxItemsPerRow = maxItemsPerRow;
		}

		public function get maxItemsPerRow() : uint {
			return _maxItemsPerRow;
		}

		public function set maxContentWidth(maxContentWidth : uint) : void {
			_maxContentWidth = maxContentWidth;
		}

		public function get maxContentWidth() : uint {
			return _maxContentWidth;
		}

		// Info

		public function get numLayoutRows() : uint {
			return _cell ? ILayoutCell(_cell).row.numItems : 0;
		}

		/*
		 * Info
		 */

		override public function toString() : String {
			return "[HLayout]" + super.toString();
		}

		/*
		 * Protected
		 */

		override protected function createParser() : ILayoutParser {
			var parser : ILayoutParser = new HLayoutParser();
			return parser;
		}

	}
}
