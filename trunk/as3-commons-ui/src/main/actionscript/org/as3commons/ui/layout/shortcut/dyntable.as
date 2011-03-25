package org.as3commons.ui.layout.shortcut {

	import org.as3commons.ui.layout.DynTable;
	import org.as3commons.ui.layout.framework.core.init.LayoutInitializer;

	/**
	 * @author Jens Struwe 18.03.2011
	 */
	public function dyntable(...args) : DynTable {
		var t : DynTable = new DynTable();
		new LayoutInitializer().init(t, args);
		return t;
	}
}
