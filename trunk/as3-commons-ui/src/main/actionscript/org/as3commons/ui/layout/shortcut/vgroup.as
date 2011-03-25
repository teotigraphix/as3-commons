package org.as3commons.ui.layout.shortcut {

	import org.as3commons.ui.layout.VGroup;
	import org.as3commons.ui.layout.framework.core.init.LayoutInitializer;

	/**
	 * @author Jens Struwe 18.03.2011
	 */
	public function vgroup(...args) : VGroup {
		var v : VGroup = new VGroup();
		new LayoutInitializer().init(v, args);
		return v;
	}
}
