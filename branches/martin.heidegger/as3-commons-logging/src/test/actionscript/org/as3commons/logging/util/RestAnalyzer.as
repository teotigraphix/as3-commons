package org.as3commons.logging.util {
	import org.mockito.api.Invocation;
	import org.mockito.impl.InvocationsNotInOrder;
	import org.mockito.integrations.currentMockito;

	import mx.collections.ArrayCollection;

	/**
	 * @author mh
	 */
	public class RestAnalyzer {
		
		private var _invocations:ArrayCollection;
		private var _to:int;
		
		public function RestAnalyzer( mock: * ) {
			_invocations = currentMockito.getInvocationsFor(mock).getEncounteredInvocations();
			_to = _invocations.length;
		}
		
		public function choose( ...args: Array ): void {
			for( var i: int = 0; i<_to; ++i ) {
				var invocation: Invocation = _invocations.getItemAt(i) as Invocation;
				var foundMatch: Boolean = false;
				for( var j: int = _to; j < _invocations.length; ++j ) {
					var wanted: Invocation = _invocations.getItemAt(j) as Invocation;
					if( invocation.matches( wanted ) ) {
						foundMatch = true;
						break;
					}
				}
				if( foundMatch ) {
					throw new InvocationsNotInOrder( invocation.describe() + " is not expected." ); 
				}
			}
		}
	}
}
