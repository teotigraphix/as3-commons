package org.as3commons.ui.layout {

	import org.as3commons.ui.layout.framework.core.AbstractGroupLayout;
	import org.as3commons.ui.layout.framework.core.parser.HGroupParser;
	import org.as3commons.ui.layout.framework.core.parser.ILayoutParser;

	/**
	 * @author Jens Struwe 09.03.2011
	 */
	public class HGroup extends AbstractGroupLayout {

		/*
		 * ILayout
		 */

		override public function setCellConfig(cellConfig : CellConfig, hIndex : int = -1, vIndex : int = -1) : void {
			super.setCellConfig(cellConfig, hIndex, -1);
		}

		/*
		 * Info
		 */

		override public function toString() : String {
			return "[HGroup]" + super.toString();
		}

		/*
		 * Protected
		 */

		override protected function createParser() : ILayoutParser {
			var parser : ILayoutParser = new HGroupParser();
			return parser;
		}
		
	}

}
