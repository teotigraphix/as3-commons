package org.as3commons.logging.util {
	import flash.display.Stage;
	
	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public class SWFInfo {
		
		public static const URL_ERROR: String = "[SWF url not initialized. Please call SWFInfo.init(stage).]";
		
		public static function init(stage:Stage):void {
			if( stage ) {
				var url:String=stage.loaderInfo.loaderURL;
				SWF_URL=url;
				SWF_SHORT_URL=url.substring( url.lastIndexOf("/") + 1 );
			} else {
				SWF_URL=SWF_SHORT_URL=URL_ERROR;
			}
		}
		
		{
			init( null );
		}
	}
}
