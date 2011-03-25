package org.as3commons.ui.layout.framework.core.row {

	import org.as3commons.ui.layout.constants.Align;

	/**
	 * @author Jens Struwe 17.03.2011
	 */
	public class RowConfig {

		public var minWidth : uint;
		public var minHeight : uint;

		public var maxContentSize : uint;
		public var maxItems : uint;

		public var gap : uint;

		public var hAlign : String = Align.LEFT;
		public var vAlign : String = Align.TOP;

	}
}
