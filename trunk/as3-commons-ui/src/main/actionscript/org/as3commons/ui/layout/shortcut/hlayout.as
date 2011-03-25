package org.as3commons.ui.layout.shortcut {

	import org.as3commons.ui.layout.HLayout;
	import org.as3commons.ui.layout.framework.core.init.LayoutInitializer;

	/**
	 * @author Jens Struwe 18.03.2011
	 */
	public function hlayout(...args) : HLayout {
		var h : HLayout = new HLayout();
		new LayoutInitializer().init(h, args);
		return h;
	}
}
