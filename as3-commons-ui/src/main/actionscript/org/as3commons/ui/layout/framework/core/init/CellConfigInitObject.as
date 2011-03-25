package org.as3commons.ui.layout.framework.core.init {

	import org.as3commons.ui.layout.CellConfig;

	/**
	 * @author Jens Struwe 21.03.2011
	 */
	public dynamic class CellConfigInitObject {
		
		public var hIndex : int = -1;
		public var vIndex : int = -1;
		public var cellConfig : CellConfig;

		public function CellConfigInitObject() {
			cellConfig = new CellConfig();
		}

	}
}
