package org.as3commons.logging.util {
	import org.flexunit.AssertionError;
	/**
	 * @author mh
	 */
	public function assertRegExp( regexp: RegExp, str: String ): void {
		if( !regexp.test( str ) ) {
			throw new AssertionError( str + " didnt match regexp: " + regexp );
		}
	}
}
