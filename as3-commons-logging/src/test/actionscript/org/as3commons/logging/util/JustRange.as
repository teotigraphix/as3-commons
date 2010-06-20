package org.as3commons.logging.util {
	import org.mockito.api.Invocation;
	import org.mockito.api.Invocations;
	import org.mockito.api.Verifier;
	import org.mockito.impl.InvocationsNotInOrder;

	/**
	 * @author mh
	 */
	public class JustRange implements Verifier {
		private var _minInvocations:int;
		
		public function JustRange( minInvocations: int = 0 ) {
			_minInvocations = minInvocations;
		}
		
		public function verify(wanted:Invocation, invocations:Invocations ):void {
			var all: Array = invocations.getEncounteredInvocations().source;
			var j: int = 0;
			for( var i: int = invocations.sequenceNumber+1; i < all.length; ++i ) {
				var invocation: Invocation = Invocation( all[i] );
				j++;
				if( !wanted.matches( invocation ) ) {
					throw new InvocationsNotInOrder( "All the rest should have been of same type" );
				}
			}
			if( j < _minInvocations ) {
				throw new InvocationsNotInOrder( "At least " + _minInvocations + " required but just " + j + " done." );
			}
			invocations.sequenceNumber = all.length-1;
		}
	}
}
