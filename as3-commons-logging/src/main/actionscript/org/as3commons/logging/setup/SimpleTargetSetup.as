package org.as3commons.logging.setup {
	import org.as3commons.logging.ILogSetup;
	import org.as3commons.logging.Logger;

	/**
	 * @author Martin Heidegger
	 * @since 2.0
	 */
	public class SimpleTargetSetup implements ILogSetup {
		
		private var target: ILogTarget;
		
		public function SimpleTargetSetup(target:ILogTarget) {
			this.target = target;
		}
		
		public function applyTo(logger:Logger): void {
			logger.allTargets = target;
		}
	}
}
