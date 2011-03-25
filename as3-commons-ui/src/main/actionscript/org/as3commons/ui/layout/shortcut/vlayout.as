package org.as3commons.ui.layout.shortcut {

	import org.as3commons.ui.layout.VLayout;
	import org.as3commons.ui.layout.framework.core.init.LayoutInitializer;

	/**
	 * @author Jens Struwe 18.03.2011
	 */
	public function vlayout(...args) : VLayout {
		var v : VLayout = new VLayout();
		new LayoutInitializer().init(v, args);
		return v;
	}

}
