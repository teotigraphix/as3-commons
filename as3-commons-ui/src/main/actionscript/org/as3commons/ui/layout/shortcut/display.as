package org.as3commons.ui.layout.shortcut {

	import org.as3commons.ui.layout.Display;
	import org.as3commons.ui.layout.framework.core.init.DisplayInitializer;

	/**
	 * @author Jens Struwe 18.03.2011
	 */
	public function display(...args) : Display {
		var d : Display = new Display();
		new DisplayInitializer().init(d, args);
		return d;
	}
}
