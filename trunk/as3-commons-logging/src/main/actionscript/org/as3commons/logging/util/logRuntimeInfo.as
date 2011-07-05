/**
 * 
 */
package org.as3commons.logging.util {
	
	import flash.system.Capabilities;
	import flash.display.Stage;
	
	/**
	 * @author Martin Heidegger
	 */
	public function logRuntimeInfo(stage:Stage): void {
		if( logger.infoEnabled ) {
			SWFInfo.init(stage);
			logger.info("--- Runtime information ---"
				+ "\n\tPlayer Version: " + Capabilities.playerType + ( Capabilities.isDebugger ? "(debug)" : "" )
				+ "\n\tCPU architecture: " + Capabilities.cpuArchitecture
				+ "\n\tSWF path: " + SWF_URL + " (" + stage.loaderInfo.bytesLoaded + "bytes, swfVersion: " + stage.loaderInfo.swfVersion + ")"
				+ "\n\tStage: " + stage.stageWidth + "x" + stage.stageHeight + "@" + stage.frameRate + "fps  in state:" + stage.displayState
				+ "\n\tDisplay: " + Capabilities.isDebugger 
			);
		}
	}
}
import org.as3commons.logging.ILogger;
import org.as3commons.logging.getLogger;

const logger: ILogger = getLogger(null);
