package org.as3commons.logging.util {
	import flexunit.framework.TestCase;
	/**
	 * @author mh
	 */
	public class HereTest extends TestCase {
		
		private var _setta : String;
		
		namespace test;
		
		public function HereTest() {
			assertEquals( "org.as3commons.logging.util::HereTest:13", here() );
		}
		
		public function testHere(): void {
			assertEquals( "org.as3commons.logging.util::HereTest/testHere:17", here() );
			assertRegExp( /Function\/HereTest\.as\$.*\:local\:48/, local() );
			assertEquals( "org.as3commons.logging.util::HereTest/get getta:41", getta );
			setta=0;
			assertEquals( "org.as3commons.logging.util::HereTest/set setta:37", _setta );
			assertEquals( "org.as3commons.logging.util::HereTest$/stadic:32", stadic() );
			assertEquals( "org.as3commons.logging.util::HereTest/namespashe:28", test::namespashe() );
			assertEquals( "global/org.as3commons.logging.util::hereTestFunction:6", hereTestFunction() );
		}
		
		test function namespashe(): String {
			return here();
		}
		
		public static function stadic():String {
			return here();
		}
		
		public function set setta(no: Number):void {
			no;
			_setta = here();
		}
		
		public function get getta(): String {
			return here();
		}
	}
}

import org.as3commons.logging.util.here;
function local():String {
	return here();
}