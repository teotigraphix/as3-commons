package org.as3commons.logging.util {
	import flash.utils.getQualifiedClassName;
	/**
	 * @author mh
	 */
	public function toLogName( object:* ):String {
		if(object is String) {
			return object;
		} else {
			// replace the colons (::) in the name since this is not allowed in the Flex logging API
			return getQualifiedClassName( object ).replace("::", ".");
		}
	}
}
