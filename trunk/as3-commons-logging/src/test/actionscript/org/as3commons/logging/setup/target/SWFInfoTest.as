package org.as3commons.logging.setup.target {
	import flexunit.framework.TestCase;

	import org.as3commons.logging.STAGE;
	import org.as3commons.logging.util.SWFInfo;
	import org.as3commons.logging.util.SWF_SHORT_URL;
	import org.as3commons.logging.util.SWF_URL;
	import org.as3commons.logging.util.URL_ERROR;

	import flash.display.Stage;


	/**
	 * @author mh
	 */
	public class SWFInfoTest extends TestCase {
		public function SWFInfoTest(methodName:String = null) {
			super(methodName);
		}
		public function testSetup(): void {
			assertEquals( SWF_URL, URL_ERROR );
			assertEquals( SWF_SHORT_URL, URL_ERROR );
			
			SWFInfo.init( STAGE );
			
			var url : String = STAGE.loaderInfo.url;
			assertEquals(url, SWF_URL);
			assertEquals( url.substring( url.lastIndexOf("/") + 1 ), SWF_SHORT_URL );
			
			SWFInfo.init( null );
			
			assertEquals( SWF_URL, URL_ERROR );
			assertEquals( SWF_SHORT_URL, URL_ERROR );
		}
	}
}
