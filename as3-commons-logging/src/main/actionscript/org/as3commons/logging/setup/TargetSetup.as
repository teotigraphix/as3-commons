package org.as3commons.logging.setup {
	import org.as3commons.logging.ILogSetup;
	import org.as3commons.logging.LogTargetLevel;
	

	/**
	 * @author mh
	 */
	public class TargetSetup implements ILogSetup {
		
		private var _level:LogTargetLevel;
		private var _target:ILogTarget;
		
		public function TargetSetup( target: ILogTarget, level: LogTargetLevel = null ) {
			_target = target;
			_level = _target ? level || LogTargetLevel.ALL : null;
		}
		
		public function getTarget(name:String):ILogTarget {
			return _target;
		}
		
		public function getLevel(name:String):LogTargetLevel {
			return _level;
		}
	}
}
