package org.as3commons.logging.util {
	import org.mockito.integrations.argThat;
	/**
	 * @author mh
	 */
	public function alike( compare: * ): * {
		argThat( new AlikeMatcher( compare ) );
		return null;
	}
}
