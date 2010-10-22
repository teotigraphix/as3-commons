package org.as3commons.logging.setup.target {
	import org.as3commons.logging.LogTests;
	import org.as3commons.logging.util.SWFInfo;
	import flexunit.framework.TestCase;

	import org.as3commons.logging.level.DEBUG;

	import flash.filesystem.File;

	/**
	 * @author mh
	 */
	public class AirTargetTest extends TestCase {
		
		public function testMe() : void {
			SWFInfo.init( LogTests.STAGE );
			
			var target : AirFileTarget = new AirFileTarget();
			target.log( "test", "test", DEBUG, 0, "Hello World", [] );
			target.dispose();
			
			var file: File = new File();
		}
	}
}
