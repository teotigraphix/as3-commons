package org.as3commons.logging.util {
	import flash.display.Stage;
	
	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public class SWFInfo {
		
		public static const URL_ERROR: String = "<SWF url not initialized. Please call 'SWFInfo.init(stage)'.>";
		public static var URL: String = URL_ERROR;
		public static var SHORT_URL: String = URL;
		
		public static function init(stage:Stage):void {
			if( stage ) {
				var url:String=stage.loaderInfo.loaderURL;
				URL=url;
				SHORT_URL=url.substring( url.lastIndexOf("/") + 1 );
			} else {
				URL=SHORT_URL=URL_ERROR;
			}
		}
		
	}
}
