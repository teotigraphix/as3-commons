package org.as3commons.logging.setup.target {
	import flexunit.framework.TestCase;

	import org.as3commons.logging.LogTests;
	import org.as3commons.logging.util.SWFInfo;

	/**
	 * @author mh
	 */
	public class SWFInfoTest extends TestCase {
		public function SWFInfoTest(methodName:String = null) {
			super(methodName);
		}
		public function testSetup(): void {
			assertEquals( SWFInfo.URL, SWFInfo.URL_ERROR );
			assertEquals( SWFInfo.SHORT_URL, SWFInfo.URL_ERROR );
			
			SWFInfo.init( LogTests.STAGE );
			
			var url: String = LogTests.STAGE.loaderInfo.url;
			assertEquals( url, SWFInfo.URL );
			assertEquals( url.substring( url.lastIndexOf("/") + 1 ), SWFInfo.SHORT_URL );
			
			SWFInfo.init( null );
			
			assertEquals( SWFInfo.URL, SWFInfo.URL_ERROR );
			assertEquals( SWFInfo.SHORT_URL, SWFInfo.URL_ERROR );
		}
	}
}
