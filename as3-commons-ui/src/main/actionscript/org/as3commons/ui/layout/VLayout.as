package org.as3commons.ui.layout {

	import org.as3commons.ui.layout.framework.IVLayout;
	import org.as3commons.ui.layout.framework.core.AbstractMultilineLayout;
	import org.as3commons.ui.layout.framework.core.cell.ILayoutCell;
	import org.as3commons.ui.layout.framework.core.parser.ILayoutParser;
	import org.as3commons.ui.layout.framework.core.parser.VLayoutParser;

	/**
	 * @author Jens Struwe 09.03.2011
	 */
	public class VLayout extends AbstractMultilineLayout implements IVLayout {

		private var _maxItemsPerColumn : uint;
		private var _maxContentHeight : uint;

		/*
		 * IVLayout
		 */
		
		// Config - Max Size
		
		public function set maxItemsPerColumn(maxItemsPerColumn : uint) : void {
			_maxItemsPerColumn = maxItemsPerColumn;
		}

		public function get maxItemsPerColumn() : uint {
			return _maxItemsPerColumn;
		}

		public function set maxContentHeight(maxContentHeight : uint) : void {
			_maxContentHeight = maxContentHeight;
		}

		public function get maxContentHeight() : uint {
			return _maxContentHeight;
		}

		// Info

		public function get numLayoutColumns() : uint {
			return _cell ? ILayoutCell(_cell).row.numItems : 0;
		}

		/*
		 * Info
		 */

		override public function toString() : String {
			return "[VLayout]" + super.toString();
		}

		/*
		 * Protected
		 */

		override protected function createParser() : ILayoutParser {
			var parser : ILayoutParser = new VLayoutParser();
			return parser;
		}

	}
}
