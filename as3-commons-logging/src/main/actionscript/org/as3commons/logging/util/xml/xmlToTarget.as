package org.as3commons.logging.util.xml {
	import org.as3commons.logging.setup.ILogTarget;
	/**
	 * @author mh
	 */
	public function xmlToTarget(xml:XML, targetTypes:Object):ILogTarget {
		if (xml.namespace() == xmlNs && xml.localName() == "target" ) {
			var type: Class = targetTypes[QName(xml.@type).toString()];
			if (type) {
				var args: Array = [];
				for each (var arg: XML in xml.xmlNs::arg) {
					var argString: String;
					var argValue: * = null;
					if (arg.hasOwnProperty("@value") ) {
						argString = QName(arg.@value).toString();
					} else {
						argString = arg.toString();
					}
					if(argString != "") {
						argValue = parseInt(argString);
						if (isNaN(argValue)) {
							argValue = parseFloat(argString);
							if (isNaN(argValue)){
								if(bool.test(argString)) {
									argValue = argString.toLowerCase() == "true";
								} else {
									argValue = argString;
								}
							}
						}
					}
					args.push(argValue);
				}
				if (args.length == 0) {
					return new type();
				}
				if (args.length == 1) {
					return new type(args[0]);
				}
				if (args.length == 2) {
					return new type(args[0], args[1]);
				}
				if (args.length == 3) {
					return new type(args[0], args[1], args[2]);
				}
				if (args.length == 4) {
					return new type(args[0], args[1], args[2], args[3]);
				}
				if (args.length == 5) {
					return new type(args[0], args[1], args[2], args[3], args[4]);
				}
				if (args.length == 6) {
					return new type(args[0], args[1], args[2], args[3], args[4],
						args[5]);
				}
				if (args.length == 7) {
					return new type(args[0], args[1], args[2], args[3], args[4],
						args[5], args[6]);
				}
				if (args.length == 8) {
					return new type(args[0], args[1], args[2], args[3], args[4],
						args[5], args[6], args[7]);
				}
				if (args.length == 9) {
					return new type(args[0], args[1], args[2], args[3], args[4],
						args[5], args[6], args[7], args[8]);
				}
				if (args.length == 10) {
					return new type(args[0], args[1], args[2], args[3], args[4],
						args[5], args[6], args[7], args[8], args[9]);
				}
				if (args.length == 11) {
					return new type(args[0], args[1], args[2], args[3], args[4],
						args[5], args[6], args[7], args[8], args[9], args[10]);
				}
				if (args.length == 12) {
					return new type(args[0], args[1], args[2], args[3], args[4],
						args[5], args[6], args[7], args[8], args[9], args[10], args[11]);
				}
				if (args.length == 13) {
					return new type(args[0], args[1], args[2], args[3], args[4],
						args[5], args[6], args[7], args[8], args[9], args[10], args[11],
						args[12]);
				}
				if (args.length == 14) {
					return new type(args[0], args[1], args[2], args[3], args[4],
						args[5], args[6], args[7], args[8], args[9], args[10], args[11],
						args[12], args[13]);
				}
			}
		}
		return null;
	}
}
var bool: RegExp = /^(true|false)$/i;