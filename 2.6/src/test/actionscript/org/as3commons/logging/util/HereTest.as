package org.as3commons.logging.util {
	import flexunit.framework.TestCase;

	import flash.utils.getQualifiedClassName;
	/**
	 * @author mh
	 */
	public class HereTest extends TestCase {
		
		private var _setta : String;
		
		namespace test;
		
		public function HereTest() {
			assertEquals( "org.as3commons.logging.util.HereTest:15", here() );
		}
		
		public function testHere(): void {
			assertEquals( "org.as3commons.logging.util.HereTest/testHere:19", here() );
			assertRegExp( /HereTest\$.*\/local\:53/, local() );
			assertEquals( "org.as3commons.logging.util.HereTest/testHere:21", here() );
			assertEquals( "org.as3commons.logging.util.HereTest/get getta:47", getta );
			setta=0;
			assertEquals( "org.as3commons.logging.util.HereTest/set setta:43", _setta );
			var localCls: LocalClass = new LocalClass();
			assertEquals( "LocalClass:61", localCls.inConst );
			assertEquals( "LocalClass/local:65", localCls.local() );
			assertEquals( "org.as3commons.logging.util.HereTest$/stadic:38", stadic() );
			assertEquals( "org.as3commons.logging.util.HereTest/namespashe:34", test::namespashe() );
			assertEquals( "org.as3commons.logging.util/hereTestFunction:6", hereTestFunction() );
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

class LocalClass {
	
	public var inConst: String;
	
	public function LocalClass() {
		inConst = here();
	}
	
	function local(): String {
		return here();
	}
}