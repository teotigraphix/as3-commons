package org.as3commons.logging.setup {
	import org.as3commons.logging.ILogSetup;
	import org.as3commons.logging.LogSetupLevel;
	

	/**
	 * @author mh
	 */
	public class TargetSetup implements ILogSetup {
		
		private var _level:LogSetupLevel;
		private var _target:ILogTarget;
		
		public function TargetSetup( target: ILogTarget, level: LogSetupLevel = null ) {
			_target = target;
			_level = _target ? level || LogSetupLevel.ALL : null;
		}
		
		public function getTarget(name:String):ILogTarget {
			return _target;
		}
		
		public function getLevel(name:String):LogSetupLevel {
			return _level;
		}
	}
}
