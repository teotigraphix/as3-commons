package org.as3commons.logging.setup.target {
	import org.as3commons.logging.LogLevel;
	import org.as3commons.logging.setup.ILogTarget;

	/**
	 * @author mh
	 */
	public final class MergedTarget implements ILogTarget {
		
		private var _logTargetA:ILogTarget;
		private var _logTargetB:ILogTarget;
		
		public function MergedTarget( logTargetA: ILogTarget, logTargetB: ILogTarget ) {
			_logTargetA = logTargetA;
			_logTargetB = logTargetB;
		}
		
		public function log(name: String, shortName: String, level: LogLevel, timeStamp: Number, message: String, parameters: Array): void {
			_logTargetA.log(name, shortName, level, timeStamp, message, parameters);
			_logTargetB.log(name, shortName, level, timeStamp, message, parameters);
		}
	}
}
