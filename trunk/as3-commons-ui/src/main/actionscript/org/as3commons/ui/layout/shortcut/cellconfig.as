package org.as3commons.ui.layout.shortcut {

	import org.as3commons.ui.layout.framework.core.init.CellConfigInitObject;

	/**
	 * @author Jens Struwe 18.03.2011
	 */
	public function cellconfig(...args) : CellConfigInitObject {
		var c : CellConfigInitObject = new CellConfigInitObject();

		for (var i : uint = 0; i < args.length; i += 2) {
			if (args[i] is String) {
				if (args[i] == "hIndex") {
					c.hIndex = args[i + 1];

				} else if (args[i] == "vIndex") {
					c.vIndex = args[i + 1];

				} else {
					try {
						c.cellConfig[args[i]] = args[i + 1];
					} catch (e : Error) {
					}
				}
			}
		}

		return c;
	}
}
