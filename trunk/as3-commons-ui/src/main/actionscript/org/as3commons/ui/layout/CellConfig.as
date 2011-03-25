package org.as3commons.ui.layout {

	import org.as3commons.ui.layout.constants.Align;

	/**
	 * @author Jens Struwe 17.03.2011
	 */
	public class CellConfig {
		
		public var width : uint;
		public var height : uint;

		public var marginX : int;
		public var marginY : int;

		public var offsetX : int;
		public var offsetY : int;

		public var hAlign : String = Align.LEFT;
		public var vAlign : String = Align.TOP;

	}
}
