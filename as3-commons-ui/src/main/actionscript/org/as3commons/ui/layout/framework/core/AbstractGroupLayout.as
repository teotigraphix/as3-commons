package org.as3commons.ui.layout.framework.core {

	import org.as3commons.ui.layout.framework.IGroupLayout;

	/**
	 * @author Jens Struwe 17.03.2011
	 */
	public class AbstractGroupLayout extends AbstractLayout implements IGroupLayout {

		private var _gap : uint;

		/*
		 * IGroupLayout
		 */
		
		// Config - Gap
		
		public function set gap(gap : uint) : void {
			_gap = gap;
		}

		public function get gap() : uint {
			return _gap;
		}

	}
}
