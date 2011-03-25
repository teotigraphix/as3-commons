package org.as3commons.ui.layout.framework.core.row {

	import org.as3commons.ui.layout.constants.Align;

	/**
	 * @author Jens Struwe 17.03.2011
	 */
	public class VRow extends AbstractRow {

		public function VRow() {
			_x = "y";
			_y = "x";
			_width = "height";
			_height = "width";

			_align = "vAlign";
			_alignLeft = Align.TOP;
			_alignCenter = Align.MIDDLE;
			_alignRight = Align.BOTTOM;
	
			_oppositeAlign = "hAlign";
			_oppositeAlignTop = Align.LEFT;
			_oppositeAlignMiddle = Align.CENTER;
			_oppositeAlignBottom = Align.RIGHT;
		}

	}

}
