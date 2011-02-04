package org.as3commons.logging.util {
	import org.mockito.api.Invocation;
	import org.mockito.api.Invocations;
	import org.mockito.impl.Times;

	/**
	 * @author Martin
	 */
	public class TimesRange extends Times {
		private var _maxTimes:int;
		private var _minTimes:int;

		public function TimesRange(minTimes:int,maxTimes:int ) {
			super(0);
			if( minTimes > maxTimes )
			{
				_minTimes = maxTimes;
				_maxTimes = minTimes;
			}
			else
			{
				_minTimes = minTimes;
				_maxTimes = maxTimes;
			}
		}

		override public function verify(wanted:Invocation, invocations:Invocations):void {
			var counter:int = 0;
			
			for each (var iv:Invocation in invocations.getEncounteredInvocations()) {
				if (wanted.matches(iv)) {
					++counter;
					if( counter > _maxTimes )
					{
						throw new Error("Excuted more often than expected: "+_maxTimes+" is max, while "+counter+" times executed.", wanted.describe() );
					}
				}
			}
			
			if( counter < _minTimes )
			{
				throw new Error("Not executed often enough: "+_minTimes+" is required, while "+counter+" times executed.", wanted.describe() );
			}
		}
	}
}
