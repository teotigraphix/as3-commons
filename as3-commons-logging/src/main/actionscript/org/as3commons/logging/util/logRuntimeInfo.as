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
			logger.info(
				 "\n\tPlayer Version: " + Capabilities.playerType + ( Capabilities.isDebugger ? "(debug)" : "" )
				+ "\n\t" + Capabilities.cpuArchitecture + " CPU architecture on OS: " + Capabilities.os
				+ "\n\tSWF path: " + SWF_URL + " (" + stage.loaderInfo.bytesTotal  + "bytes)"
				+ "\n\tStage: " + stage.stageWidth + "x" + stage.stageHeight + "@" + stage.frameRate + "fps  in state:" + stage.displayState
				+ "\n\tDisplay: " + Capabilities.screenResolutionX + "x" + Capabilities.screenResolutionY + "@" + Capabilities.screenColor
				+ "\n\tSupport: 32bit | 64bit | Accessability | IME | AudioEncoder | VideoEncoder | AV hardware disable"
				+ "\n\t         {0}   | {1}   | {2}           | {3} | {4}          | {5}          | {6} "
				+ "\n\tLocale: " + Capabilities.language + " in " + GMT
				+ "\n\tTouchscreen: " + getProp( Capabilities, "touchscreenType"),
				[
					check( Capabilities, "supports32BitProcesses" ),
					check( Capabilities, "supports64BitProcesses" ),
					check( Capabilities, "hasAccessibility"),
					check( Capabilities, "hasIME"),
					check( Capabilities, "hasAudioEncoder" ),
					check( Capabilities, "hasVideoEncoder" ),
					check( Capabilities, "avHardwareDisable" )
				]
			);
		}
	}
}
import org.as3commons.logging.ILogger;
import org.as3commons.logging.getLogger;

const logger: ILogger = getLogger("org.as3commons.logging.util/logRuntimeInfo");

function check( obj: Object, property: String ): String {
	return getProp( obj, property ) ? "yes": "no ";
}

function getProp( obj:Object, property: String ): * {
	if( obj.hasOwnProperty(property) ) {
		return obj[property];
	}
	return null;
}