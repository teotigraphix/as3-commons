package org.as3commons.logging.util {
	import org.mockito.api.Invocation;
	import org.mockito.integrations.currentMockito;
	
	import mx.collections.ArrayCollection;
	
	import org.mockito.api.Invocations;
	
	/**
	 * @author mh
	 */
	public function verifyNothingCalled( mock: *): void {
		var invocations: Invocations = currentMockito.getInvocationsFor( mock );
		var encountered: ArrayCollection = invocations.getEncounteredInvocations();
		if( encountered.length != 0 ) {
			var invocation: Invocation = encountered.getItemAt( encountered.length-1 ) as Invocation;
			if( invocations.sequenceNumber < invocation.sequenceNumber ) {
				throw new Error( "VerifyNothing: At least following method was called: " + invocation.describe() );
			}
		}
	}
}
