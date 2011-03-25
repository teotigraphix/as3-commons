package org.as3commons.ui.layout {

	import org.as3commons.ui.layout.framework.core.AbstractGroupLayout;
	import org.as3commons.ui.layout.framework.core.parser.ILayoutParser;
	import org.as3commons.ui.layout.framework.core.parser.VGroupParser;

	/**
	 * @author Jens Struwe 09.03.2011
	 */
	public class VGroup extends AbstractGroupLayout {

		/*
		 * ILayout
		 */

		override public function setCellConfig(cellConfig : CellConfig, hIndex : int = -1, vIndex : int = -1) : void {
			super.setCellConfig(cellConfig, -1, vIndex);
		}

		/*
		 * Info
		 */

		override public function toString() : String {
			return "[VGroup]" + super.toString();
		}

		/*
		 * Protected
		 */

		override protected function createParser() : ILayoutParser {
			var parser : ILayoutParser = new VGroupParser();
			return parser;
		}

	}

}
