package org.as3commons.logging {
	
	import org.as3commons.logging.setup.ILogTarget;

	/**
	 * @author mh
	 */
	public interface ILogSetup {
		function getTarget(name:String):ILogTarget;
		function getLevel(name:String):LogSetupLevel;
	}
}
