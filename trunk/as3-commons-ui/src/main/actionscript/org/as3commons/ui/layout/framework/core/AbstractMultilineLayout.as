package org.as3commons.ui.layout.framework.core {

	import org.as3commons.ui.layout.framework.IMultilineLayout;

	/**
	 * @author Jens Struwe 17.03.2011
	 */
	public class AbstractMultilineLayout extends AbstractLayout implements IMultilineLayout {

		private var _hGap : uint;
		private var _vGap : uint;

		/*
		 * IMultilineLayout
		 */
		
		// Config - Gap
		
		public function set hGap(hGap : uint) : void {
			_hGap = hGap;
		}

		public function get hGap() : uint {
			return _hGap;
		}

		public function set vGap(vGap : uint) : void {
			_vGap = vGap;
		}

		public function get vGap() : uint {
			return _vGap;
		}

	}
}
