package org.as3commons.logging.setup {
	
	import org.as3commons.logging.ILogSetup;
	import org.as3commons.logging.Logger;
	
	/**
	 * @author Martin Heidegger
	 * @since 2
	 */
	public class LevelTargetSetup implements ILogSetup {
		
		private var _level:LogSetupLevel;
		private var _target:ILogTarget;
		
		public function LevelTargetSetup( target: ILogTarget, level: LogSetupLevel ) {
			_target = target;
			_level = level;
		}
		
		public function applyTo(logger:Logger):void {
			_level.applyTo(logger, _target);
		}
	}
}
