package org.as3commons.ui.layout.shortcut {

	import org.as3commons.ui.layout.HGroup;
	import org.as3commons.ui.layout.framework.core.init.LayoutInitializer;

	/**
	 * @author Jens Struwe 18.03.2011
	 */
	public function hgroup(...args) : HGroup {
		var h : HGroup = new HGroup();
		new LayoutInitializer().init(h, args);
		return h;
	}
}
