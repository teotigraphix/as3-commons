package org.as3commons.ui.layout.shortcut {

	import org.as3commons.ui.layout.Table;
	import org.as3commons.ui.layout.framework.core.init.LayoutInitializer;

	/**
	 * @author Jens Struwe 18.03.2011
	 */
	public function table(...args) : Table {
		var t : Table = new Table();
		new LayoutInitializer().init(t, args);
		return t;
	}
}
